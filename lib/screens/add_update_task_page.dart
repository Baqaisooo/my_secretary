import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

  bool _reminderSwitchValue = false;
  TimeOfDay _selectedReminder =
  TimeOfDay(hour: TimeOfDay.now().hour - 1, minute: 0);
  late DateTime? _reminderDate = null;
  final int _defaultReminderPeriodInMiuntes = 10;

  Future<void> _selectTime(BuildContext context) async {
    setState(() {});
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

      setState(() {

        _selectedTime = picked??_selectedTime;
        if(_reminderDate == null){
          _setDefaultReminder();
        }
        else {
          DateTime tempTimer = _selectedDate;
          tempTimer.add(Duration(hours: _selectedTime.hour, minutes: _selectedTime.minute));

          DateTime? tempReminder = _reminderDate;
          tempReminder?.add(Duration(hours: _selectedReminder.hour, minutes: _selectedReminder.minute));

          if(tempReminder!.add( Duration(minutes: _defaultReminderPeriodInMiuntes)).isAfter(tempTimer) ){
            _setDefaultReminder();
          }
        }
      });

  }


  // default reminder is 10 minutes before the Task Time
  void _setDefaultReminder(){

    int minutes = _selectedTime.hour*60 + _selectedTime.minute;
    if(minutes > _defaultReminderPeriodInMiuntes){
      minutes -= _defaultReminderPeriodInMiuntes;
      _selectedReminder = TimeOfDay(hour: (minutes~/60), minute: (minutes%60));
      _reminderDate = _selectedDate;
    }
    else {
      minutes += 24*60; // add the previous day minutes
      minutes -= _defaultReminderPeriodInMiuntes;
      _selectedReminder = TimeOfDay(hour: (minutes~/60), minute: (minutes%60));
      _reminderDate = _selectedDate.subtract(Duration(days: 1));
    }
  }

  // TODO
  // if the set time is not available
  // 1. show appropriate message
  // 2. set to default
  Future<void> _selectReminder(BuildContext context) async {
    setState(() {});
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedReminder,
    );
    if (picked != null && picked != _selectedReminder) {
      setState(() {
        _selectedReminder = picked;
        int _reminderInMuintes = _selectedReminder.hour*60 + _selectedReminder.minute;
        int _taskTimeInMuintes = _selectedTime.hour*60  + _selectedTime.minute;
        if(_reminderInMuintes < _taskTimeInMuintes){
          _reminderDate = _selectedDate;
        }
        else{
          _reminderDate = _selectedDate.subtract(Duration(days: 1));
        }
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
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // For title & note
                        Container(
                          padding: const EdgeInsetsDirectional.only(start: 15),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.only(end: 12),
                                child: TextFormField(
                                  controller: _textEditingTitleController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: const InputDecoration(
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
                              const Divider(
                                color: Color(0Xff1fcd99),
                                height: 0,
                              ),
                              Container(
                                padding: const EdgeInsetsDirectional.only(end: 12),
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

                        const SizedBox(
                          height: 10,
                        ),
                        // For Date & Time
                        Container(
                          decoration: const BoxDecoration(
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
                                    child: const Text('Date')),
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
                                  padding: const EdgeInsets.all(5),
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
                                    child: const Icon(Icons.calendar_month_outlined,
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
                                      const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                                  padding: const EdgeInsets.all(16.0),
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
                              const Divider(
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
                                  child: const Text("Time"),
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
                                  padding: const EdgeInsets.all(5),
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
                                    child: const Icon(Icons.watch_later, color: Colors.white),
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

                        const SizedBox(
                          height: 10,
                        ),

                        // For Reminder
                        if (_dateSwitchValue && _timeSwitchValue) Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.white,
                          ),
                          child: SwitchListTile(
                            title: InkWell(
                              onTap: !_reminderSwitchValue
                                  ? null
                                  : () {
                                _selectReminder(context);

                              },
                              child: const Text("Reminder Time"),
                            ),
                            subtitle: !_reminderSwitchValue
                                ? null
                                : InkWell(
                              onTap: !_reminderSwitchValue
                                  ? null
                                  : () {
                                _selectReminder(context);

                              },
                              child:
                              _reminderSwitchValue?
                              _reminderDate == null?
                              SizedBox() :Text(_reminderDate.toString().split(" ")[0]+ " " + _selectedReminder.format(context))
                                  : null,
                            ),
                            value: _reminderSwitchValue,
                            secondary: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green,
                              ),
                              child: InkWell(
                                onTap: !_reminderSwitchValue
                                    ? null
                                    : () {
                                  _selectReminder(context);
                                  }
                                ,
                                child: const Icon(Icons.alarm_add, color: Colors.white),
                              ),
                            ),
                            onChanged: (isToOpen) {
                              setState(() {
                                _reminderSwitchValue = isToOpen;
                                if(isToOpen)
                                _selectReminder(context);
                              });
                            },
                          ),
                        ),


                      ],
                    ),
                  ),
                ),

                // For The submit btn
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
                      backgroundColor: const Color(0Xff1fcd99),
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
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
                              backgroundColor: const Color(0Xff1fcd99),
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
