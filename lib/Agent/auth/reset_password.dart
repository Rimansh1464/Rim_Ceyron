// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/colors.dart';

class ResetPassword extends StatefulWidget {
  String email;
  String role;

   ResetPassword({super.key,required this.email,required this.role});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController PasswordController = TextEditingController();
  TextEditingController ConfirmPasswordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var lang = LocalizationStuff.of(context);

    final size = MediaQuery.of(context).size;
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
            padding: const EdgeInsets.only(top: 130),
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withOpacity(0.5),
                              blurRadius: 10,
                            )
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 20),
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
                                "${lang?.translate('Reset Password')}",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "${lang?.translate('Please enter and confirm your password.Minimum of 6 characters.')}",
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                '${lang?.translate('Enter New Password')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromRGBO(248, 247, 251, 1),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.lock_open,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: PasswordController,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: const Color(0xFF151624),
                                          ),
                                          validator: (input) {
                                            if (input == null || input.isEmpty) {
                                              return '${lang?.translate('Please enter a password')}';
                                            }
                                            if (input.length < 6) {
                                              return '${lang?.translate('Please enter 6 digit password')}';
                                            }
                                            return null;
                                          },
                                          obscureText: _obscureText ,
                                          cursorColor: const Color(0xFF151624),
                                          decoration: InputDecoration(
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
                                            hintText: '${lang?.translate('Enter password')}',
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: const Color(0xFF151624)
                                                  .withOpacity(0.5),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                '${lang?.translate('Enter Confirm Password')}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: const Color.fromRGBO(248, 247, 251, 1),
                                ),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.lock_open,
                                        size: 16,
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: ConfirmPasswordController,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: const Color(0xFF151624),
                                          ),
                                          validator: (input) {
                                            if (input == null || input.isEmpty) {
                                              return '${lang?.translate('Please enter a password')}';
                                            }

                                            if (input.length < 6) {
                                              return '${lang?.translate('Please enter 6 digit password')}';
                                            }
                                            if (input != PasswordController.text) {
                                              return '${lang?.translate('Passwords do not match')}';
                                            }

                                            return null;
                                          },
                                          obscureText: _obscureText1 ,
                                          cursorColor: const Color(0xFF151624),
                                          decoration: InputDecoration(
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
                                            hintText: '${lang?.translate('Enter confirm password')}',
                                            hintStyle: TextStyle(
                                              fontSize: 16.0,
                                              color: const Color(0xFF151624)
                                                  .withOpacity(0.5),
                                            ),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                        '${lang?.translate('Cancel')}',
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
                                        AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);

                                        authProvider.resetPassword(widget.email,PasswordController.text,ConfirmPasswordController.text,widget.role,context);
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
                                        '${lang?.translate('Continue')}',
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

                              const SizedBox(
                                height: 60,
                              ),

                            ],
                          ),
                        ),
                      ),
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
}
