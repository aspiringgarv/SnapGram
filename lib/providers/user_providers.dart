import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/resources/auth_methods.dart';

class UserProvider extends ChangeNotifier{
  User? _user;
  User? get getUser => _user;
  Future<void>refreshUser() async{
    User user = await Authentication().getUserdetails();
    _user=user;
    notifyListeners();
  }
}
