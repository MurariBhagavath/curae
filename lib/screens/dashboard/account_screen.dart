import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curae/components/size_components.dart';
import 'package:curae/components/task_tile.dart';
import 'package:curae/models/joke_model.dart';
import 'package:curae/services/joke_api.dart';
import 'package:curae/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, required this.snapshot});
  final QuerySnapshot<Map<String, dynamic>>? snapshot;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isLoading = true;
  var _joke;
  void getJoke() async {
    _joke = await getJokeFromAPI();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getJoke();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //APPBAR
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'CURAE',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 32,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Successfully logged out!'),
                        backgroundColor: secondaryColor,
                        action: SnackBarAction(
                          textColor: Colors.white,
                          label: 'Ok',
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: primaryTextColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            buildHeight(32),
            //DP AND NAME, MAIL
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.snapshot!.docs[0]['profile image'] == ''
                    ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                    : widget.snapshot!.docs[0]['profile image'],
                width: 125,
                height: 125,
                filterQuality: FilterQuality.high,
              ),
            ),
            buildHeight(24),
            Text(
              widget.snapshot!.docs[0]['first name'] +
                  " " +
                  widget.snapshot!.docs[0]['last name'],
              style: TextStyle(color: primaryTextColor, fontSize: 18),
            ),
            Text(
              widget.snapshot!.docs[0]['email'],
              style: TextStyle(color: primaryTextColor, fontSize: 15),
            ),
            buildHeight(24),
            // JOKE BOX
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Here\'s a small joke for you :)',
                    style: TextStyle(fontSize: 18),
                  ),
                  buildHeight(16),
                  isLoading ? Text('Loading') : Text(_joke!.joke),
                ],
              ),
            ),
            buildHeight(24),
            //THHINGS TO DO
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Things to do',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              margin: EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  TaskTile(
                    icon: FontAwesomeIcons.airFreshener,
                    subtitle: 'Breathing helps you in relaxing your mind!',
                    title: 'Go out and take a breathe',
                  ),
                  TaskTile(
                    icon: FontAwesomeIcons.music,
                    subtitle:
                        'Listening to your favorite music will help you in controlling your emotions!',
                    title: 'Listen to your favorite music',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
