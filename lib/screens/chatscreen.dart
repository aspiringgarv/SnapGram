import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:instagram_clone/resources/messagemethods.dart';
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:instagram_clone/utils/colors.dart';

class ChatScreen extends StatefulWidget {
  final Map<String,dynamic> mp;
  final String senderusername;
  const ChatScreen({super.key,required this.mp,required this.senderusername});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
 String _gethashedid(){
   String uid1 = widget.mp['uid'];
   String? uid2  = FirebaseAuth.instance.currentUser?.uid.toString();
   String c  = uid1+uid2!;
   List<String> list = c.split('');
   list.sort();
   c = list.join('');
   return c;
 }
  TextEditingController messagecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: Padding(
         padding: const EdgeInsets.all(6.0),
         child: CircleAvatar(
           backgroundImage: NetworkImage('${widget.mp['photourl']}'),
           radius: 2,
         ),
       ),
        title: Text('${widget.mp['username']}'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('conversations').doc(_gethashedid()).collection('chats').orderBy('datetime',descending: false).snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              return snapshot.connectionState==ConnectionState.waiting?Center(child: CircularProgressIndicator()):Expanded(
                child: Container(
                  child: ListView.builder(itemBuilder: (context, index) {
                    return snapshot.data?.docs[index].data()['senderuid']!=FirebaseAuth.instance.currentUser?.uid.toString()?Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: Colors.grey,
                          borderRadius: BorderRadius.circular(62)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${snapshot.data?.docs[index].data()['sender']}'),
                            Text('${snapshot.data?.docs[index].data()['message'][0]}',style: TextStyle(color: Colors.indigo)),
                          ],
                        )
                      ),
                    ):Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 30,
                          decoration: BoxDecoration(
                              // color: Colors.grey,
                              borderRadius: BorderRadius.circular(62)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${snapshot.data?.docs[index].data()['sender']}'),
                              Text('${snapshot.data?.docs[index].data()['message'][0]}',style: TextStyle(color: Colors.indigo)),
                            ],
                          )
                      ),
                    );
                  },
                    itemCount: snapshot.data?.docs.length,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Container(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: TextField(
                          controller: messagecontroller,
                          decoration: InputDecoration(
                            hintText: "Send Message",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () async {
                    if(messagecontroller.text.toString()!="") {
                      String res = await MessageMethods().sendmessage(
                          currentusername: widget.senderusername,
                          frienduid: widget.mp['uid'],
                          message: messagecontroller.text.toString());
                    }
                       },
                      splashColor: mobileBackgroundColor,
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          )
            ],
          ),
    );
  }
}
