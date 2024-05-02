import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:my_secretary/components/dialog_with_2options.dart';
import 'package:my_secretary/models/task_model.dart';
import 'package:my_secretary/screens/add_task_page.dart';
import 'package:my_secretary/services/firebase_service.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  bool dataLoaded = false;
  List<TaskModel> tasks = [];

  Future<void> _fillTasksList() async {
    tasks = await getTasks();
    dataLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _fillTasksList();
    super.initState();
  }

  _deleteTask(String taskID, int index) async {
    tasks.removeAt(index);
    setState(() {});

    String msg = await deleteTask(taskID);
    _fillTasksList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TASKS"),
      ),
      body: RefreshIndicator(
        onRefresh: _fillTasksList,
        child: Center(
          child: !dataLoaded
              ? const CircularProgressIndicator():
              tasks.isEmpty? const Text("+ Add a new Task")
              : ListView.builder(
                  itemBuilder: (context, position) {
                    TaskModel task = tasks[position];
                    DateTime addedAt =
                        DateTime.fromMillisecondsSinceEpoch(task.addedDate);
                    String addedAtFormat =
                        DateFormat("yyyy-MM-dd hh:mm").format(addedAt);
                    DateTime updatedAt =
                        DateTime.fromMillisecondsSinceEpoch(task.updatedDate);
                    String upadtedAtFormat =
                        DateFormat("yyyy-MM-dd hh:mm").format(updatedAt);

                    return Slidable(
                        // Specify a key if the Slidable is dismissible.
                        key: UniqueKey(),

                        // The start action pane is the one at the left or the top side.
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),

                          // A pane can dismiss the Slidable.
                          dismissible: DismissiblePane(onDismissed: () {
                            dialogWith2Options(context,
                                onBtn1Action: () => setState(() {}),
                                onBtn2Action: () =>
                                    _deleteTask(task.id, position));
                          }),

                          // All actions are defined in the children parameter.
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (context) {
                                dialogWith2Options(context,
                                    onBtn1Action: () => setState(() {}),
                                    onBtn2Action: () =>
                                        _deleteTask(task.id, position));
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                print("share");
                              },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.share,
                              label: 'Share',
                            ),
                          ],
                        ),

                        // The end action pane is the one at the right or the bottom side.
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                print("Archive");
                              },
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.archive,
                              label: 'Archive',
                            ),
                            SlidableAction(
                              onPressed: (context) {
                                print("Save");
                              },
                              backgroundColor: const Color(0xFF0392CF),
                              foregroundColor: Colors.white,
                              icon: Icons.save,
                              label: 'Save',
                            ),
                          ],
                        ),

                        // The child of the Slidable is what the user sees when the
                        // component is not dragged.
                        child: Card(
                          color: Colors.amber.shade300,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    style: const TextStyle(fontSize: 17),
                                    tasks[position].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                const Divider(
                                  color: Colors.deepPurpleAccent,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "Added At: $addedAtFormat",
                                      style: const TextStyle(fontSize: 10),
                                    )),
                                    Text(
                                      "Updated At: $upadtedAtFormat",
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                  itemCount: tasks.length),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskPage(pageUse: PageUse.add)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
