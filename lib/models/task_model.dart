enum TaskStatus{New, Done, Postpone}

class TaskModel {
  late String id;
  String title;
  String? notes;
  int? taskDateTime; // if only a date is set, the time will be 00:00:00
  int? earlyReminder;
  TaskStatus taskStatus;
  int? taskDateAlarmID; // on the device
  int? earlyReminderAlarmID; // on the device
  final int addedDate;
  int updatedDate;


  TaskModel({
    required this.title,
    required this.addedDate,
    required this.updatedDate,
    this.notes,
    this.taskDateTime,
    this.earlyReminder,
    this.taskDateAlarmID,
    this.earlyReminderAlarmID,
    this.taskStatus=TaskStatus.New
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    title: json["title"],
    notes: json["notes"],
    taskDateTime: json["taskDateTime"],
    earlyReminder: json["earlyReminder"],
    taskStatus: json["taskStatus"],
    taskDateAlarmID: json["taskDateAlarmID"],
    earlyReminderAlarmID: json["earlyReminderAlarmID"],
    addedDate: json["addedDate"],
    updatedDate: json["updatedDate"],
  );

  Map<String, dynamic> toMap(){
    return {
      "title" : title,
      "notes" : notes,
      "taskDateTime" : taskDateTime,
      "earlyReminder" : earlyReminder,
      "taskStatus" : taskStatus,
      "taskDateAlarmID" : taskDateAlarmID,
      "earlyReminderAlarmID" : earlyReminderAlarmID,
      "addedDate" : addedDate,
      "updatedDate" : updatedDate
    };
  }


}
