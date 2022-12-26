import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curae/components/my_button.dart';
import 'package:curae/components/my_input.dart';
import 'package:curae/components/size_components.dart';
import 'package:curae/screens/dashboard/helper_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _hobbyController = TextEditingController();
  final userDb = FirebaseFirestore.instance.collection('users');
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Complete the details',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          buildHeight(32),
          InputBox(
              controller: _fNameController, hint: 'First name', obscure: false),
          buildHeight(8),
          InputBox(
              controller: _lNameController, hint: 'Last name', obscure: false),
          buildHeight(8),
          InputBox(controller: _ageController, hint: 'Age', obscure: false),
          buildHeight(8),
          InputBox(
              controller: _genderController, hint: 'Gender', obscure: false),
          buildHeight(8),
          InputBox(
              controller: _hobbyController,
              hint: 'Favorite thing to do',
              obscure: false),
          buildHeight(24),
          MyButton(
              onTap: () async {
                showDialog(
                    context: context,
                    builder: (context) =>
                        Center(child: CircularProgressIndicator()));
                String uid = _auth.currentUser!.uid;
                await userDb.doc(uid).set({
                  'email': _auth.currentUser!.email,
                  'first name': _fNameController.text.trim(),
                  'last name': _lNameController.text.trim(),
                  'age': _ageController.text.trim(),
                  'gender': _genderController.text.trim(),
                  'hobby': _hobbyController.text.trim(),
                });
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HelperScreen()));
              },
              text: 'Finish'),
        ],
      ),
    );
  }
}
