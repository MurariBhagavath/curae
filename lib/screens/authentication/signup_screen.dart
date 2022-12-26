import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curae/components/my_button.dart';
import 'package:curae/components/my_input.dart';
import 'package:curae/components/size_components.dart';
import 'package:curae/screens/authentication/details_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.showLogin});
  final VoidCallback showLogin;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final usersDb = FirebaseFirestore.instance.collection('users');
  Future signUp() async {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      // await usersDb.add({'email': _emailController.text.trim()});

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'SignUp',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              buildHeight(48),
              Text(
                'Fill the details to signup',
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
              buildHeight(8),
              InputBox(
                controller: _confirmPasswordController,
                hint: 'Confirm password',
                obscure: true,
              ),
              buildHeight(24),
              MyButton(
                  onTap: () async {
                    // showDialog(
                    //     context: context,
                    //     builder: (context) {
                    //       return Center(child: CircularProgressIndicator());
                    //     });
                    await signUp();
                    // _auth.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailsScreen()));
                  },
                  text: 'SignUp'),
              buildHeight(38),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already user?',
                    style: TextStyle(fontSize: 12),
                  ),
                  buildWidth(6),
                  GestureDetector(
                    onTap: widget.showLogin,
                    child: Text(
                      'SignIn',
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
