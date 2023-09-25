import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/storagemethods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/text_input.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_screen_layout.dart';
import '../responsive/webscreen_layput.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool rotate = false;
  Uint8List? im;
  Future<void> selectInmage() async {
    im = await pickImage(ImageSource.gallery);
    setState(() {});
  }

  void signupuser() async {
    setState(() {
      rotate = true;
    });
    String res = await Authentication().signup(
        email: email.text.toString(),
        username: username.text.toString(),
        bio: bio.text.toString(),
        file: im!,
        pass: pass.text.toString());
    if (res != 'success') {
      setState(() {
        rotate = false;
        show().showSnackBar(context, res);
      });
    }
    if (res == 'success') {
      setState(() {
        rotate = false;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) {
          return ResponsiveLayout(
              webscreenlayout: webscreenlayout(),
              mobilescreenlayout: MobilescreenLayout());
        },
      ));
    }
  }

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController bio = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    pass.dispose();
    bio.dispose();
    username.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Stack(
              children: [
                im != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(im!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://www.pngkey.com/png/full/115-1150152_default-profile-picture-avatar-png-green.png'),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: () {
                        selectInmage();
                      },
                      icon: Icon(
                        color: Colors.blue,
                        Icons.add_photo_alternate_rounded,
                      )),
                ),
              ],
            ),
            Textfieldinput(
                textInputType: TextInputType.emailAddress,
                textEditingController: email,
                hint: 'Enter Your Email'),
            const SizedBox(
              height: 5,
            ),
            Textfieldinput(
                textInputType: TextInputType.visiblePassword,
                textEditingController: pass,
                hint: 'Enter Your Password'),
            const SizedBox(
              height: 5,
            ),
            Textfieldinput(
                textInputType: TextInputType.emailAddress,
                textEditingController: username,
                hint: 'Enter Your UserName'),
            const SizedBox(
              height: 5,
            ),
            Textfieldinput(
                textInputType: TextInputType.emailAddress,
                textEditingController: bio,
                hint: 'Enter Your Bio'),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              onTap: () async {
                signupuser();
              },
              child: Container(
                child: rotate == true
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('SignUp'),
                width: double.infinity,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: blueColor,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: Container(),
              flex: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Already Have an Account',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ));
                    },
                    child: Container(
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
