import'package:flutter/material.dart';
import 'package:instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_clone/responsive/responsive_screen_layout.dart';
import 'package:instagram_clone/responsive/webscreen_layput.dart';
import 'package:instagram_clone/screens/signupscreen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/widgets/text_input.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

import '../resources/storagemethods.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rotate = false;
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    pass.dispose();
  }
  void logintoaccount() async {
  setState(() {
    rotate  = true;
  });
   String res = await Authentication().login(email: email.text.toString(), pass: pass.text.toString());
   if(res!='success'){
     setState(() {
       rotate = false;
       show().showSnackBar(context, res);
     });
   }
   else if(res=='success'){
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
       return ResponsiveLayout(webscreenlayout: webscreenlayout(), mobilescreenlayout: MobilescreenLayout());
     },));
   }
   setState(() {
     rotate  = false;
   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child:Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Container(),flex: 2,),
                SvgPicture.asset('assets/logo.svg',height: 200,colorFilter: ColorFilter.mode(Colors.yellow,BlendMode.srcIn ),),
                Textfieldinput(textInputType: TextInputType.emailAddress, textEditingController: email, hint: 'Enter Your Email'),
                const SizedBox(height: 5,),
                Textfieldinput(textInputType: TextInputType.visiblePassword, textEditingController: pass, hint: 'Enter Your Password'),
                const SizedBox(height: 5,),
                InkWell(
                  onTap: () {
                     logintoaccount();
                  },
                  child: Container(
                    child: rotate==true?CircularProgressIndicator(color: Colors.white,):Text('Login'),
                    width: double.infinity,
                    height:40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: blueColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                Flexible(child: Container(),flex: 3,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(child:Text('Dont Have an Account',style: TextStyle(color: Colors.white),),),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => SignupScreen(),));
                      },
                        child: Container(child: Text('Sign Up',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),)),
                  ],
                ),

              ],
            ),
          )
      ),
    );
  }
}
