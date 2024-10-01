#include <Arduino.h>
#if defined(ESP32) || defined(ARDUINO_RASPBERRY_PI_PICO_W)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#elif __has_include(<WiFiNINA.h>)
#include <WiFiNINA.h>
#elif __has_include(<WiFi101.h>)
#include <WiFi101.h>
#elif __has_include(<WiFiS3.h>)
#include <WiFiS3.h>
#endif

#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include <addons/RTDBHelper.h>

#define WIFI_SSID "SSN"
#define WIFI_PASSWORD "Ssn1!Som2@Sase3#"

#define API_KEY "AIzaSyB3usuxJqpEtKSl6i8eRmYAFip_fR-T_No"
#define DATABASE_URL "https://final-year-project-400d2-default-rtdb.asia-southeast1.firebasedatabase.app"
#define USER_EMAIL "karthikeyan.aas@gmail.com"
#define USER_PASSWORD "1234567890"

FirebaseData stream;
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;
int count = 0;
volatile bool dataChanged = false;

// Data
String s1;

// PIN Config
const int D4_PIN = 2;
const int light_switch = 3;
volatile bool state = false;

void streamCallback(FirebaseStream data)
{

  // print path and status of the topic
  Serial.print(data.streamPath().c_str());
  Serial.printf(" - %s\n", data.payload().c_str());
  // Serial.println( data.payload().c_str());
  // Serial.println( "Test");
  s1 = data.payload().c_str();
  // s1.remove(0, 1);
  // s1.remove(s1.length() - 1);

  Serial.printf("Received stream payload size: %d (Max. %d)\n\n", data.payloadLength(), data.maxPayloadLength());
  dataChanged = true;
}

void streamTimeoutCallback(bool timeout)
{
  if (timeout)
    Serial.println("stream timed out, resuming...\n");

  if (!stream.httpConnected())
    Serial.printf("error code: %d, reason: %s\n\n", stream.httpCode(), stream.errorReason().c_str());
  // --->wifi checks should be here
}

void setup()
{
  Serial.begin(115200);

  // 1) WIFI Config
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  // 2) PIN Config
  pinMode(D4_PIN, OUTPUT);
  pinMode(light_switch, INPUT);
  state = digitalRead(light_switch);

  // 3) FIREBASE Config
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback;
  Firebase.reconnectNetwork(true);
  fbdo.setBSSLBufferSize(2048, 1024);
  stream.setBSSLBufferSize(2048, 1024);
  Firebase.begin(&config, &auth);

  // Listen to the path
  if (!Firebase.RTDB.beginStream(&stream, "/devices/d1/status")) // change the path
    Serial.printf("sream begin error, %s\n\n", stream.errorReason().c_str());

  Firebase.RTDB.setStreamCallback(&stream, streamCallback, streamTimeoutCallback);
}

void loop()
{
  Firebase.RTDB.runStream();

  if (Firebase.ready() && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0))
  {
    // Code to send data if needed
  }

  if (dataChanged)
  {
    dataChanged = false;
    if (s1 == "true")
    {
      Serial.println("S1 Switch ON");
      digitalWrite(D4_PIN, LOW);
    }
    else
    {
      Serial.println("S1 Switch OFF");
      digitalWrite(D4_PIN, HIGH);
    }
  }

  bool current_state = digitalRead(light_switch);
  if (current_state != state)
  {
    if (current_state)
    {
      Serial.println("Local S1 Switch ON");
      digitalWrite(light_switch, HIGH);
    }
    else
    {
      Serial.println("Local S1 Switch OFF");
      digitalWrite(light_switch, LOW);
    }
    // --->data upload should be here
    state = current_state;
  }

  if (!stream.httpConnected())
  {
    Serial.println("Server was disconnected!");
  }
}
