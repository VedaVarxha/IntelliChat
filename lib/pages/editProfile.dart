import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelli_ca/Addons/intelliChatUser.dart';
import 'package:intelli_ca/pages/homepage.dart';

class Editprofile extends StatefulWidget {
  final IntelliChatUser profileModel;

  const Editprofile({super.key, required this.profileModel});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _aboutcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    IntelliChatUser p = widget.profileModel;
    _namecontroller.text = p.name;
    _emailcontroller.text = p.email;
    _aboutcontroller.text = p.about;
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onFormSubmit() async {
      String name = _namecontroller.text;
      String email = _emailcontroller.text;
      String about = _aboutcontroller.text;

      IntelliChatUser updatedUser = IntelliChatUser(
          name: name, email: email, about: about, time: Timestamp.now());

      // Save the updated profile to Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .set({
            'name': updatedUser.name,
            'email': updatedUser.email,
            'about': updatedUser.about,
          })
          .then((value) => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
              ))
          .catchError((error) => print("Failed to update profile: $error"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setup"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Basic Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: _namecontroller,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailcontroller,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _aboutcontroller,
              decoration: InputDecoration(labelText: 'About'),
            ),
            GestureDetector(
              onTap: onFormSubmit,
              child: Container(
                width: double.infinity,
                height: 48,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Color.fromARGB(173, 67, 149, 236)),
                child: const Text(
                  'Submit',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
