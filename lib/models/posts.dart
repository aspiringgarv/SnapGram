import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String username;
  final String postId;
  final String datePublished;
  final String PostUrl;
  final String Profileimage;
  final likes;

  Post({
    required this.caption,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.postId,
    required this.likes,
    required this.PostUrl,
    required this.Profileimage});

  Map<String, dynamic> makemap() {
    return {
      'caption': caption,
      'uid': uid,
      'username': username,
      'datepublished': datePublished,
      'postId': postId,
      'likes': likes,
      'posturl': PostUrl,
      'profileimage': Profileimage,
    };
  }

  static Post fromSnap(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic>? mp = snapshot.data();
    return Post(caption: mp?['caption'],
        uid: mp?['uid'],
        username: mp?['username'],
        datePublished: mp?['datepublished'],
        postId: mp?['postId'],
        likes: mp?['likes'],
        PostUrl: mp?['PostUrl'],
        Profileimage: mp?['Profileimage']);
  }
}

