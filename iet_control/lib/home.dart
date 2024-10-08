import 'package:flutter/material.dart';
import 'package:dot_curved_bottom_nav/dot_curved_bottom_nav.dart';
import 'package:iet_control/home_page/home_page.dart';
import 'package:iet_control/profile/profile_page.dart';

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
      HomePage(userId: widget.userId),
      Center(
        child: Image.asset(
          'assets/images/comming_soon.png',
          width: 300,
          height: 300,
          fit: BoxFit.cover,
        ),
      ),
      Center(
        child: Image.asset(
          'assets/images/comming_soon.png',
          width: 400,
          height: 400,
          fit: BoxFit.cover,
        ),
      ),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
