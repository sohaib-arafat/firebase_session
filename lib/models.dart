import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String name;
  String email;
  Map<String, double> subjects;
  double average = 0.0;
  List<String> subjectsArray;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.subjects,
      required this.average,
      required this.subjectsArray});

  factory User.fromFirestore(DocumentSnapshot doc) {
    return User(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      subjects: Map<String,double>.from(doc['subjects']),
      average: doc['average'],
      subjectsArray: List<String>.from(doc['subjectsArray'] ),
    );
  }
}
