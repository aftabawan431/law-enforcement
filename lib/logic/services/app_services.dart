import 'package:flutter/material.dart';

class AppServices {
  static void showSnackeBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
