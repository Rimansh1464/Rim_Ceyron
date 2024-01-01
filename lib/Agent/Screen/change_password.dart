import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController OldPasswordController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
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
            padding: EdgeInsets.only(top: size * 0.20),
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
    );
  }
  Widget buildCard(double size) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
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
              "${lang?.translate("Change Password")}",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Enter old password")}",
                hintText: "${lang?.translate("Enter old password")}",
                controller: OldPasswordController,
                TextInputTypes: TextInputType.visiblePassword,
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
                    return '${lang?.translate("Please enter a old password")}';
                  }

                  if (input.length < 6) {
                    return '${lang?.translate("Please enter 6 digit password")}';
                  }

                  return null;
                },
                icon: Icons.lock_open),
            SizedBox(
              height: 10,
            ),

            Authtextfeild(
                titletext: "${lang?.translate("Enter New Password")}",
                hintText: "${lang?.translate("Enter New Password")}",
                controller: PasswordController,
                TextInputTypes: TextInputType.visiblePassword,
                obscureTexts: _obscureText1 ,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText1 ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText1 = !_obscureText1; // Toggle password visibility
                    });
                  },
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please enter a password")}';
                  }

                  if (input.length < 6) {
                    return '${lang?.translate("Please enter 6 digit password")}';
                  }

                  return null;
                },
                icon: Icons.lock_open),

            SizedBox(
              height: 15,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Enter Confirm Password")}",
                hintText: "${lang?.translate("Enter Confirm Password")}",
                controller: ConfirmPasswordController,
                TextInputTypes: TextInputType.visiblePassword,
                obscureTexts: _obscureText2 ,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText2 ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText2 = !_obscureText2; // Toggle password visibility
                    });
                  },
                ),
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please enter a password")}';
                  }

                  if (input.length < 6) {
                    return '${lang?.translate("Please enter 6 digit password")}';
                  }
                  if (input != PasswordController.text) {
                    return '${lang?.translate("Passwords do not match")}';
                  }

                  return null;
                },
                icon: Icons.lock_open),

            SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
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
                          color: const Color(0xFF4C2E84)
                              .withOpacity(0.2),
                          offset: const Offset(0, 15.0),
                          blurRadius: 60.0,
                        ),
                      ],
                    ),
                    child: Text(
                      '${lang?.translate("Cancel")}',
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
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final sp = context.read<AuthProvider>();

                      if(sp.userData!.role == 'User'){
                        sp.userChangePassword(
                            sp.userData!.id.toString(),
                            OldPasswordController.text,
                            PasswordController.text,
                            ConfirmPasswordController.text,
                            context);
                      }
                      else if(sp.userData!.role == 'Agent'){
                        sp.agentChangePassword(
                            sp.userData!.id.toString(),
                            OldPasswordController.text,
                            PasswordController.text,
                            ConfirmPasswordController.text,
                            context);
                      }

                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
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
                          color: const Color(0xFF4C2E84)
                              .withOpacity(0.2),
                          offset: const Offset(0, 15.0),
                          blurRadius: 60.0,
                        ),
                      ],
                    ),
                    child:  Text(
                      '${lang?.translate("Continue")}',
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
              ],
            ),
            SizedBox(
              height:10,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

