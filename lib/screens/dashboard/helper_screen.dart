import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curae/screens/dashboard/account_screen.dart';
import 'package:curae/screens/dashboard/chat_screen.dart';
import 'package:curae/screens/dashboard/home_screen.dart';
import 'package:curae/styles.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelperScreen extends StatefulWidget {
  const HelperScreen({super.key});

  @override
  State<HelperScreen> createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen> {
  QuerySnapshot<Map<String, dynamic>>? userSnapshot;
  Future getUserSnapshot() async {
    userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
  }

  int _index = 0;

  @override
  void initState() {
    getUserSnapshot();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        HomeScreen(),
        ChatScreen(),
        AccountScreen(snapshot: userSnapshot)
      ][_index],
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 500),
        height: 55,
        backgroundColor: Colors.transparent,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.dashboard,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.solidMessage,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.person,
            ),
          ),
        ],
      ),
    );
  }
}
