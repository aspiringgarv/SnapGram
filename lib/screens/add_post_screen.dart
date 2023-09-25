import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/postMethods.dart';
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Addpostscreen extends StatefulWidget {
  const Addpostscreen({super.key});

  @override
  State<Addpostscreen> createState() => _AddpostscreenState();
}

class _AddpostscreenState extends State<Addpostscreen> {
  String  Caption = "";
  Uint8List? postimage;
  selectImage() async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("Choose image for the post"),
          backgroundColor: mobileBackgroundColor,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(width: 30,),
                Expanded(
                  flex: 3,
                  child: TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        Uint8List postfromgallery =
                            await pickImage(ImageSource.gallery);
                        setState(() {
                          postimage = postfromgallery;
                        });
                      },
                      child: Text("Choose from gallery")),
                ),
                Expanded(
                  flex: 2,
                  child: TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop(context);
                        Uint8List file = await pickImage(ImageSource.camera);
                        setState(() {
                          postimage = file;
                        });
                      },
                      child: Text("Take a photo")),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    splashRadius: 2.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.cancel, color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Caption.dispose();
  }
bool showindicator = false;
  void uploadpost(String uid,String userprofileimageurl,String username) async {
    setState(() {
      showindicator=true;
    });
   String res =  await PostMethods().post(file: postimage!,caption: Caption, uid: uid,Profileimage: userprofileimageurl,username: username);
    if(res!='success'){
      setState(() {
        show().showSnackBar(context,res);
        showindicator=false;
      });
    }
    if(res=='success'){
      setState(() {
        showindicator=false;
      });
      show().showSnackBar(context, "Posted");
      clear();
    }
  }
  void clear(){
    setState(() {
      postimage=null;
    });
  }
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return postimage == null
        ? Center(
            child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: IconButton(
              icon: Icon(
                Icons.upload,
                color: Colors.white,
              ),
              onPressed: () {
                selectImage();
              },
            ),
          ))
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading:
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
              title: Text("Post To"),
              actions: [
                TextButton(
                    onPressed: () {
                      uploadpost(user!.uid, user!.photoUrl, user!.username);
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    )),
              ],
            ),
            body: Column(
              children: [
                Visibility(
                  visible: showindicator,
                    child: LinearProgressIndicator()),
                  SizedBox(height: 10,),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoUrl.toString()),
                    ),
                    Expanded(
                      child: TextField(
                        // controller: Caption,
                        onSubmitted: (value) {
                          value = Caption;
                        },
                        decoration: InputDecoration(
                          hintText: "Write a Caption....",
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: InputBorder.none,
                        ),
                        maxLines: 10,
                      ),
                    ),
                    postimage != null
                        ? SizedBox(
                            height: 45,
                            width: 45,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: MemoryImage(postimage!),
                                ),
                              ),
                            ))
                        : SizedBox(
                            height: 45,
                            width: 45,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1691335799851-ea2799a51ff0?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=393&q=80'),
                                ),
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
          );
  }
}
