import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
pickImage(ImageSource s)async{
  final ImagePicker picker = ImagePicker();
  XFile? file = await picker.pickImage(source: s);
  if(file!=null){
    return await file.readAsBytes();
  }
  else{
    print("No Image");
  }
}