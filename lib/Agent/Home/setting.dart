import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Agent/AppBar/appbar.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/langauges_page.dart';
import '../../User/Screen/change_currency.dart';
import '../../utils/colors.dart';
import '../../utils/next_screen.dart';
import '../Screen/change_password.dart';
import '../Screen/edit_account_data.dart';

class AgentSetting extends StatefulWidget {
  const AgentSetting({super.key});

  @override
  State<AgentSetting> createState() => _AgentSettingState();
}

class _AgentSettingState extends State<AgentSetting> {
  @override
  Widget build(BuildContext context) {
    AuthProvider sp = Provider.of<AuthProvider>(context);
    var lang = LocalizationStuff.of(context);

    return  WillPopScope(
      onWillPop: () async {
        // Return false to prevent going back
        return Future.value(false);
      },
      child: Scaffold(
        appBar: CustomAppBar2(title:"${lang?.translate("Setting")}"),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditAccountData(),
                              ));
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        // Color(0XFF02C9C4),
                        // Color(0XFF09BDE8),
                        Color(0XFF3757fa),
                        Color(0XFF21b2e9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 15),
                      const Icon(Icons.edit, color: Colors.white),
                       Expanded(
                        child: Center(
                          child: Text(
                            "${lang?.translate("Edit Profile")}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(),
                      ));
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        // Color(0XFF7B10EA),
                        // Color(0XFF9C4CFD),
                        Color(0XFF3757fa),
                        Color(0XFF21b2e9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:15),
                      const Icon(Icons.lock, color: Colors.white,size: 30,),
                       Expanded(
                          child: Center(
                            child: Text(
                              "${lang?.translate("Change Password")}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  nextScreen(context, ChangeCurrency());
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        // Color(0XFF7B10EA),
                        // Color(0XFF9C4CFD),
                        Color(0XFF3757fa),
                        Color(0XFF21b2e9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:  Row(
                    children: [
                      SizedBox(width:15),
                      Icon(Icons.currency_exchange, color: Colors.white,size: 30,),
                      Expanded(
                          child: Center(
                            child: Text(
                              "${lang?.translate("Change Currency")}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: (){
                  nextScreen(context, LanguagePage());
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        // Color(0XFF7B10EA),
                        // Color(0XFF9C4CFD),
                        Color(0XFF3757fa),
                        Color(0XFF21b2e9),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:  Row(
                    children: [
                      SizedBox(width:15),
                      Icon(Icons.translate, color: Colors.white,size: 30,),
                      Expanded(
                          child: Center(
                            child: Text(
                              "${lang?.translate("Change Language")}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  sp.signOut(context).then((value) => Navigator.pushNamed(context, 'UserLogin'));
                },
                child: Container(
                  height: 55,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // color: const Color(0XFFDF0000),
                    gradient:  LinearGradient(
                      colors: [
                        primary,
                        primary2
                        // Color(0XFFDF0000),
                        // Color(0XFFFAB0AF),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width:15),
                      const Icon(Icons.logout,color: Colors.white,size: 28,),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${lang?.translate("Logout")}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 25)
            ],
          ),
        ),
      ),
    );
  }
}
