import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<bool> addNote(NoteModel note) async {
  bool flag = true;
  await db
      .collection("Notes")
      .doc()
      .set(note.toMap())
      .onError((error, stackTrace) {
    print(error);
    flag = false;
  });

  return flag;
}

Future<List<NoteModel>> getNotes() async {
  List<NoteModel> notes = [];

  QuerySnapshot querySnapshot =
      await db.collection("Notes").orderBy("title", descending: true).get();
  querySnapshot.docs.forEach((note) {

    notes.add(NoteModel(
        title: note["title"],
        addedDate: note["addedDate"],
        updatedDate: note["updatedDate"])..id = note.id);
  });

  return notes;
}
