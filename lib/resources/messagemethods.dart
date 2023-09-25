

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../providers/user_providers.dart';

class MessageMethods {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth    _auth = FirebaseAuth.instance;
  Future<String> sendmessage({required String frienduid,required String message,required String currentusername}) async{
    String res = "";
   try{
     String uid1 = frienduid;
     String? uid2  = _auth.currentUser?.uid.toString();
     String c  = uid1+uid2!;
     List<String> list = c.split('');
     list.sort();
     c = list.join('');
     await _firestore.collection('conversations').doc(c).collection('chats').doc().set({
       'sender'  : currentusername,
       'message' : FieldValue.arrayUnion([message]),
       'datetime': DateTime.now(),
       'senderuid': uid2,
     });
     res =  "success";
   }
   catch(e){
     res  = e.toString();
   }
   return res;
  }
}
