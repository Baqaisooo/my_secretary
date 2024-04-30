import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:my_secretary/models/note_model.dart';
import 'package:my_secretary/screens/add_note_page.dart';
import 'package:my_secretary/services/firebase_service.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool dataLoaded = false;
  List<NoteModel> notes = [];

  Future<void> _fillNoteList() async {
    notes = await getNotes();
    dataLoaded = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    _fillNoteList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("NOTES"),),
      body: RefreshIndicator(
        onRefresh: _fillNoteList,
        child: Center(
          child: !dataLoaded? const CircularProgressIndicator() : ListView.separated(
              itemBuilder: (context, position) {
                NoteModel note = notes[position];
                DateTime addedAt = DateTime.fromMillisecondsSinceEpoch(note.addedDate);
                String addedAtFormat = DateFormat("yyyy-MM-dd hh:mm:ss").format(addedAt);
                DateTime updatedAt = DateTime.fromMillisecondsSinceEpoch(note.updatedDate);
                String upadtedAtFormat = DateFormat("yyyy-MM-dd hh:mm:ss").format(updatedAt);

                return Card(
                  color: Colors.amber.shade300,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.symmetric(horizontal: 15, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style: TextStyle(fontSize: 17),
                          notes[position].title,
                            maxLines: 2, overflow: TextOverflow.ellipsis
                        ),
                    Divider(color: Colors.deepPurpleAccent,),
                        Row(
                          children: [
                            Expanded(child: Text("Added At: $addedAtFormat", style: TextStyle(fontSize: 10),)),
                            Text("Added At: $upadtedAtFormat", style: TextStyle(fontSize: 10),),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, position) {
                return Divider();
              },
              itemCount: notes.length),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNotePage(pageUse: PageUse.add)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
