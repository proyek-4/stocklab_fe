import 'package:flutter/material.dart';
import 'package:stocklab_fe/colors.dart';
import 'package:stocklab_fe/network/LoginService.dart';
import 'package:stocklab_fe/pages/home_page.dart';
import 'package:stocklab_fe/widgets/register_form.dart';
import 'package:stocklab_fe/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  var height, width;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final AuthService _authService = AuthService();

    return Scaffold(
      body: Column(
        children: [
          Container(
            // color: primary,
            decoration: BoxDecoration(
              color: primary,
              // borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(),
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromARGB(255, 194, 194, 194),
              tabs: [
                Tab(text: "Login"),
                Tab(text: "Register"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: LoginForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    authService: _authService,
                    height: height,
                    width: width,
                  ),
                ),
                SingleChildScrollView(
                  child: RegisterForm(height: height, width: width),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
