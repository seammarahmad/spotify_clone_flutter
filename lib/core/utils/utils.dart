
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  final messenger = ScaffoldMessenger.of(context);

  messenger.clearSnackBars();

  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(content),
      duration: Duration(seconds: 2),
    ),
  );
}