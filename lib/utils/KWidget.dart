
import 'package:flutter/material.dart';
import 'package:tsbeh/utils/appColors.dart';
import 'package:nb_utils/nb_utils.dart';

TextFormField  editTextField(var hintText, var controller,var validationText, bool isNumber ,  String initialValue   , {isPassword = false,bool isNext = false,FocusNode? inputNode}) {
  return TextFormField(
      style: primaryTextStyle(size: 18),
      obscureText: isPassword,
      controller: (controller.text == '') ? (controller..text = initialValue) : controller  ,
  // controller..text = initialValue,
      validator: (val) => val!.length < 1 ? validationText : null,
      keyboardType: isNumber ? TextInputType.numberWithOptions(decimal: true) :null ,
      // keyboardType: isNumber ? TextInputType.number:null ,
      textInputAction: isNext ? TextInputAction.next : TextInputAction.done ,
      focusNode: inputNode ,
      autofocus:  (inputNode != null) ? true : false,



      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(26, 4, 4, 18),
          hintText: hintText,

          filled: true,
          fillColor: t3_edit_background,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: t3_edit_background, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: BorderSide(color: t3_edit_background, width: 0.0),
          )));
}