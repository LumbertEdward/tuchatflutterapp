import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FirebaseUpload{
  static String? code;
  static UploadTask? uploadFile(String destination, File file){
    try{
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e){
      return null;
    }

  }

  static Future<String> uploadImage(File file) async {
    UploadTask? task;

    if (file == null) {
      return "";
    }
    else {
      final fileName = basename(file.path);
      final destination = 'files/$fileName';
      task = uploadFile(destination, file);

      if (task == null) {
        return "";
      }
      else{
        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        print(urlDownload);
        return urlDownload;
      }
    }
  }
}