import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../models/task_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<bool> addTask(TaskModel task) async {
  bool flag = true;
  await db
      .collection("Tasks")
      .doc()
      .set(task.toMap())
      .onError((error, stackTrace) {
    print(error);
    flag = false;
  });

  return flag;
}

Future<List<TaskModel>> getTasks() async {
  List<TaskModel> tasks = [];

  await db
      .collection("Tasks")
      .orderBy("addedDate", descending: true)
      .get()
      .then((querySnapshot) {
    for (var task in querySnapshot.docs) {
      tasks.add(TaskModel(
          title: task["title"],
          addedDate: task["addedDate"],
          updatedDate: task["updatedDate"])
        ..id = task.id);
    }
  }).onError((error, stackTrace) {
    print(error);
  });

  return tasks;
}

Future<String> deleteTask(String taskID) async {
  String message = "";

  await db.collection("Tasks").doc(taskID).delete().then((value) {
    message = "Task Deleted successfully";
  }).onError((error, stackTrace) {
    print(error);
    message = "Something went wrong, Try again";
  });

  return message;
}
