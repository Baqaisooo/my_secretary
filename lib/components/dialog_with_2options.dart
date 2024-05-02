

import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

Future dialogWith2Options(BuildContext context, {String title="Discard Task", String content="Are you sure to delete this Task ?", String btn1Text = "Cancel",  String btn2Text = "Discard", required Function onBtn1Action, required Function onBtn2Action}){
  return showPlatformDialog(
    context: context,
    builder: (context) => BasicDialogAlert(
      title: Text("$title"),
      content: Text("$content"),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("$btn1Text"),
          onPressed: () {
            Navigator.pop(context);
            onBtn1Action();
          },
        ),
        BasicDialogAction(
          title: Text("$btn2Text"),
          onPressed: () {
            onBtn2Action();
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}