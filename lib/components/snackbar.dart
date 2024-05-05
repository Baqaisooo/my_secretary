

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> customSnackBar (BuildContext context, {required String message}){
  return ScaffoldMessenger.of(context).showSnackBar(
     SnackBar(
      content: Text(message),
    ),
  );
}