import 'package:flutter/material.dart';
import 'package:stocklab_fe/colors.dart';

class BottomNavigationBarMain extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem> navItems;

  const BottomNavigationBarMain({
    Key? key,
    required this.pages,
    required this.navItems,
  }) : super(key: key);

  @override
  State<BottomNavigationBarMain> createState() =>
      _BottomNavigationBarMainState();
}

class _BottomNavigationBarMainState extends State<BottomNavigationBarMain> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: widget.navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
