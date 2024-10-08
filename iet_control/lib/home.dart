import 'package:flutter/material.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:iet_control/home_page/home_page.dart';

class Home extends StatefulWidget {
  final String userId;

  const Home({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(userId: widget.userId), // Use widget.userId to pass the userId
      const Center(child: Text('Automate')),
      const Center(child: Text('Store')),
      const Center(child: Text('Profile')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/91019132?v=4',
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Action when the add button is pressed
            },
          ),
        ],
      ),
      body: _pages[_currentPage],
      bottomNavigationBar: DotCurvedBottomNav(
        selectedIndex: _currentPage,
        indicatorColor: Colors.blue,
        backgroundColor: Colors.black,
        indicatorSize: 5,
        borderRadius: 25,
        height: 70,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.ease,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        items: [
          Icon(
            Icons.home,
            color: _currentPage == 0 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.auto_awesome,
            color: _currentPage == 1 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.store,
            color: _currentPage == 2 ? Colors.blue : Colors.white,
          ),
          Icon(
            Icons.person,
            color: _currentPage == 3 ? Colors.blue : Colors.white,
          ),
        ],
      ),
    );
  }
}
