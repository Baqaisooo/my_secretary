
import 'package:flutter/material.dart';
import 'package:my_secretary/screens/notes_page.dart';
import 'package:my_secretary/services/firebase_service.dart';
import 'package:my_secretary/models/note_model.dart';

enum PageUse { add, update }

class AddNotePage extends StatefulWidget {
  AddNotePage({super.key, required PageUse pageUse});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _textEditingController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    height: double.maxFinite,
                    child: TextFormField(
                      controller: _textEditingController,
                      maxLines: 40,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter your note here...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (text) {
                        if (text!.isEmpty) {
                          return "a Note should be written";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.maxFinite,
                  height: 50,
                  child: _isLoading?
                  FilledButton(
                    style: ButtonStyle(),
                    onPressed: () {},
                    child: const LinearProgressIndicator()):
                  FilledButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true;
                        });
                        await addNote(NoteModel(
                                title: _textEditingController.text,
                                addedDate: DateTime.now().microsecondsSinceEpoch,
                                updatedDate: DateTime.now().microsecondsSinceEpoch))
                            .then((value) {
                          if (value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to add note. Please try again later.'),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: const Text(
                      "Add The New Note",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
