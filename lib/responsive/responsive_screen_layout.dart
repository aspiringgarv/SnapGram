import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_providers.dart';
import 'package:instagram_clone/utils/globalconstants.dart';
import 'package:provider/provider.dart';
class ResponsiveLayout extends StatefulWidget {
  final Widget webscreenlayout;
  final Widget mobilescreenlayout;
  ResponsiveLayout({required this.webscreenlayout,required this.mobilescreenlayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  addData()async{
  UserProvider _userProvider = Provider.of(context,listen: false);
  await _userProvider.refreshUser();
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addData();
  }

  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
        builder:(context, constraints) {
          if(constraints.maxWidth>webscreensize){
            //web screen
            return widget.webscreenlayout;
          }
          else{
            return widget.mobilescreenlayout;
          }
        },
    );
  }
}
