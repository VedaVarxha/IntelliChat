import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intelli_ca/Addons/intelliChatUser.dart';
import 'package:intelli_ca/pages/createUser.dart';
import 'addusers.dart';
import 'profilepage.dart';
import 'chatscreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<IntelliChatUser?> _getUserProfile() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .get();

      if (userDoc.exists) {
        return IntelliChatUser(
          name: userDoc['name'],
          email: userDoc['email'],
          about: userDoc['about'],
          time: userDoc['time'],
        );
      }
    }
    return null;
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chats',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Get.changeThemeMode(
                    Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
              },
              icon: Icon(
                Get.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Implement search functionality here
              },
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add User',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        //return Text("Under Maintenance");
        return _buildAddedUsersList();
      case 1:
        return FutureBuilder<IntelliChatUser?>(
          future: _getUserProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data != null) {
              return ProfileScreen(snapshot.data!);
            } else {
              return Createprofile();
            }
          },
        );
      case 2:
        return AddUserScreen();
      default:
        // return Text("Under Maintenance");
        return _buildAddedUsersList();
    }
  }

  Widget _buildAddedUsersList() {
    String currentUserEmail = FirebaseAuth.instance.currentUser!.email!;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserEmail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }


        var userData = snapshot.data!.data() as Map<String, dynamic>?;

        if (userData == null || userData['addedUsers'] == null) {
          return const Center(child: Text("No users added"));
        }

        var addedUsers = userData['addedUsers'] as List<dynamic>;


        if (addedUsers.isEmpty) {
          return const Center(child: Text("No users added"));
        }

        return ListView.builder(
          itemCount: addedUsers.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(addedUsers[index])
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(title: Text("Loading..."));
                }

                if (userSnapshot.hasError ||
                    !userSnapshot.hasData ||
                    userSnapshot.data == null) {
                  return const ListTile(title: Text("Error loading user"));
                }

                var user = userSnapshot.data!.data() as Map<String, dynamic>?;
                if (user == null) {
                  return const ListTile(title: Text("Error loading user data"));
                }

                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(user['email'] ?? 'No email'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          recieverEmail: user['email'],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
