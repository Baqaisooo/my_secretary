enum TaskStatus{New, Done, Postpone}

class TaskModel {
  String? id;
  String title;
  String? notes;
  int? taskDateTime; // if only a date is set, the time will be 00:00:00
  int? earlyReminder;
  bool isTimeChosen;
  TaskStatus? taskStatus;
  int? taskDateNotificationID; // on the device
  int? earlyReminderNotificationID; // on the device
  final int addedDate;
  int updatedDate;


  TaskModel({
    this.id,
    required this.title,
    required this.addedDate,
    required this.updatedDate,
    this.isTimeChosen = false,
    this.notes,
    this.taskDateTime,
    this.earlyReminder,
    this.taskDateNotificationID,
    this.earlyReminderNotificationID,
    this.taskStatus=TaskStatus.New
  });

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    title: json["title"],
    isTimeChosen: json["isTimeChosen"]??false,
    notes: json["notes"],
    taskDateTime: json["taskDateTime"],
    earlyReminder: json["earlyReminder"],
    taskStatus: json['taskStatus'] == null? null: TaskStatus.values.firstWhere((e) => e.toString() == 'TaskStatus.${json['taskStatus']}'),
    taskDateNotificationID: json["taskDateNotificationID"],
    earlyReminderNotificationID: json["earlyReminderNotificationID"],
    addedDate: json["addedDate"],
    updatedDate: json["updatedDate"],
  );

  Map<String, dynamic> toMap(){
    return {
      "title" : title,
      "notes" : notes,
      "isTimeChosen" : isTimeChosen,
      "taskDateTime" : taskDateTime,
      "earlyReminder" : earlyReminder,
      "taskStatus" : taskStatus.toString().split(".").last,
      "taskDateNotificationID" : taskDateNotificationID,
      "earlyReminderNotificationID" : earlyReminderNotificationID,
      "addedDate" : addedDate,
      "updatedDate" : updatedDate
    };
  }


}
