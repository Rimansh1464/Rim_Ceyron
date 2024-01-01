// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class CreatePin extends StatefulWidget {
  String? result;

   CreatePin({super.key, this.result});

  @override
  State<CreatePin> createState() => _CreatePinState();
}

class _CreatePinState extends State<CreatePin> {

  @override

  
  String Pin ="";
  String confirmPin ="";
  @override
  void initState() {
    // TODO: implement initState
    final sp = context.read<AuthProvider>();
    sp.getUserData();

    super.initState();
  }
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    var lang = LocalizationStuff.of(context);

    String? _otp;
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
                              widget.result != "Singup"?"${lang?.translate('Create Pin')}":"${lang?.translate('Create Security Pin')}",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              '${lang?.translate('Enter Pin')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 80),
                              child: OTPTextField(
                                length: 4,
                                obscureText: true,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 40,
                                style:TextStyle(fontSize: 20.0, color: Colors.black),
                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.box,
                                onCompleted: (pin) {
                                  print("Completed: " + pin);
                                },
                                onChanged: (e){
                                  Pin = e;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              '${lang?.translate('Enter Confirm Pin')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 80),
                              child: OTPTextField(
                                length: 4,
                                obscureText: true,
                                width: MediaQuery.of(context).size.width,
                                fieldWidth: 40,
                                style:TextStyle(fontSize: 20.0, color: Colors.black),
                                textFieldAlignment: MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.box,
                                onCompleted: (pin) {
                                  print("Completed: " + pin);
                                },
                                onChanged: (e){
                                  confirmPin = e;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 45,
                            ),
                            InkWell(
                              onTap: () {
                                final sp = context.read<AuthProvider>();

                                if(Pin.isNotEmpty||confirmPin.isNotEmpty){
                                  if(widget.result == "Singup"){

                                    sp.agentCreatePin(
                                        sp.userData!.id.toString(),
                                        Pin,
                                        confirmPin,
                                        context)
                                        .then((value) => sp.setSignIn());
                                  }
                                  else if(widget.result == "Login"){
                                   // sp.agentChackPin(
                                   //     Pin,
                                   //     confirmPin,
                                   //     context)
                                   //     .then((value) => sp.setSignIn());
                                  }else if(widget.result == "check"){
                                   // sp.agentChackPin(
                                   //     Pin,
                                   //     confirmPin,
                                   //     context)
                                   //     .then((value) => sp.setSignIn());
                                  }

                                }
                                else{
                                  if(Pin.isEmpty){
                                    showSnackbarError(context, "${lang?.translate('Please Enter Pin')}");
                                  }else if(confirmPin.isEmpty){
                                    showSnackbarError(context, "${lang?.translate('Please Enter Confirm Pin')}");
                                  } else{
                                    showSnackbarError(context, "${lang?.translate('Please Enter Confirm Pin')}");
                                  }
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
                                      color:
                                      const Color(0xFF4C2E84).withOpacity(0.2),
                                      offset: const Offset(0, 15.0),
                                      blurRadius: 60.0,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${lang?.translate('Proceed')}',
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
                              height: size.height * 0.02,
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
