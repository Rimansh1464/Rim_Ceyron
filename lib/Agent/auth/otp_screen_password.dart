// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/colors.dart';

class OtpPagePassword extends StatefulWidget {
  String email;
  String role;

   OtpPagePassword({super.key,required this.email,required this.role});

  @override
  State<OtpPagePassword> createState() => _OtpPagePasswordState();
}

class _OtpPagePasswordState extends State<OtpPagePassword> {
  int minutes = 1; // Initial minutes
  int seconds = 0; // Initial countdown value
  bool isResend = false;
  Timer? timer;

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (minutes == 0 && seconds == 0) {
          isResend = false;
          timer.cancel(); // Stop the countdown when it reaches 0
        } else {
          if (seconds == 0) {
            minutes--;
            seconds = 59;
          } else {
            seconds--;
          }
          isResend = true;
        }
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  Future<void> generateOTP() async {
    // Simulate generating an OTP (replace this with your actual OTP generation logic)
    await Future.delayed(Duration(seconds: 5)); // Simulate some processing time
    print('OTP generated');
  }
  String OTP = "";
  OtpFieldController otpFieldController = OtpFieldController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startCountdown();
    otpFieldController =OtpFieldController();
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final AuP = context.read<AuthProvider>();
    final size = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String countdownText = '$minutes:${seconds.toString().padLeft(2, '0')}';
    var lang = LocalizationStuff.of(context);

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
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            Lottie.asset("assets/lottie/otp.json",height: 160),
                            Text(
                              "OTP Verification",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            AuP.userData == null?Text(
                              '${lang?.translate('Check your Email. We have Send you the at')} ${widget.email}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ):Text(
                              '${lang?.translate('Check your Email. We have Send you the at')} ${widget.email}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 15,left: 15),
                              child: OTPTextField(
                                length: 6,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 30,
                                controller: otpFieldController,
                                style:TextStyle(fontSize: 20.0, color: Colors.black),
                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                onCompleted: (pin) {
                                  print("Completed: " + pin);
                                  OTP = pin;
                                },
                                onChanged: (e){
                                  setState(() {
                                    e = OTP;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {

                                      otpFieldController.clear();
                                      AuP.agentSendOTP1(email: widget.email,context:context);
                                      setState(() {
                                        timer?.cancel(); // Stop the countdown when it reaches 0
                                        minutes = 1; // Reset minutes to 1
                                        seconds = 0; // Reset seconds to 0
                                      });
                                      startCountdown();
                                    },
                                    child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "${lang?.translate("Don't Receive OTP?")}",
                                              style: TextStyle(color: Colors.grey)),
                                          TextSpan(
                                              text: " ${lang?.translate('Resend OTP')}",
                                              style: TextStyle(
                                                  color: primary, fontWeight: FontWeight.w500)),
                                        ])),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '$countdownText',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                    width: 120,
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
                                isResend == false
                                    ?InkWell(
                                  onTap: () {

                                    otpFieldController.clear();
                                    AuP.agentSendOTP1(email: widget.email,context:context);

                                    setState(() {
                                      minutes = 1; // Reset minutes to 1
                                      seconds = 0; // Reset seconds to 0
                                    });
                                      startCountdown(); // Start the countdown again

                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 120,
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
                                      '${lang?.translate('Resend OTP')}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                                    :InkWell(
                                  onTap: () {
                                    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
//
                                    print("OTP::$OTP");
                                    authProvider.userCheckOTPPassword(OTP,widget.email,widget.role,context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    width: 120,
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
                            SizedBox(
                              height: 60,
                            ),
                          ],
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
