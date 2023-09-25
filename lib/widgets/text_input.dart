import 'package:flutter/material.dart';
class Textfieldinput extends StatelessWidget {
final TextEditingController textEditingController;
final String hint;
final TextInputType textInputType;
Textfieldinput({required this.textInputType,required this.textEditingController,required this.hint});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hint,
      border: OutlineInputBorder(
         borderSide:  Divider.createBorderSide(context),
      ),
        focusedBorder: OutlineInputBorder(
            borderSide: Divider.createBorderSide(context)
        ),
        enabledBorder:OutlineInputBorder(
            borderSide: Divider.createBorderSide(context)
        ),
      ),
     keyboardType: textInputType,
    );
  }
}
