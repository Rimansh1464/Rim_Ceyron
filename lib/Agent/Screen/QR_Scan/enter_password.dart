// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:provider/provider.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Controller/transaction_provider.dart';
import '../../../utils/widgets.dart';
import '../../AppBar/appbar.dart';

class EnterPassword extends StatefulWidget {
  var sendeId;
  var receiverId;
  var transactionType;
  var Amount;
  var finalAmount;
  var note;
  var amountoCollect;
  var agentcharge;
  var admincharge;
  var debitAmount;

   EnterPassword({super.key,
    required this.sendeId,
    required this.receiverId,
    required this.transactionType,
    required this.Amount,
    required this.finalAmount,
    required this.note,
    required this.amountoCollect,
    required this.agentcharge,
    required this.admincharge,
    required this.debitAmount,
  });

  @override
  State<EnterPassword> createState() => _EnterPasswordState();
}

class _EnterPasswordState extends State<EnterPassword> {
  OtpFieldController pinController = OtpFieldController();
  OtpFieldController confirmPinController = OtpFieldController();

  String Pin = "";
  String confirmPin = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate('Security Pin')}",),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(15),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.5),
                      blurRadius: 7,
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
                      "${lang?.translate('Security Pin')}",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                     Text(
                      '${lang?.translate('Confirm your transfer')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
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
                    ),                    SizedBox(
                      height: 10,
                    ),
                     Padding(
                      padding: EdgeInsets.only(right: 80),
                      child: OTPTextField(
                        obscureText: true,
                        length: 4,
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
                        controller: confirmPinController,
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
                      height: 50,
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
                            final ts = context.read<TransactionProvider>();
                            final AuP = context.read<AuthProvider>();
                            // if(pinController.text.isNotEmpty){
                            //   if(pinController.text == AuP.userData?.securityPin){
                            //     ts.transferMoney(
                            //         AuP.userData!.usersId,
                            //         ts.receiverData!.usersId,
                            //         widget.transactionType,
                            //         widget.Amount,
                            //         widget.note,
                            //         context).then((value) => adsLoader.close());
                            //     }
                            //
                            //   else{
                            //     showSnackbarError(context,"Incorrect Pin");
                            //   }
                            // }else{
                            //   showSnackbarError(context,"Please Enter Pin");
                            // }
                            if(Pin.isNotEmpty||confirmPin.isNotEmpty){
                              AuP.userData!.role == 'Agent' ? ts.pinVerify(
                                    AuP.userData!.id,
                                    Pin,
                                    confirmPin,
                                    widget.Amount,
                                    widget.finalAmount,
                                    widget.transactionType,
                                    widget.note,
                                    widget.amountoCollect,
                                    widget.agentcharge,
                                    widget.admincharge,
                                  context):
                              ts.pinVerifyUser(
                                  AuP.userData!.id,
                                  Pin,
                                  confirmPin,
                                  widget.Amount,
                                  widget.finalAmount,
                                  widget.transactionType,
                                  widget.note,
                                  widget.amountoCollect,
                                  widget.agentcharge,
                                  widget.admincharge,
                                  widget.debitAmount,
                                  context);
                              }
                            else{
                              if(Pin.isEmpty){
                                showSnackbarError(context, "${lang?.translate('Please Enter Pin')}");
                              }else if(confirmPin.isEmpty){
                                showSnackbarError(context, "${lang?.translate('Please Enter Pin')}");
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
                            child: Text(
                              '${lang?.translate('Confirm')}',
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
      ),
    );
  }
}
