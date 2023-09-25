
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/followmethods.dart';
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool followed = false;
  var userData;
  var postlen;
  // User user = Provider.of<UserProvider>
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snapshot.data();
      var postsnap = await FirebaseFirestore.instance
          .collection('post')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postlen = postsnap.docs.length;
      followed = userData!['followers']
          .contains(FirebaseAuth.instance.currentUser?.uid.toString());
      setState(() {});
    } catch (e) {
      show().showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return userData == null || postlen == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(userData['photourl']),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  statcolmn(postlen, 'Posts'),
                                  // SizedBox(width: 30,),
                                  statcolmn(userData['following'].length,
                                      'Following'),
                                  // SizedBox(width: 30,),
                                  statcolmn(userData['followers'].length,
                                      'Followers'),
                                ],
                              ),
                              FirebaseAuth.instance.currentUser?.uid
                                          .toString() ==
                                      widget.uid
                                  ? profilebutton(
                                      text: "Sign Out",
                                      fxn: () {
                                        FirebaseAuth.instance.signOut();
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                          return LoginScreen();
                                        },));
                                      },
                                      color: Colors.blue)
                                  : followed
                                      ? profilebutton(
                                          text: "Unfollow",
                                          fxn: () async {
                                            String res  = await Follwouser().followuser(uid: FirebaseAuth.instance.currentUser!.uid.toString(), followid: userData['uid']);
                                            if(res=='success'){
                                              setState(() {
                                                getdata();
                                              });
                                            }
                                          },
                                          color: Colors.blue)
                                      : profilebutton(
                                          text: "Follow",
                                          fxn: () async {
                                            String res  = await Follwouser().followuser(uid: FirebaseAuth.instance.currentUser!.uid.toString(), followid: userData['uid']);
                                            if(res=='success'){
                                              setState(() {
                                                getdata();
                                              });
                                            }
                                             },
                                          color: Colors.blue),
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 2, left: 16),
                      child: Text(
                        userData['username'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 1, left: 16),
                      child: Text(
                        userData['bio'],
                        style: TextStyle(fontWeight: FontWeight.w400),
                      ),
                    ),
                    Divider(color: mobileBackgroundColor),
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('post')
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return AlignedGridView.count(
                            crossAxisCount: 3,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 4,
                            itemBuilder: (context, index) {
                              return Image.network('${snapshot.data?.docs[index].data()['posturl']}');
                            },
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                          );
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          );
  }


  Column statcolmn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        SizedBox(
          height: 6,
        ),
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 10)),
      ],
    );
  }
}

class profilebutton extends StatelessWidget {
  const profilebutton({
    super.key,
    required this.color,
    required this.text,
    required this.fxn,
  });
  final Color color;
  final String text;
  final void Function() fxn;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(color),
          ),
          onPressed: fxn,
          child: Text(
            text,
            style: TextStyle(fontSize: 22, color: primaryColor),
          ),
        ));
  }
}
