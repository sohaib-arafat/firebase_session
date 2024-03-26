import 'package:flutter/material.dart';
import 'controller.dart';
import 'models.dart';

class FirestoreView extends StatefulWidget {
  const FirestoreView({super.key});

  @override
  FirestoreViewState createState() => FirestoreViewState();
}

class FirestoreViewState extends State<FirestoreView> {
  final FirestoreController _controller = FirestoreController();
  int _addedCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore CRUD'),
      ),
      body: FutureBuilder<List<User>>(
        future: _controller.initUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                User? user = snapshot.data?[index];
                return ListTile(
                  title: Text(user!.name),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(user.email),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(user.average.toStringAsFixed(2)),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("Subjects: ${user.subjectsArray[0]}")
                    ],
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          await _controller.computeAverageForUser(user.id);
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _controller.deleteUser(user.id);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _controller.addUser("user#$_addedCount", "user@mail.com");
              setState(() {
                _addedCount += 1;
              });
              // Add user
            },
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: const Icon(Icons.edit),
            onPressed: () async {
              await _controller.computeAverageForUsers();
              setState(() {});
              setState(() {});
            },
          ),
          const SizedBox(
            width: 10,
          ),
          Text("UsersCount:${_controller.usersCount.toString()}"),
        ],
      ),
    );
  }
}
