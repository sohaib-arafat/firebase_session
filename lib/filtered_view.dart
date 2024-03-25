import 'package:flutter/material.dart';
import 'controller.dart';
import 'models.dart';

class FilteredView extends StatefulWidget {
  const FilteredView({super.key});

  @override
  FilteredViewState createState() => FilteredViewState();
}

class FilteredViewState extends State<FilteredView> {
  final FirestoreController _controller = FirestoreController();
  late Future<List<User>> filterSnapshot;

  @override
  void initState() {
    super.initState();
    filterSnapshot = _controller.initUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore CRUD'),
      ),
      body: FutureBuilder<List<User>>(
        future: filterSnapshot,
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
                        width: 10,
                      ),
                      Text(user.average.toString())
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
              setState(() {
                filterSnapshot = _controller.initUsers();
              });
            },
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            child: const Icon(Icons.arrow_upward_rounded),
            onPressed: () {
              setState(() {
                filterSnapshot =
                    _controller.getUsersWithAverageGreaterThanOrEqualTo(30);
              });
              // Add user
            },
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            child: const Icon(Icons.arrow_downward_rounded),
            onPressed: () async {
              setState(() {
                filterSnapshot =
                    _controller.getUsersWithAverageLessThanOrEqualTo(29);
              });
            },
          )
        ],
      ),
    );
  }
}
