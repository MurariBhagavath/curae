import 'package:curae/components/my_button.dart';
import 'package:curae/components/my_input.dart';
import 'package:curae/components/size_components.dart';
import 'package:curae/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.showSignUp});
  final VoidCallback showSignUp;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Text('Successfully logged in!'),
        backgroundColor: secondaryColor,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(FontAwesomeIcons.lock, size: 56),
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  color: primaryTextColor,
                  letterSpacing: 2,
                ),
              ),
              buildHeight(48),
              Text(
                'Welcome back, good to see you!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              buildHeight(32),
              InputBox(
                  controller: _emailController,
                  hint: 'Email/Username',
                  obscure: false),
              buildHeight(8),
              InputBox(
                controller: _passwordController,
                hint: 'Password',
                obscure: true,
              ),
              buildHeight(24),
              MyButton(onTap: signIn, text: 'SignIn'),
              buildHeight(38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New to the app?',
                    style: TextStyle(fontSize: 12),
                  ),
                  buildWidth(6),
                  GestureDetector(
                    onTap: widget.showSignUp,
                    child: Text(
                      'Signup',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
