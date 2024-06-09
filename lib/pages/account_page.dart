import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklab_fe/colors.dart';
import 'package:stocklab_fe/pages/login_page.dart';
import 'package:stocklab_fe/provider/UserProvider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 20),
            Text(
              userData != null ? userData['name'] : SizedBox(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              userData != null ? userData['email'] : SizedBox(),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Profile'),
              onTap: () {
                // Navigate to edit profile page
              },
            ),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Change Password'),
              onTap: () {
                // Navigate to change password page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Log Out'),
              onTap: () {
                _showLogoutConfirmationDialog(context, userProvider);
                // Log out the user
                // authProvider.logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(
      BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Keluar'),
          content: Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                // MaterialPageRoute(builder: (context) => LoginPage());
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              child: Text('Keluar'),
            ),
          ],
        );
      },
    );
  }
}
