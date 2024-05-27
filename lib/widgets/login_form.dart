import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocklab_fe/colors.dart';
import 'package:stocklab_fe/network/AuthService.dart';
import 'package:stocklab_fe/pages/home_page.dart';
import 'package:stocklab_fe/pages/main_page.dart';
import 'package:stocklab_fe/provider/UserProvider.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  // final AuthService authService;
  final double height;
  final double width;

  LoginForm({
    required this.emailController,
    required this.passwordController,
    // required this.authService,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
      height: height,
      width: width,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0, top: 50.0),
                  child: Image.asset(
                    'assets/icon/icon.png',
                    height: height / 7,
                    width: height / 7,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 80.0),
                  child: Text(
                    'StockLab',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.9),
            child: Text(
              'Selamat Datang!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email/Username',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              obscureText: true,
            ),
          ),
          SizedBox(height: 16.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return ElevatedButton(
                  onPressed: () async {
                    await userProvider.login(
                      emailController.text,
                      passwordController.text,
                    );

                    if (userProvider.isLoggedIn) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Login Gagal'),
                            content: Text('Email atau password salah.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: userProvider.isLoading
                      ? CircularProgressIndicator() // Tampilkan indicator loading jika sedang loading
                      : Text(
                          'Login',
                          style: TextStyle(color: primary, fontSize: 18),
                        ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(secondary),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 14),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 56),
                    ),
                  ),
                );
              },
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Lupa Password?',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
