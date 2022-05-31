import 'package:flutter/material.dart';

bool _isSnackBarActive = false;

void showCustomSnackBar (String message, BuildContext context) {
  if (!_isSnackBarActive) {
    _isSnackBarActive = true;
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(label: "Got it", onPressed: () {},),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((SnackBarClosedReason reason) {_isSnackBarActive = false;});
  }
}