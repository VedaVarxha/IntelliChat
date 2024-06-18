import 'package:cloud_firestore/cloud_firestore.dart';

class IntelliChatUser {
  final String name;
  final String email;
  final String about;
  final Timestamp time;

  IntelliChatUser({
    required this.name,
    required this.email,
    required this.about,
    required this.time,
  });
}
