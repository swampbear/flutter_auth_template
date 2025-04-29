import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// A simple helper for showing errors (and other messages) uniformly.
class UIHelper {
  /// Shows a Toast using `fluttertoast`.
  static void showToast(String message, {bool isError = true}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: isError ? Colors.redAccent : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 2,
    );
  }
}
