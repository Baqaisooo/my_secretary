
class TaskModel {
  late String id;
  final String title;
  final int addedDate;
  final int updatedDate;


  TaskModel({
    required this.title,
    required this.addedDate,
    required this.updatedDate,
  });





  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    title: json["title"],
    addedDate: json["addedDate"],
    updatedDate: json["updatedDate"],
  );

  Map<String, dynamic> toMap(){
    return {
      "title" : title,
      "addedDate" : addedDate,
      "updatedDate" : updatedDate
    };
  }


}
