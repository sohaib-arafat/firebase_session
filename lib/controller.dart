import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_session/models.dart';

class FirestoreController {
  List<User> sessionUsers = [];
  int? usersCount;
  Random random = Random();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<void> addUser(String name, String email) {
    int subjectIndex = random.nextInt(4) + 1;
    return _users.add({
      'name': name,
      'email': email,
      'average': 0.0,
      'subjects': {
        "subject$subjectIndex": random.nextDouble() * (40 - 20) + 20,
        "subject${subjectIndex + 1}": random.nextDouble() * (40 - 20) + 20
      },
      'subjectsArray': ["subject$subjectIndex", "subject${subjectIndex + 1}"]
    });
  }

  Future<void> deleteUser(String id) async {
    return await _users.doc(id).delete();
  }

  Future<List<User>> initUsers() async {
    QuerySnapshot users =
        await _users.orderBy("average", descending: false).get();
    List<User> usersList = [];
    for (var doc in users.docs) {
      User temp = User.fromFirestore(doc);
      usersList.add(temp);
    }
    sessionUsers = usersList;
    usersCount = await getUsersCount();
    return usersList;
  }

  Future<void> setAverage(double average, String id) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection("users").doc(id).get();

    await user.reference.update({"average": average});
  }

  Future<List<User>> getUsersWithAverageGreaterThanOrEqualTo(
      double value) async {
    QuerySnapshot users = await FirebaseFirestore.instance
        .collection("users")
        .where("average", isGreaterThanOrEqualTo: value)
        .get();
    List<User> usersList = [];
    for (var user in users.docs) {
      usersList.add(User.fromFirestore(user));
    }
    return usersList;
  }

  Future<List<User>> getUsersWithAverageLessThanOrEqualTo(double value) async {
    QuerySnapshot users = await FirebaseFirestore.instance
        .collection("users")
        .where("average", isLessThanOrEqualTo: value)
        .get();
    List<User> usersList = [];
    for (var user in users.docs) {
      usersList.add(User.fromFirestore(user));
    }
    return usersList;
  }

  Future<void> computeAverageForUsers() async {
    QuerySnapshot users =
        await FirebaseFirestore.instance.collection("users").get();
    for (var user in users.docs) {
      double avg = 0.0;
      double sum = 0.0;
      Map<String, dynamic> subjects = user['subjects'];
      for (var subject in subjects.values) {
        sum += subject;
      }
      avg = sum / subjects.length;
      user.reference.update({"average": avg});
    }
  }

  Future<void> computeAverageForUser(String id) async {
    DocumentSnapshot user =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    double avg = 0.0;
    double sum = 0.0;
    Map<String, dynamic> subjects = user['subjects'];
    for (var subject in subjects.values) {
      sum += subject;
    }
    avg = sum / subjects.length;
    user.reference.update({"average": avg});
  }

  // Future<void> deleteClass() async {
  //   DocumentSnapshot classToDelete =
  //       await firestoreInstance.collection("classes").doc("class1").get();
  //   QuerySnapshot classStudents =
  //       await firestoreInstance.collection("students").get();
  //   for (var student in classStudents.docs) {
  //     await student.reference.delete();
  //   }
  //   await classToDelete.reference.delete();
  // }

  Future<int?> getUsersCount() async {
    var countQuery = await firestoreInstance.collection("users").count().get();
    return countQuery.count;
  }
}
