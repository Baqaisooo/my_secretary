
class NoteModel {
  late String id;
  final String title;
  final int addedDate;
  final int updatedDate;


  NoteModel({
    required this.title,
    required this.addedDate,
    required this.updatedDate,
  });





  factory NoteModel.fromMap(Map<String, dynamic> json) => NoteModel(
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
