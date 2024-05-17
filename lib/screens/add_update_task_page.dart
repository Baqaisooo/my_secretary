import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
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

  final TextEditingController _textEditingTitleController =
      TextEditingController();
  final TextEditingController _textEditingNotesController =
      TextEditingController();

  bool _isLoading = false;

  bool _dateSwitchValue = false;
  bool _dateCalenderOpen = false;
  DateTime _selectedDate = DateTime.now();

  bool _timeSwitchValue = false;
  TimeOfDay _selectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: 0);

  Future<void> _selectTime(BuildContext context) async {
    setState(() {});
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

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
                // For title & note
                Container(
                  padding: EdgeInsetsDirectional.only(start: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsetsDirectional.only(end: 12),
                        child: TextFormField(
                          controller: _textEditingTitleController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Title',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                          validator: (text) {
                            if (text!.isEmpty) {
                              return "the Task title should be written";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      Divider(
                        color: Color(0Xff1fcd99),
                        height: 0,
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.only(end: 12),
                        child: TextFormField(
                          controller: _textEditingNotesController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Notes',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 20),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                // For Date & Time
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: InkWell(
                            onTap: !_dateSwitchValue
                                ? null
                                : () {
                                    setState(() {
                                      _dateCalenderOpen = true;
                                    });
                                  },
                            child: Text('Date')),
                        subtitle: _dateSwitchValue
                            ? InkWell(
                                onTap: !_dateSwitchValue
                                    ? null
                                    : () {
                                        setState(() {
                                          _dateCalenderOpen = true;
                                        });
                                      },
                                child: Text(_dateSwitchValue
                                    ? _selectedDate.toString().split(" ")[0]
                                    : ""),
                              )
                            : null,
                        value: _dateSwitchValue,
                        secondary: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent,
                          ),
                          child: InkWell(
                            onTap: !_dateSwitchValue
                                ? null
                                : () {
                                    setState(() {
                                      _dateCalenderOpen = true;
                                    });
                                  },
                            child: Icon(Icons.calendar_month_outlined,
                                color: Colors.white),
                          ),
                        ),
                        onChanged: (isToOpen) {
                          setState(() {
                            _dateSwitchValue = isToOpen;
                            _dateCalenderOpen = true;
                            _timeSwitchValue =
                                isToOpen ? _timeSwitchValue : false;
                          });
                        },
                      ),
                      if (_dateSwitchValue && _dateCalenderOpen)
                        Container(
                          margin:
                              EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CalendarDatePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 5),
                            onDateChanged: (date) {
                              setState(() {
                                _selectedDate =
                                    DateTime(date.year, date.month, date.day);
                                // _dateCalenderOpen = !_dateCalenderOpen;
                              });
                            },
                          ),
                        ),
                      Divider(
                        color: Color(0Xff1fcd99),
                        height: 0,
                        indent: 60,
                      ),
                      SwitchListTile(
                        title: InkWell(
                          onTap: !_timeSwitchValue
                              ? null
                              : () {
                                  if (_timeSwitchValue) {
                                    _dateCalenderOpen = false;
                                    _selectTime(context);
                                  }
                                },
                          child: Text("Time"),
                        ),
                        subtitle: !_timeSwitchValue
                            ? null
                            : InkWell(
                                onTap: !_timeSwitchValue
                                    ? null
                                    : () {
                                        if (_timeSwitchValue) {
                                          _dateCalenderOpen = false;
                                          _selectTime(context);
                                        }
                                      },
                                child: _timeSwitchValue
                                    ? Text(_selectedTime.format(context))
                                    : null,
                              ),
                        value: _timeSwitchValue,
                        secondary: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueAccent,
                          ),
                          child: InkWell(
                            onTap: !_timeSwitchValue
                                ? null
                                : () {
                              if (_timeSwitchValue) {
                                _dateCalenderOpen = false;
                                _selectTime(context);
                              }
                            },
                            child: Icon(Icons.watch_later, color: Colors.white),
                          ),
                        ),
                        onChanged: (isToOpen) {
                          setState(() {
                            _timeSwitchValue = isToOpen;
                            if (isToOpen) {
                              _dateSwitchValue = true;
                              _dateCalenderOpen = false;
                              _selectTime(context);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: const SizedBox(),
                ),

                // For The sumbit btn
                Container(
                  width: double.maxFinite,
                  height: 50,
                  child: _isLoading
                      ? ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () {},
                          child: const LinearProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0Xff1fcd99),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              await addTask(TaskModel(
                                      title: _textEditingTitleController.text,
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
                              backgroundColor: Color(0Xff1fcd99),
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              task.title = _textEditingController.text;
                              task.updatedDate =
                                  DateTime.now().millisecondsSinceEpoch;
                              await updateTask(task).then((value) {
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
