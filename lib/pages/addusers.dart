import 'package:flutter/material.dart';
import 'package:intelli_ca/models/auth_gate.dart';
import 'package:intelli_ca/models/chatservice.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AddUserScreen extends StatelessWidget {
  final Chatservice _chatservice = Chatservice();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _chatservice.getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No users found"));
        }
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != getCurrentUser()!.email) {
      return ListTile(
        leading: Icon(Icons.person),
        title: Text(userData["email"] ?? "No email"),
        trailing: IconButton(
          icon: Icon(Icons.add_circle_outline, size: 30),
          onPressed: () {
            _addUserToHomepage(userData["email"]);
          },
        ),
      );
    } else {
      return Container();
    }
  }

  void _addUserToHomepage(String userEmail) async {
    String currentUserEmail = getCurrentUser()!.email!;

    DocumentReference userDoc1 =
        FirebaseFirestore.instance.collection('users').doc(currentUserEmail);

    await userDoc1.update({
      'addedUsers': FieldValue.arrayUnion([userEmail])
    });

    DocumentReference userDoc2 =
        FirebaseFirestore.instance.collection('users').doc(userEmail);

    await userDoc2.update({
      'addedUsers': FieldValue.arrayUnion([currentUserEmail])
    });
  }
}
