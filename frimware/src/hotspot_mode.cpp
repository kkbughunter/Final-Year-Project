#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <LittleFS.h>

#define H_SSID "esp8266"
#define H_PASSWORD "qwertyuiop"
#define EXCHANGE_PORT 20002
#define BROADCAST_PORT 20001
#define CTRL_PORT 20000
#define BUFF_SIZE 8

WiFiUDP broadcast, control;
WiFiServer tcp(EXCHANGE_PORT);
WiFiClient conn;

bool wifi_setup=false;
bool wifi_conn=false;
String ssid;
String password;

String read_data(String file_name)
{
  File file = LittleFS.open("/"+file_name,"r");
  if (!file)
  {
    return "";
  }
  while (file.available())
  {
    return file.readString();
  }
  file.close();
  return "";
}

void write_data(String file_name, String data)
{
  File file = LittleFS.open("/"+file_name,"w");
  file.print(data);
  delay(1);
  file.close();
  Serial.println("Data saved");
}

void remove_data(String file_name)
{
  LittleFS.remove("/"+file_name);
  Serial.println("data removed");
}

void wifi_connect(String ssid, String password)
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid,password);
  Serial.print("Connecting .");
  while (WiFi.status()!=WL_CONNECTED)
  {
    delay(1000);
    Serial.print(".");
  }
  
  if (WiFi.status()==WL_CONNECTED)
  {
    Serial.print("\nConnected as ");
    Serial.print(WiFi.localIP());
    Serial.print(" | ");
    Serial.println(WiFi.subnetMask());
  }
}
void wifi_mode()
{
  if (WiFi.status()!=WL_CONNECTED) wifi_connect(ssid,password);
  if (broadcast.parsePacket())
  {
    Serial.print("Received message from ");
    Serial.print(broadcast.remoteIP());
    Serial.print(" : ");
    Serial.println(broadcast.remotePort());
    char msg[BUFF_SIZE];
    int len = broadcast.read(msg,BUFF_SIZE);
    if (len>0) msg[len]='\0';
    Serial.printf("msg : %s\n", msg);

    if (strcmp(msg,"BRDCST")==0)
    {
      broadcast.beginPacket(broadcast.remoteIP(),broadcast.remotePort());
      broadcast.write("ACK-B");
      broadcast.endPacket();
    }
   
  }
  if (control.parsePacket())
  {
    Serial.print("Received message from ");
    Serial.print(control.remoteIP());
    Serial.print(" : ");
    Serial.println(control.remotePort());
    char msg[BUFF_SIZE];
    int len = control.read(msg,BUFF_SIZE);
    if (len>0) msg[len]='\0';
    Serial.printf("msg : %s\n", msg);
    
    if (strcmp(msg,"D1-ON")==0)
    {
      digitalWrite(2,1);
    }
    else if (strcmp(msg,"D1-OFF")==0)
    {
      digitalWrite(2,0);
    }
    else if (strcmp(msg,"CRED-RST")==0)
    {
      remove_data("data");
      wifi_setup=false;
    }
  }
}

void parse_data(String data)
{
  int len = data.length();
  Serial.println(data);
  Serial.println(len);
  String * ptr = & ssid;
  for (int i = 0; i<len; i++)
  {
    if ((char)data[i]=='\n')
    {
      ptr = & password;
      continue;
    }
    
    *ptr = *ptr + data[i];
  }
  Serial.println(ssid);
  Serial.println(password);
}

void hotspot()
{
  WiFi.softAP(H_SSID,H_PASSWORD);
  Serial.println("starting hotspot");
}

void get_wifi_creds()
{
  hotspot();
  delay(1000);
  tcp.begin();

  while (!conn)
  {           // wifi_mode() can also be placed here with watch_dog dissabled
    conn = tcp.accept();
    if (conn && conn.connected())
    {
      Serial.print("Connection established with ");
      Serial.println(conn.remoteIP());
    }
  }

  conn.write("CRED-REQ");
  String msg,data;
  while (conn.connected())
  {
    while (conn.available())
    {
      msg=conn.readString();
      if (msg=="END")
      {
        File file = LittleFS.open("/data","w");
        file.print(data);
        Serial.println("writing");
        conn.stop();
        break;
      }
      else data=msg;
    }
    if (msg=="END") break;
  }
  parse_data(data);
  wifi_connect(ssid,password);
  wifi_setup = true;
}

void setup() {
  Serial.begin(115200);

  pinMode(2,OUTPUT);
  digitalWrite(2,1);

  if (!LittleFS.begin())
  {
    Serial.println("File System not accessible");
  }
  else Serial.println("Accessing File system");
 
  broadcast.begin(BROADCAST_PORT); //req : control with setup flag
  control.begin(CTRL_PORT);    //

  String data = read_data("data");
  Serial.println(data);
  if (data!=0)
  {
     wifi_setup=true;
     parse_data(data);
     wifi_connect(ssid,password);
  }
  else
  {
    wifi_setup=false;
    get_wifi_creds();
  }
}

void loop()
{
  if (wifi_setup)
  {
    wifi_mode();
    Serial.println("wifi mode");
  }
  else
  {
    Serial.println("cred transfer mode");
    get_wifi_creds();
  }
  if (Serial.available() && Serial.read()=='x')
  {
    conn.stop();
    ESP.restart();
  }
}
