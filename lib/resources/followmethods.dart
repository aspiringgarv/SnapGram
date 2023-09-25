import 'package:cloud_firestore/cloud_firestore.dart';

class Follwouser{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String>followuser({
    required String uid,
    required String followid,
}) async {
    String res;
try{
  DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('users').doc(uid).get();
  List<dynamic> following =  (snapshot.data()! as dynamic)['following'];
  if(following.contains(followid)){
    await _firestore.collection('users').doc(followid).update({
      'followers': FieldValue.arrayRemove([uid]),
    });
    await _firestore.collection('users').doc(uid).update({
      'following': FieldValue.arrayRemove([followid]),
    });
    res = 'success';
  }
  else{
    await _firestore.collection('users').doc(followid).update({
      'followers':FieldValue.arrayUnion([uid]),
    });
    await _firestore.collection('users').doc(uid).update({
      'following':FieldValue.arrayUnion([followid]),
    });
    res = 'success';
  }
}
catch(e){
  res = e.toString();
}
return res;
}
}