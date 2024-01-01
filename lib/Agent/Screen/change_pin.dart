import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';


class ChangePin extends StatefulWidget {
  const ChangePin({super.key});

  @override
  State<ChangePin> createState() => _ChangePinState();
}

class _ChangePinState extends State<ChangePin> {
  OtpFieldController OldPinController = OtpFieldController();
  OtpFieldController PinController = OtpFieldController();
  OtpFieldController ConfirmPinController = OtpFieldController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String oldPin = "";
  String Pin = "";
  String confirmPin = "";
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
              "${lang?.translate('Change Transaction Pin')}",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30,
            ),
            Text("${lang?.translate('Enter Old Pin')}",style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(right: 80),
              child: OTPTextField(
                obscureText: true,
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                controller: OldPinController,
                style:TextStyle(fontSize: 20.0, color: Colors.black),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onCompleted: (pin) {
                  print("Completed: " + pin);
                },
                onChanged: (e){
                  oldPin = e;
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text("${lang?.translate('Enter New Pin')}",style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(right: 80),
              child: OTPTextField(
                obscureText: true,
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                controller: PinController,
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
              height: 15,
            ),
            Text("${lang?.translate('Enter Confirm Pin')}",style: TextStyle(fontWeight: FontWeight.w500),),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(right: 80),
              child: OTPTextField(
                obscureText: true,
                length: 4,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 40,
                controller: ConfirmPinController,
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

                    if(Pin.isNotEmpty||confirmPin.isNotEmpty||oldPin.isNotEmpty){
                      final AuP = context.read<AuthProvider>();

                      if(AuP.userData!.role == 'User'){
                        AuP.userChangePin(
                            AuP.userData!.id.toString(),
                            oldPin,
                            Pin,
                            confirmPin,
                            context);
                      }
                      else if(AuP.userData!.role == 'Agent'){
                        AuP.agentChangePin(
                            AuP.userData!.id.toString(),
                            oldPin,
                            Pin,
                            confirmPin,
                            context);
                      }
                    }
                    else{
                      if(Pin.isEmpty){
                        showSnackbarError(context, "${lang?.translate('Please Enter Pin')}");
                      }else if(confirmPin.isEmpty){
                        showSnackbarError(context, "${lang?.translate('Please Enter Confirm Pin')}");
                      }else if(oldPin.isEmpty){
                        showSnackbarError(context, "${lang?.translate('Please Enter Old Pin')}");
                      } else{
                        showSnackbarError(context, "${lang?.translate('Please Enter Pin')}");
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

