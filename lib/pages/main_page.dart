import 'package:flutter/material.dart';
import 'package:stocklab_fe/pages/account_page.dart';
import 'package:stocklab_fe/pages/home_page.dart';
import 'package:stocklab_fe/pages/record_page.dart';
import 'package:stocklab_fe/pages/stock_page.dart';
import 'package:stocklab_fe/widgets/bottom_navigation.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigationBarMain(
        pages: [
          HomePage(),
          StockPage(),
          AccountPage(),
        ],
        navItems: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse_outlined),
            label: 'Gudang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}
