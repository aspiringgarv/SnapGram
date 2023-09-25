import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/chatscreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:provider/provider.dart';
import '../models/user.dart' as modeluser;
import '../providers/user_providers.dart';

class ChatFeed extends StatefulWidget {
  const ChatFeed({super.key});

  @override
  State<ChatFeed> createState() => _ChatFeedState();
}

class _ChatFeedState extends State<ChatFeed> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final modeluser.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        backgroundColor: mobileBackgroundColor,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('following',arrayContains: FirebaseAuth.instance.currentUser?.uid.toString()).get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          return snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator()):ListView.builder(
           itemBuilder: (context, index) {
             return snapshot.data?.docs[index].data()['followers'].contains(FirebaseAuth.instance.currentUser?.uid.toString())?ListTile(
               onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) {
                   return ChatScreen(
                     senderusername: user!.username,
                     mp: snapshot.data!.docs[index].data(),
                   );
                 },));
               },
               title: Text('${snapshot.data?.docs[index].data()['username']}'),
               leading: CircleAvatar(
                 backgroundImage: NetworkImage('${snapshot.data?.docs[index].data()['photourl']}'),
               ),
             ):Container();

           },
            itemCount: snapshot.data?.docs.length,
          );


        },
      ),
    );
  }
}
