import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:instagram_clone/models/user.dart' as modeluser;
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/postMethods.dart';
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_anim.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Postcard extends StatefulWidget {
  final Map<String, dynamic> snap;
  Postcard({required this.snap});

  @override
  State<Postcard> createState() => _PostcardState();
}

class _PostcardState extends State<Postcard> {
  bool animate = false;
  bool rotate = false;
  int len = 0;
  void progress() {
    const CircularProgressIndicator();
  }
Future<String> share(String photourl) async{
    String done =  "not";
    try{
      http.Response res = await http.get(Uri.parse(photourl));
      if(res.statusCode==200){
        Uint8List bytes =  res.bodyBytes;
        Directory temp  = await getTemporaryDirectory();
        String p  = '${temp.path}/image.jpg';
        File f = File(p);
        await f.writeAsBytes(bytes);
        await Share.shareFiles([p]);
        done = "success";
      }
      else{

        print("hello");
      }
    }
    catch(e){
      done = AutofillHints.email.toString();
    }
return done;
}
  Future<void> getlen() async {
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance
        .collection('post')
        .doc(widget.snap['postId'])
        .collection('comments')
        .get();
    len = snap.docs.length;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlen();
  }
bool shareindicator =  false;
  @override
  Widget build(BuildContext context) {

    final modeluser.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.all(5),
      child: Column(
        children: [
          Visibility(
            visible: shareindicator,
            child: LinearProgressIndicator(
            backgroundColor: Colors.amberAccent),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.snap['profileimage']),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text(
                  widget.snap['username'],
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
                Visibility(
                  visible: FirebaseAuth.instance.currentUser?.uid ==
                      widget.snap['uid'],
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  TextButton(
                                      onPressed: () async {
                                        String res = await PostMethods()
                                            .deletepost(widget.snap['postId']);
                                      },
                                      child: Text(
                                        'Delete Post',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.more_vert)),
                ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await PostMethods().likePost(widget.snap['postId'],
                  widget.snap['uid'], widget.snap['likes']);
              setState(() {
                animate = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Image.network(widget.snap['posturl']),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: animate == true ? 1 : 0,
                child: LikeAnimation(
                  animate: animate,
                  child: Icon(CupertinoIcons.heart_fill, size: 100),
                  onEnd: () {
                    setState(() {
                      animate = false;
                    });
                  },
                  duration: Duration(milliseconds: 400),
                ),
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              LikeAnimation(
                  duration: Duration(milliseconds: 200),
                  animate: widget.snap['likes'].contains(user!.uid),
                  smallike: true,
                  onEnd: () {
                    setState(() {
                      animate = false;
                    });
                  },
                  child: widget.snap['likes'].contains(user!.uid)
                      ? IconButton(
                          onPressed: () async {
                            await PostMethods().likePost(widget.snap['postId'],
                                widget.snap['uid'], widget.snap['likes']);
                          },
                          icon: Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.red,
                          ))
                      : IconButton(
                          onPressed: () async {
                            await PostMethods().likePost(widget.snap['postId'],
                                widget.snap['uid'], widget.snap['likes']);
                          },
                          icon: Icon(CupertinoIcons.heart))),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Comments_Screen(snap: widget.snap),
                    ));
                  },
                  icon: Icon(Elusive.comment_alt)),
              IconButton(
                  onPressed: ()  async {
                   setState(() {
                     shareindicator=true;
                   });
                   String res = await share(widget.snap['posturl']);
                   setState(() {
                     shareindicator=false;
                   });
                  },
                  icon: Icon(Icons.share)),
            ],
          ),
          Container(
            padding: EdgeInsets.all(5),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.snap['likes'].length}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 3),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' ${widget.snap['caption']}',
                            style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      "${len} Comments",
                      style: TextStyle(fontWeight: FontWeight.w200),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    widget.snap['datepublished'],
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
