import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Comment_layout extends StatefulWidget {
  final Map<String,dynamic> snap;
  final String purpose;
  const Comment_layout({required this.snap,super.key,required this.purpose});

  @override
  State<Comment_layout> createState() => _Comment_layoutState();
}

class _Comment_layoutState extends State<Comment_layout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  widget.snap['profilepic']),
              radius: 18,
            ),
            Padding(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                              text: widget.snap['username']),
                          TextSpan(text: ' ${widget.snap['comment']}'),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 4), child: Text(widget.snap['date published'].toString(),style: TextStyle(fontWeight: FontWeight.w200),)),
                  ],
                ),
                padding: EdgeInsets.only(left: 10)),
          ],
        ),
      ),
    );
  }
}
