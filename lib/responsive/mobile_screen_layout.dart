import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/globalconstants.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/models/user.dart' as model;
class MobilescreenLayout extends StatefulWidget {
  const MobilescreenLayout({super.key});

  @override
  State<MobilescreenLayout> createState() => _MobilescreenLayoutState();
}

class _MobilescreenLayoutState extends State<MobilescreenLayout> {
  int _page = 0;
  String username = "hi";
  late PageController p;
  void tapper(int page){
    p.jumpToPage(page);
  }
  void onPageChanged(int page){
    setState((){
      _page = page;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    p=PageController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    p.dispose();
  }
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body:PageView(
        children: homepage,
        controller: p,
        onPageChanged: onPageChanged,
         // physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar:
      CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search),label:'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle),label:'Post'),
          BottomNavigationBarItem(icon: Icon(Icons.person,),label:'Profile'),
      ],
        onTap: tapper,
        inactiveColor: secondaryColor,
        activeColor: primaryColor,
        currentIndex: _page,
      ),


    );
  }
}
