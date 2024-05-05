import 'package:flutter/material.dart';
import 'package:stocklab_fe/colors.dart';
import 'package:stocklab_fe/network/LoginService.dart';
import 'package:stocklab_fe/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var height, width;

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final AuthService _authService =
        AuthService(); // Panggil service auth di sini
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
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
                )),
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
                controller: _emailController,
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
            // TextField untuk password
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: TextField(
                controller: _passwordController,
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
              child: ElevatedButton(
                onPressed: () async {
                  // Panggil method login dari AuthService
                  bool success = await _authService.login(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
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
                child: Text(
                  'Login',
                  style: TextStyle(color: primary, fontSize: 18),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(secondary),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(vertical: 14),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(double.infinity, 56),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color:
                        Colors.white, // Atur warna teks sesuai preferensi Anda
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
