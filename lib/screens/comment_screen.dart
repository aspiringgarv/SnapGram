import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/postMethods.dart';
import 'package:instagram_clone/widgets/comment_layout.dart';
import 'package:instagram_clone/widgets/postlayout.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_providers.dart';
import '../resources/storagemethods.dart';
import '../utils/colors.dart';
class Comments_Screen extends StatefulWidget {
  final snap;
  const Comments_Screen({required this.snap,super.key});
  @override
  State<Comments_Screen> createState() => _Comments_ScreenState();
}
class _Comments_ScreenState extends State<Comments_Screen> {
  int  index=  0;
  TextEditingController commentcontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentcontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              child: StreamBuilder(

                stream: FirebaseFirestore.instance.collection('post').doc(widget.snap['postId']).collection('comments').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                     if(snapshot.connectionState==ConnectionState.waiting){
                       return Center(child:CircularProgressIndicator());
                     }
                     else{
                       return ListView.builder(itemBuilder: (context, index) {
                         return Comment_layout(
                           purpose: 'comments',
                           snap: snapshot.data!.docs[index].data(),
                         );
                       },
                         itemCount: snapshot.data!.docs.length,);
                     }
                     },

              ),
            ),
          ),
          SafeArea(
              child:Container(
                height: kToolbarHeight,
                child:Row(
                  children: [
                    SizedBox(width: 3,),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      child: Container(
                        height: kToolbarHeight,
                        child: TextField(
                          controller: commentcontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Add Comment as ${user!.username}',
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                        onTap: () async {
                          String res = await PostMethods().PostComments(commentcontroller.text.toString(),widget.snap['postId'], user!.uid,user!.username, user!.photoUrl);
                          if(res=='success'){
                            show().showSnackBar(context, 'posted');
                          }
                          else{
                            show().showSnackBar(context, 'Some error occured');
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(Icons.send))),
                  ],
                ),
              )
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
        centerTitle: false,
      ),

      );
  }
}
