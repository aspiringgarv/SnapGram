import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/posts.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //signup the user
  Future<model.User> getUserdetails() async {
    User currentuser = _auth.currentUser!;
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _firestore.collection('users').doc(currentuser.uid).get();
    return model.User.createuserfromSnap(snap);
  }

  Future<String> signup({
    required String email,
    required String username,
    required String bio,
    required Uint8List file, //for image
    required pass,
  }) async {
    String res = "some error";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        String photourl =
            await StorageMethods().uploadtoStorage('profilepics', file, false);
        model.User user = model.User(
            email: email,
            uid: cred.user!.uid.toString(),
            photoUrl: photourl,
            bio: bio,
            followers: [],
            following: [],
            username: username); //user data model class
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.makemap());
        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }


  Future<String> login({
    required String email,
    required String pass,
  }) async {
    String res = "some error";
    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        res = 'success';
        return res;
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }
}
