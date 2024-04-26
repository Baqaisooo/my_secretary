import 'package:flutter/material.dart';
import 'package:my_secretary/screens/add_note_page.dart';


class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("NotesPage"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNotePage(pageUse :PageUse.add)));
        },
        child: Icon(Icons.add),
      ),
    );
  }

}
