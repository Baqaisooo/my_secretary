import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/note_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<bool> addNote(NoteModel note) async {

  await db.collection("Notes").doc().set(note.toMap())
      .onError((error, stackTrace) {
        print(error);
        return false;
  });

  return true;
}