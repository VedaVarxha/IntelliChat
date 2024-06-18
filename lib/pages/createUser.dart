import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intelli_ca/Addons/intelliChatUser.dart';
import 'package:intelli_ca/pages/homepage.dart';

class Createprofile extends StatefulWidget {
  @override
  State<Createprofile> createState() => _CreateprofileState();
}

class _CreateprofileState extends State<Createprofile> {
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _aboutcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> onFormSubmit() async {
      String name = _namecontroller.text;
      String email = _emailcontroller.text;
      String about = _aboutcontroller.text;

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        //String uid = user.uid;
        Timestamp createdTime = Timestamp.now();

        IntelliChatUser updatedUser = IntelliChatUser(
          name: name,
          email: email,
          about: about,
          time: createdTime,
        );

        // Save the updated profile to Firestore with UID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .set({
              'name': updatedUser.name,
              'email': updatedUser.email,
              'about': updatedUser.about,
              //'uid': uid, // Add UID to the document
              'time': createdTime,
            })
            .then((value) => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
                ))
            .catchError((error) => print("Failed to update profile: $error"));
      } else {
        print("No user is signed in");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Setup"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Basic Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
              const SizedBox(
                height: 50,
              ),
              const Text(
                "  NOTE* give your google Email only in Email column",
                style: TextStyle(
                    fontSize: 10, color: Color.fromARGB(255, 239, 63, 63)),
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: onFormSubmit,
                child: Container(
                  width: double.infinity,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: Color.fromARGB(173, 67, 149, 236),
                  ),
                  child: const Text(
                    'Submit',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
