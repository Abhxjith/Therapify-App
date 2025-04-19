import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import font_awesome_flutter
import 'home.dart';
import 'history.dart';
import 'userprofile.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(key: _homeKey),
      HistoryPage(),
      UserProfilePage(),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC), // Set the background color to FCFCFC
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home, size: 20), // Adjust icon size
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.history, size: 20), // Adjust icon size
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user, size: 20), // Adjust icon size
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey, // Optional: color for unselected items
        onTap: _onItemTapped,
        iconSize: 24, // Optional: you can also set this to control the overall icon size
        backgroundColor: Color(0xFFFCFCFC), // Set the background color for the BottomNavigationBar
        type: BottomNavigationBarType.fixed, // To ensure all items are shown properly
        showSelectedLabels: true, // Optional: Show or hide labels for selected items
        showUnselectedLabels: true, // Optional: Show or hide labels for unselected items
      ),
    );
  }
}
