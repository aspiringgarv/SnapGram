import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class User{
  final String email;
  final String username;
  // final String pass;
  final String uid;
  final String photoUrl;
  final String bio;
  final List followers;
  final List following;
  User( {
    required this.email,
    // required this.pass,
    required this.uid,
    required this.photoUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.username,
});

  Map<String ,dynamic> makemap(){
    return {
    'username': username,
    'email':email,
    'bio':bio,
    'uid': uid.toString(),
    'followers':[],
    'following':[],
    'photourl':photoUrl,

  };
  }
  static User createuserfromSnap(DocumentSnapshot<Map<String,dynamic>> snapshot){
    Map<String, dynamic>? mp = snapshot.data();
    return User(
        // pass: mp?['pass'],
        email: mp?['email'],
        uid: mp?['uid'],
        photoUrl: mp?['photourl'],
        bio: mp?['bio'],
        followers: mp?['followers'],
        following: mp?['following'],
        username: mp?['username']);
  }

}