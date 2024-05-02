
import 'package:flutter/material.dart';
import 'package:my_secretary/screens/tasks_page.dart';
import 'package:my_secretary/services/firebase_service.dart';
import 'package:my_secretary/models/task_model.dart';

enum PageUse { add, update }

class AddTaskPage extends StatefulWidget {
  AddTaskPage({super.key, required PageUse pageUse});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
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
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    height: double.maxFinite,
                    child: TextFormField(
                      controller: _textEditingController,
                      maxLines: 40,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
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
                  child: _isLoading?
                  FilledButton(
                    style: const ButtonStyle(),
                    onPressed: () {},
                    child: const LinearProgressIndicator()):
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await addTask(TaskModel(
                                title: _textEditingController.text,
                                addedDate: DateTime.now().millisecondsSinceEpoch,
                                updatedDate: DateTime.now().millisecondsSinceEpoch))
                            .then((value) {
                          if (value) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TasksPage()),
                                    (Route<dynamic> route) => false
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to add Task. Please try again later.'),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: const Text(
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
