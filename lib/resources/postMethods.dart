// import 'dart:js';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';
import '../models/posts.dart';

class PostMethods {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> post(
      {required String caption,
      required Uint8List file,
      required String uid,
      required String username,
      required String Profileimage}) async {
    String res = "Some Error";
    try {
      if (file.isNotEmpty|| caption.isNotEmpty) {
        String photoUrl =
            await StorageMethods().uploadtoStorage('postspics', file, true);
        String postId = uuid.v1();
        Post p = Post(
            caption: caption,
            uid: uid,
            username: username,
            datePublished:
                formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]).toString(),
            postId: postId,
            likes: [],
            PostUrl: photoUrl,
            Profileimage: Profileimage);
        await _firestore.collection('post').doc(postId).set(p.makemap());
        res = 'success';
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> PostComments(String comment, String postid, String uid,
      String name, String profileimg) async {
    String res = "Some Error";
    try {
      if (comment.isNotEmpty) {
        String commentid = Uuid().v1();
        await _firestore
            .collection('post')
            .doc(postid)
            .collection('comments')
            .doc(commentid)
            .set({
          'profilepic': profileimg,
          'postid': postid,
          'uid': uid,
          'Commentid': commentid,
          'comment': comment,
          'username': name,
          'date published': formatDate(DateTime.now(), [yyyy,'-',mm,'-',dd]),
        });
        res = "success";
        return res;
      } else {
        return res;
      }
    }
    catch (e) {
      return e.toString();
    }
  }
  Future<String>deletepost(String postid)
  async {
    String res = "Error";
    try{
      if(postid.isNotEmpty){
      await _firestore.collection('post').doc(postid).delete();
      res="Success";
      return res;
      }
      return "Error";
    }
    catch(e){
      return e.toString();
    }
  }
}
