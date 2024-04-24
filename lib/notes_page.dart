import 'package:flutter/material.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("NotesPage"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print("pressed");
      },
        child: Icon(Icons.add),
      ),
    );
  }
}
