import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

import '../screens/add_post_screen.dart';

const webscreensize = 600;
List<Widget> homepage = [
  feedscreen(),
  Search_Screen(),
  Addpostscreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid.toString()),
];