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
    print("======================================");
    print(stackTrace);
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
      tasks.add(TaskModel.fromMap(task.data())
        ..id = task.id);
    }
  }).onError((error, stackTrace) {
    print(error);
    print(stackTrace);

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

Future<Either<String, TaskModel>> getTask(String taskID) async {

  String errorMsg = "";
  TaskModel? task;
  await db
      .collection("Tasks")
      .doc(taskID)
      .get()
      .then((DocumentSnapshot<Map<String, dynamic>> doc) {
        if(doc.exists){
          task = TaskModel.fromMap(doc.data()!)..id=doc.id;
        }
        else{
          errorMsg = "The task is not exist";
        }
  })
      .onError((error, stackTrace) {errorMsg = error.toString();});

  if(errorMsg.isEmpty){
    return right(task!);
  }
  else{
    return Left(errorMsg);
  }
}



Future<Either<String,String>> updateTask(TaskModel task) async {
  
  String errorMsg = "";
  await db
      .collection("Tasks")
      .doc(task.id)
      .update(task.toMap())
      .onError((error, stackTrace) {
    print(error);
    errorMsg = error.toString();
  });

  return errorMsg.isEmpty? const Right("Task Updated Successfully") : Left(errorMsg);
  
}