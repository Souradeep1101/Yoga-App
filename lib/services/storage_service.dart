import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Storage {
  final storage = FirebaseStorage.instance;

  Future<void> uploadFile(
      String filePath, String fileName, String directory) async {
    File file = File(filePath);
    try {
      await storage.ref('$directory/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      Text(e as String);
    }
  }
}
