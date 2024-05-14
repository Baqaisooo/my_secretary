import 'package:flutter/material.dart';
import 'package:my_secretary/screens/tasks_page.dart';
import 'package:my_secretary/services/firebase_service.dart';
import 'package:my_secretary/models/task_model.dart';

import '../components/snackbar.dart';

enum PageUse { add, update }

class AddUpdateTaskPage extends StatefulWidget {
  late TaskModel? task;
  final PageUse pageUse;

  AddUpdateTaskPage({super.key, required this.pageUse, this.task});

  @override
  State<AddUpdateTaskPage> createState() => pageUse == PageUse.add
      ? _AddTaskPageState()
      : _UpdateTaskPageState(task: task!);
}

class _AddTaskPageState extends State<AddUpdateTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    child: TextFormField(
                      controller: _textEditingController,
                      maxLines: 40,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        counterStyle: TextStyle(backgroundColor: Colors.white),
                        hintText: 'Enter your task here...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "a Task should be written";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.maxFinite,
                  height: 50,
                  child: _isLoading
                      ? ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () {},
                      child: const LinearProgressIndicator())
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0Xff1fcd99), foregroundColor: Colors.white
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await addTask(TaskModel(
                            title: _textEditingController.text,
                            addedDate:
                            DateTime.now().millisecondsSinceEpoch,
                            updatedDate: DateTime.now()
                                .millisecondsSinceEpoch))
                            .then((value) {
                          if (value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const TasksPage()),
                                    (Route<dynamic> route) => false);
                          } else {
                            customSnackBar(context,
                                message:
                                "Failed to add Task. Please try again later.");
                          }
                        });
                      }
                    },
                    child: Text(
                      "Add The New Task",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class _UpdateTaskPageState extends State<AddUpdateTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _textEditingController;

  bool _isLoading = false;

  late TaskModel task;

  _UpdateTaskPageState({required this.task}) {
    _textEditingController = TextEditingController(text: task.title);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: double.maxFinite,
                    child: TextFormField(
                      controller: _textEditingController,
                      maxLines: 40,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter your task here...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "a Task should be written";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.maxFinite,
                  height: 50,
                  child: _isLoading
                      ? ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () {},
                      child: const LinearProgressIndicator())
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0Xff1fcd99), foregroundColor: Colors.white
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });

                        task.title = _textEditingController.text;
                        task.updatedDate = DateTime.now().millisecondsSinceEpoch;
                        await updateTask(task)
                            .then((value) {
                          value.fold((l) {
                            customSnackBar(context, message: l);
                          }, (r) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const TasksPage()),
                                    (Route<dynamic> route) => false);
                            customSnackBar(context, message: r);
                          });
                        });
                      }
                    },
                    child: const Text(
                      "Update The Task",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
