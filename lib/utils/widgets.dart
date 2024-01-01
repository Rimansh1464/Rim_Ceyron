import 'dart:io';
import 'dart:typed_data';

import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:dialog_loader/dialog_loader.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../Api/Controller/transaction_provider.dart';

Widget CommanTextField(
    {hint,
    image,
    maxLines,
    keyboardType,
    validator,
    minline,
    controller,
    suffixIcon,
    obscureText,
    prefixIcon,
    readOnly,
    focusNode,
    onTap,
    boxShadow,
    autovalidate,
    inputFormatters,
    labelText,
    onEditingComplete,
    onChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 10),
        child: Text(
          labelText,
          style: TextStyle(
              letterSpacing: 0.5,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primary),
        ),
      ),
      SizedBox(height: 8),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: boxShadow ??
              [
                BoxShadow(
                    color: primary.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 1)
              ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextFormField(
            onEditingComplete: onEditingComplete,
            onChanged: onChanged,
            onTap: onTap,
            validator: validator,
            keyboardType: keyboardType,
            controller: controller,
            inputFormatters: inputFormatters,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            maxLines: maxLines,
            minLines: minline,
            focusNode: focusNode,
            autofocus: false,
            readOnly: readOnly ?? false,
            obscureText: obscureText ?? false,
            style: TextStyle(fontSize: 16, letterSpacing: 0.2),
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              border: InputBorder.none,
            ),
            // textCapitalization: TextCapitalization.sentences,
          ),
        ),
      ),
      SizedBox(height: 15)
    ],
  );
}

Widget Authtextfeild1({conHeight,textSize,controller, validator, titletext, hintText, icon,color,ontap,inputFormatters,Maxline}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        titletext,
        style: TextStyle(
          fontSize: textSize??12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: 8,
      ),
      Container(
        height:conHeight ??  55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color?? Color.fromRGBO(248, 247, 251, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              icon !=null?Icon(
                icon,
                size: 16,
              ):SizedBox(),
               SizedBox(
                width: icon !=null?16:0,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  onTap: ontap,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: const Color(0xFF151624),
                  ),
                  inputFormatters: inputFormatters,
                  validator: validator,
                  maxLines: Maxline,
                  cursorColor: const Color(0xFF151624),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: const Color(0xFF151624).withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      TextFormField(
        controller: controller,
        onTap: ontap,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          fontSize: 16.0,
          color: const Color(0xFF151624),
        ),
        inputFormatters: inputFormatters,
        validator: validator,
        maxLines: Maxline,
        cursorColor: const Color(0xFF151624),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(
            icon,
            size: 16,
          )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF151624).withOpacity(0.5),
          ),
          filled: true,
          fillColor: color ?? Color.fromRGBO(248, 247, 251, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),

    ],
  );
}

Widget Authtextfeild({
  conHeight, // Provide the desired custom height here
  textSize,
  controller,
  validator,
  titletext,
  hintText,
  icon,
  color,
  ontap,
  obscureTexts,
  suffixIcon,
  inputFormatters,
  TextInputTypes,
  int Maxline = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        titletext,
        style: TextStyle(
          fontSize: textSize ?? 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: 8,
      ),
      TextFormField(
        controller: controller,
        onTap: ontap,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          fontSize: 16.0,
          color: const Color(0xFF151624),
        ),
        inputFormatters: inputFormatters,
        validator: validator,
        obscureText:obscureTexts?? false,
        keyboardType: TextInputTypes,
        maxLines: Maxline,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: const Color(0xFF151624),
        decoration: InputDecoration(
          prefixIcon: icon != null
              ? Icon(
            icon,
            size: 16,
          )
              : null,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF151624).withOpacity(0.5),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: color ?? Color.fromRGBO(248, 247, 251, 1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
      ),
    ],
  );
}

bool isValidEmail(String email) {
  // Regular expression pattern for email validation
  final emailRegex =
  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

  return emailRegex.hasMatch(email);
}
void showSnackbarMessage(BuildContext context, String message) {
  return ElegantNotification.info(
    width: 360,
    height: 80,
    notificationPosition: NotificationPosition.topLeft,
    animation: AnimationType.fromTop,
    description: Text(message),
    onDismiss: () {},
  ).show(context);
}

void showSnackbarError(BuildContext context, String message) {
  return ElegantNotification.error(
    width: 360,
    height: 80,
    notificationPosition: NotificationPosition.topLeft,
    animation: AnimationType.fromTop,
    description: Text(message),
    onDismiss: () {},
  ).show(context);
}

void showSnackbarSuccess(BuildContext context, String message) {
  return ElegantNotification.success(
    width: 360,
    height: 80,
    notificationPosition: NotificationPosition.topLeft,
    animation: AnimationType.fromTop,
    description: Text(message),
    onDismiss: () {},
  ).show(context);
}

final AdsLoader adsLoader = AdsLoader();

class AdsLoader {
  static late DialogLoader _dialogLoader;

  Future<void> show(BuildContext context) async {
    _dialogLoader = DialogLoader(context: context);

    _dialogLoader.show(
      barrierDismissible: false,
      theme: LoaderTheme.dialogDefault,

      borderRadius: 8,
      title: const Text(
        "Loading...",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      // rightIcon: const CircularProgressIndicator(),
      leftIcon: const SpinKitCircle(
        size: 24,
        color: Colors.black,
      ),
    );
  }

  void close() {
    _dialogLoader.close();
  }
}
TextEditingController _outputController = TextEditingController();

Future<void> refresh(context) async {
  AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);

  try {
    authProvider.updateData(context);

    await Future.delayed(Duration(seconds: 1));

  } catch (error) {
    // Handle any errors that occur during data fetching
  }
}

