import 'dart:io';

import 'package:file_picker/file_picker.dart';
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

Future<File?> pickAudio() async {
  try {
    final filePicker = await FilePicker.pickFiles(
      type: FileType.custom,

      allowedExtensions: ['mp3', 'wav', 'm4a'],
      allowMultiple: false,
    );
    if (filePicker != null) {
      return File(filePicker.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickImage() async {
  try {
    final filePicker = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      allowMultiple: false,
    );
    if (filePicker != null) {
      return File(filePicker.files.first.xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

String rgbtoHex(Color color) {
  return '${color.red.toRadixString(16).padLeft(2, '0')}${color.green.toRadixString(16).padLeft(2, '0')}${color.blue.toRadixString(16).padLeft(2, '0')}';
}

Color hextoColor(String hex) {
  return Color(int.parse(hex, radix: 16) + 0xFF000000);
}
