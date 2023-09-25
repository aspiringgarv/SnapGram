import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class Search_Screen extends StatefulWidget {
  const Search_Screen({super.key});

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
String search = "";
int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          // controller: search,
         decoration: InputDecoration(
           hintText: "Search For Your Friend",
           border: InputBorder.none,

         ),
          onFieldSubmitted: (value) {
           setState(() {
             search=value;
           });
          },
        ),
        backgroundColor: mobileBackgroundColor,
      ),
      body: search.isEmpty?
          FutureBuilder(
            future: FirebaseFirestore.instance.collection('post').get(),
            builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              return snapshot.hasData&&snapshot.connectionState==ConnectionState.done?AlignedGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 2,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  return Image.network('${snapshot.data?.docs[index].data()['posturl']}');
                },
                itemCount: snapshot.data?.docs.length,
              ):
               Center(
                child: CircularProgressIndicator(),
              );
            },
          )
          :FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').where('username',isGreaterThanOrEqualTo: search).get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if(snapshot.hasData&&search.isNotEmpty){
          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen(uid: '${snapshot.data?.docs[index].data()['uid']}',),));
                },
                child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage('${snapshot.data?.docs[index].data()['photourl']}'),

                ),
                  title: Text("${snapshot.data?.docs[index].data()['username']}"),
                ),
              );
          },);
        }

        else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },),
    );
  }
}
