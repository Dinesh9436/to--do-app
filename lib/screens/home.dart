import 'package:date_field/date_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final databaseRef = FirebaseDatabase.instance.reference();
  SharedPreferences? prefs;
  TextEditingController createController = new TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _createTaskDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add task'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: 'Task Name'),
                    controller: createController,
                  ),
                ),
                DateTimeField(
                  lastDate: DateTime.now(),
                  decoration: InputDecoration(hintText: 'select date & time '),
                  selectedDate: selectedDate,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('create'),
              onPressed: () {
                var formatter = new DateFormat('dd-MM-yyyy kk:mm:a');
                // var parsedDate = DateTime.parse(selectedDate);
                String formattedDate = formatter.format(selectedDate!);
                setState(() {
                  databaseRef.child('tasks').push().set({
                    "task": createController.text,
                    "date": formattedDate,
                    "index": 0
                  }).then((value) => Navigator.of(context).pop());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dy > 0) {
          print("add");
          _createTaskDialog();
        }
        // Swiping in right direction.
        if (details.delta.dx > 0) {}

        // Swiping in left direction.
        if (details.delta.dx < 0) {}
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("to-do app"),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              StreamBuilder(
                stream: databaseRef.child("tasks").onValue,
                builder: (context, AsyncSnapshot<dynamic> snap) {
                  if (snap.hasData && snap.data.snapshot.value != null) {
                    Map<dynamic, dynamic> data = snap.data.snapshot.value;

                    if (data == null) {
                      return Center(
                        child: Text("No Tasks."),
                      );
                    } else {
                      Map<dynamic, dynamic> data = snap.data.snapshot.value;
                      print(data);
                      List<dynamic> keyss = data.keys.toList();
                      List<dynamic> task = [];
                      List<dynamic> index = [];
                      List<dynamic> date = [];
                      List<dynamic> complete = [];

                      data.forEach((key, value) {
                        task.add(value["task"]);
                        index.add(value["index"]);
                        date.add(value["date"]);
                        complete.add(value["completed"]);
                      });
                      return ReorderableListView(
                        shrinkWrap: true,
                        children: task.map((item) {
                          int num = task.indexOf(item);
                          bool completed = false;

                          return GestureDetector(
                            key: ValueKey(item),
                            onPanUpdate: (details) {
                              // Swiping in right direction.
                              if (details.delta.dx > 0) {
                                setState(() {
                                  completed = false;
                                  databaseRef
                                      .child('tasks')
                                      .child(keyss[num])
                                      .update({'completed': true});
                                });
                              }

                              // Swiping in left direction.
                              if (details.delta.dx < 0) {
                                databaseRef
                                    .child('tasks')
                                    .child(keyss[num])
                                    .remove();
                              }
                            },
                            child: ListTile(
                              key: Key("${item}"),
                              tileColor:
                                  complete[num] == true ? Colors.green : null,
                              title: Text(
                                "${item}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: complete[num] == true
                                        ? TextDecoration.lineThrough
                                        : null),
                              ),
                            ),
                          );
                        }).toList(),
                        onReorder: (int start, int current) {
                          // dragging from top to bottom
                          if (start < current) {
                            int end = current - 1;
                            String startItem = task[start];
                            int i = 0;
                            int local = start;

                            do {
                              task[local] = task[++local];
                              i++;
                            } while (i < end - start);
                            task[end] = startItem;
                            databaseRef
                                .child('tasks')
                                .child(keyss[i])
                                .update({'index': current});
                          }
                          // dragging from bottom to top
                          else if (start > current) {
                            String startItem = task[start];
                            for (int i = start; i > current; i--) {
                              task[i] = task[i - 1];
                              databaseRef
                                  .child('tasks')
                                  .child(keyss[i])
                                  .update({'index': current});
                            }
                            task[current] = startItem;
                          }
                          setState(() {});
                        },
                      );
                      // ListView.builder(
                      //   physics: ClampingScrollPhysics(),
                      //   shrinkWrap: true,
                      //   itemCount: keyss.length,
                      //   itemBuilder: (context, index) {
                      //     return ListTile(
                      //       title: Text(task[index]),
                      //       subtitle: Text(date[index]),
                      //     );
                      //   },
                      // );
                    }
                  } else if (snap.hasError) {
                    return Center(child: Text("Error occured..!"));
                  } else if (snap.hasData == false) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                        child: Text(
                      "No data",
                    ));
                  }
                },
              ),
            ]),
          )),
    );
  }
}
