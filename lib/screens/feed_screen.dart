import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/chatfeed.dart';
import 'package:instagram_clone/screens/chatscreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:instagram_clone/widgets/postlayout.dart';
class feedscreen extends StatelessWidget {
  const feedscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: SvgPicture.asset('assets/logo.svg',color: Colors.white,height: 100,),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChatFeed();
            },));
          }, icon: Icon(FlutterIcons.message_circle_fea)),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('post').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
         if(snapshot.hasData){
           return ListView.builder(itemBuilder: (context, index) {
             return Postcard(
              snap: snapshot.data
                  !.docs[index].data(),
             );
           },

           itemCount: snapshot.data!.docs.length,);
         }
         else{
           return Center(child: CircularProgressIndicator());
         }
        },
      ),
    );
  }
}
