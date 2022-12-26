import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curae/firebase_options.dart';
import 'package:curae/screens/authentication/authentication_screen.dart';
import 'package:curae/screens/authentication/details_screen.dart';
import 'package:curae/screens/authentication/login_screen.dart';
import 'package:curae/screens/dashboard/helper_screen.dart';
import 'package:curae/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final _auth = FirebaseAuth.instance;
final usersDb = FirebaseFirestore.instance.collection('users');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Curae',
      theme: ThemeData(
        fontFamily: 'Playfair',
        scaffoldBackgroundColor: primaryColor,
        primaryTextTheme:
            TextTheme(bodyMedium: TextStyle(color: primaryTextColor)),
      ),
      home: SafeArea(
        child: Scaffold(
          body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return HelperScreen();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return AuthenticationScreen();
              }
            },
          ),
        ),
      ),
      routes: {
        'helper-screen': (context) => HelperScreen(),
      },
    );
  }
}
