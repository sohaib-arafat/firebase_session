import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  Map<String, dynamic> subjects;
  double average = 0.0;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.subjects,
      required this.average});

  factory User.fromFirestore(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      subjects: doc['subjects'],
      average: doc['average'],
    );
  }
}
