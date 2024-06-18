import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  //final String senderID;
  final String senderEmail;
  final String recieverEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    //required this.senderID,
    required this.senderEmail,
    required this.recieverEmail,
    required this.message,
    required this.timestamp,
  });

  //Convert to Map

  Map<String, dynamic> toMap() {
    return {
      //'senderID': senderID,
      'senderEmail': senderEmail,
      'recieverID': recieverEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
