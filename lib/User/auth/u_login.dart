// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:ceyron_app/User/auth/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../Agent/auth/forgot_passwors.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/getx_controller.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  // TextEditingController emailController = TextEditingController(text: 'john@example.com');
  // TextEditingController passController = TextEditingController(text: '123456');
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  GetController getController = Get.put(GetController());

  getLang(){
    getController.getLocale().then((locale) async {
      Locale _locale = await getController.GetLocat();

      MyApp.setLocale(context, _locale);

      setState(() {
        getController.locales = locale;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    //getLang();

    print("dfkhbjdgjklsfjksdfghdkjsgljffdlsjgdklskgjdksdfjglfdfk");
  }
  @override
  void didChangeDependencies() {
    getController.getLocale().then((locale) {
      setState(() {
        getController.locales = locale;
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary,
                      primary2,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/AppLogo.png",
                          scale: 2.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 280,
                        height: 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 320,
                        alignment: Alignment.center,
                        child: buildCard(size * 0.75),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    var lang = LocalizationStuff.of(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 35,
                height: 4.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "${lang?.translate("User Login")}",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${lang?.translate('Sign in with your Ceyron Account')}",
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5)),
            ),
            SizedBox(
              height: 35,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Email")}",
                hintText: "${lang?.translate("Enter your email")}",
                TextInputTypes: TextInputType.emailAddress,

                controller: emailController,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please Enter Email ID")}';
                  }

                  if (!isValidEmail(input)) {
                    return '${lang?.translate("Please Enter a Valid Email ID")}';
                  }
                },
                icon: Icons.supervised_user_circle_outlined),
            SizedBox(
              height: size.height * 0.02,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Password")}",
                hintText: "${lang?.translate("Enter Your Password")}",
                TextInputTypes: TextInputType.visiblePassword,
                controller: passController,
                obscureTexts: _obscureText ,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle password visibility
                    });
                  },
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please Enter a Password")}';
                  }

                  if (input.length < 6) {
                    return '${lang?.translate("Please Enter 6 Digit Password")}';
                  }

                  return null;
                },
                icon: Icons.lock_outline_rounded),
            SizedBox(
              height: size.height * 0.02,
            ),
            InkWell(
              onTap: () {
                // Navigator.pushNamed(context, 'ForgetPassword');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPassword(
                        "Forget Password", role: 'User',
                      ),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${lang?.translate("Forget Password?")}",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  authProvider
                      .userLogin(
                    emailController.text,
                    passController.text,
                    context, // Pass the context to the function for SnackBar
                  );
                  // Navigator.pushNamed(context, 'userBottomBarApp');
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                    colors: [
                      primary,
                      primary2,
                    ],
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4C2E84).withOpacity(0.2),
                      offset: const Offset(0, 15.0),
                      blurRadius: 60.0,
                    ),
                  ],
                ),
                child: Text(
                  '${lang?.translate("Login")}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => User_Signup(),
                        ));
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${lang?.translate("Don't have an account?")}",
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: " ${lang?.translate("SING UP")}",
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.w500)),
                  ])),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, '');
                    },
                    child: Text("${lang?.translate("OR")}")),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    child: Text(
                      "${lang?.translate("Login with Agent")}",
                      style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    )),
              ],
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Regular expression pattern for email validation
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    return emailRegex.hasMatch(email);
  }
}
