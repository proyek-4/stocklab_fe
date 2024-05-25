import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:stocklab_fe/colors.dart';
import 'package:stocklab_fe/network/AuthService.dart';

class RegisterForm extends StatefulWidget {
  final double height;
  final double width;

  RegisterForm({
    required this.height,
    required this.width,
  });

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary,
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
                    height: widget.height / 7,
                    width: widget.height / 7,
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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Daftar Baru',
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
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
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
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
                setState(() {
                  isLoading = true;
                });
                try {
                  await AuthService.register(
                    nameController.text,
                    usernameController.text,
                    emailController.text,
                    passwordController.text,
                    confirmPasswordController.text,
                  );
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    text: "Registration successful.",
                  );
                } catch (e) {
                  // QuickAlert.show(
                  //   context: context,
                  //   type: QuickAlertType.error,
                  //   text: e.toString(),
                  // );
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Registrasi Gagal'),
                        content: Text(e.toString()),
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
                } finally {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              child: isLoading
                  ? CircularProgressIndicator() // Tampilkan indicator loading jika sedang loading
                  : Text(
                      'Register',
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
        ],
      ),
    );
  }
}
