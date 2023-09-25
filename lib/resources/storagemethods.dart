import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class StorageMethods {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> uploadtoStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref;
    if (isPost == true) {
      ref = storage
          .ref()
          .child(childName)
          .child(auth.currentUser!.uid)
          .child(uuid.v1());
    } else {
      ref = storage.ref().child(childName).child(auth.currentUser!.uid);
    }
    UploadTask up = ref.putData(file);
    TaskSnapshot snap = await up;
    String downloadurl = await snap.ref.getDownloadURL();
    return downloadurl;
  }
}

class show {
  showSnackBar(BuildContext context, String content) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(content),
      backgroundColor: Colors.blue,
      shape: Border.all(color: Colors.black),
    ));
  }
}
