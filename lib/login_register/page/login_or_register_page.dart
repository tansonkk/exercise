import 'package:flutter/material.dart';
import 'package:flutter_application_2/login_register/page/login_page.dart';
import 'register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterPageState();
}

class _LoginOrRegisterPageState extends State<LoginOrRegisterPage> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register
  togglePages() {
    // void togglePages(bool bool) {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      print("loginPage");
      return LoginPage(onTap: togglePages);
    } else {
      print("registerPage");
      return RegisterPage(onTap: togglePages);
    }
  }
}
