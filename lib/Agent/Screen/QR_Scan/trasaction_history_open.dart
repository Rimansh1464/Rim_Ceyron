// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/Agent/Screen/QR_Scan/qr_code.dart';
import 'package:ceyron_app/Agent/Screen/QR_Scan/send_money.dart';
import 'package:ceyron_app/Api/Controller/getx_controller.dart';
import 'package:ceyron_app/Api/Controller/transaction_provider.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Model/transaction_model.dart';
import '../../../utils/widgets.dart';
import '../bottom_bar.dart';

class TransactionView extends StatefulWidget {
  var transactionMode;
  TransactionsData Data;

  TransactionView({super.key,
    required this.transactionMode,
    required this.Data,
  });

  @override
  State<TransactionView> createState() => _TransactionViewState();
}

class _TransactionViewState extends State<TransactionView> {
  GetController getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    TransactionProvider transProvider = Provider.of<TransactionProvider>(context,listen: false);
    double adminCharge = double.parse(widget.Data.adminCharge);
    double agentCharge = double.parse(widget.Data.agentCharge);
    double amount = double.parse(widget.Data.amount);
    double adminChargePer = (amount * adminCharge) / 100;
    double agentChargePer = (amount * agentCharge) / 100;
    final inputDateString = "${widget.Data.transactionDate}";
    final inputDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
    final inputDate = inputDateFormat.parse(inputDateString);
    var lang = LocalizationStuff.of(context);

    final istTimeZoneOffset = Duration(hours: 5, minutes: 30); // UTC+05:30 for IST
    final istDateTime = inputDate.add(istTimeZoneOffset);

    final outputDateFormat = DateFormat("dd MMM, HH:mm a");
    final formattedDate = outputDateFormat.format(istDateTime);
    final sp = context.read<AuthProvider>();
    final ts = context.read<TransactionProvider>();
    return Scaffold(
      body:SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 45),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            widget.transactionMode == "send"
                ?Container(
              width: double.infinity,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primary)
                // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: LottieBuilder.asset(
                      'assets/lottie/suceess.json',
                      fit: BoxFit.cover,
                      repeat: true,),
                  ),
                  SizedBox(height: 20,),
                  Text("${lang?.translate('You Paid')} \$${widget.Data.finalAmount} USD \n ${lang?.translate('to')} ${widget.Data.receiverName}",textAlign:TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Row(children:  [
                            SizedBox(width: 5,),
                            Image.asset("assets/icon/ic_success.png",scale: 20,),
                            SizedBox(width: 15,),
                            getController.isCountry.value?
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${lang?.translate('Paid')} \$${widget.Data.finalAmount}",style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 2,),
                                  Text(formattedDate,style: TextStyle(fontSize: 15,color: Colors.grey,),),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "${lang?.translate('Transaction ID')}: ",
                                          style: TextStyle(fontSize: 13, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: "${widget.Data.transactionId}",
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    ),),
                                ],
                              ),
                            ):Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${lang?.translate('Paid')} ${(double.parse(widget.Data.finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 2,),
                                  Text("\$${widget.Data.finalAmount}",style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight:FontWeight.w500),),
                                  SizedBox(height: 2,),
                                  Text(formattedDate,style: TextStyle(fontSize: 15,color: Colors.grey,),),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "${lang?.translate('Transaction ID')}: ",
                                          style: TextStyle(fontSize: 13, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: "${widget.Data.transactionId}",
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    ),),
                                ],
                              ),
                            ),
                          ],),
                          SizedBox(height: 10,),
                          Divider(
                            thickness: 1,
                            height: 10,
                          ),
                          SizedBox(height: 12,),
                          Text("${lang?.translate('From')}: ${widget.Data.senderName}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                          SizedBox(height: 1,),
                          Row(
                            children: [
                              Text("${widget.Data.senderId}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black54),),
                              SizedBox(width: 10,),
                              InkWell(
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text:"${widget.Data.senderId}"));
                                    showSnackbarSuccess(context, '${lang?.translate('Copy Id to clipboard')}');
                                  },
                                  child: Icon(Icons.copy,size: 15,color: Colors.black54))
                            ],
                          ),
                          SizedBox(height: 12,),
                          Text("${lang?.translate('To')}: ${widget.Data.receiverName}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                          SizedBox(height: 1,),
                          Row(
                            children: [
                              Text("${widget.Data.receiverId}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black54),),
                              SizedBox(width: 10,),
                              InkWell(
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text:"${widget.Data.receiverId}"));
                                    showSnackbarSuccess(context, '${lang?.translate('Copy Id to clipboard')}');
                                  },
                                  child: Icon(Icons.copy,size: 15,color: Colors.black54))
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            height: 20,
                          ),
                          if(widget.Data.transactionType == "agent_to_agent")...[
                            if(getController.isCountry.value)...[
                              Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${widget.Data.receiverName.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                    // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                    Text("${widget.Data.amount} USD",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                  ],),
                                SizedBox(height: 6,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                    Text("+ ${double.parse(adminChargePer.toStringAsFixed(6))} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                  ],),
                                SizedBox(height: 6,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize:12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                    // Text("${totalAmount} USD",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                    Text("${widget.Data.finalAmount} USD",style:  TextStyle(fontSize:15,fontWeight:FontWeight.w500),),
                                  ],),
                                SizedBox(height: 6,),
                              ],),
                            ]else...[
                              Column(children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${widget.Data.receiverName.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                    // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                    Text("${(double.parse(widget.Data.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("${widget.Data.amount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                  ],),
                                SizedBox(height: 6,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                    Text("+ ${(double.parse(widget.Data.adminCharge) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("${double.parse(adminChargePer.toStringAsFixed(6))} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                  ],),
                                SizedBox(height: 6,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize:12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                    // Text("${totalAmount} USD",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                    Text("${(double.parse(widget.Data.finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style:  TextStyle(fontSize:15,fontWeight:FontWeight.w500),),
                                  ],),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("${widget.Data.finalAmount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                  ],),
                                SizedBox(height: 6,),
                              ],),
                            ]
                          ]
                          else if(widget.Data.transactionType == "agent_to_user")...[
                          if(getController.isCountry.value)...[
                            Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${widget.Data.receiverName.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                  Text("${widget.Data.amount} USD",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${adminChargePer.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Agent Commission')} ${widget.Data.agentCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${agentChargePer.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize:12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  // Text("${totalAmount} USD",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  Text("${widget.Data.finalAmount} USD",style:  TextStyle(fontSize:15,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Your Customer have to pay')} :",style: TextStyle(fontSize:12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  // Text("${totalAmount} USD",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  Text("${widget.Data.amountToCollect} USD",style:  TextStyle(fontSize:15,fontWeight:FontWeight.w500),),
                                ],),
                            ],),
                          ]else...[
                            Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${widget.Data.receiverName.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                  Text("${(double.parse(widget.Data.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.amount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${(double.parse(adminChargePer.toStringAsFixed(6)) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${adminChargePer.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Agent Commission')} ${widget.Data.agentCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${(double.parse(agentChargePer.toStringAsFixed(6)) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${agentChargePer.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize:12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  // Text("${totalAmount} USD",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  Text("${(double.parse(widget.Data.finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style:  TextStyle(fontSize:15,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.finalAmount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Your Customer have to pay')} :",style: TextStyle(fontSize:12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  // Text("${totalAmount} USD",style: TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  Text("",style:  TextStyle(fontSize:18,fontWeight:FontWeight.w500),),
                                  Text("${(double.parse(widget.Data.amountToCollect) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style:  TextStyle(fontSize:15,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.amountToCollect} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                            ],),
                             ]
                           ],
                          ],


                      ),
                    ),
                  ),
                ],
              ),
            )
                :Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primary)
                // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]
              ),
              child: Column(
                children: [
                  SizedBox(
                    // height: 120,
                    // width: 120,
                    child: LottieBuilder.asset(
                      'assets/lottie/suceess.json',
                      fit: BoxFit.cover,
                      repeat: true,),
                  ),
                  SizedBox(height: 20,),
                  Text("${lang?.translate("You Will Receive")} \$${widget.Data.finalAmount} USD \n ${lang?.translate("from")} ${widget.Data.senderName}",textAlign:TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  // Text("${widget.Data.transactionType}",textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.w500),),
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(0),
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Row(children:  [
                            SizedBox(width: 0,),
                            Image.asset("assets/icon/ic_success.png",scale: 20,),
                            SizedBox(width: 10,),
                            getController.isCountry.value?
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${lang?.translate("Received")} \$${widget.Data.finalAmount}",style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 2,),
                                  Text(formattedDate,style: TextStyle(fontSize: 15,color: Colors.grey,),),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "${lang?.translate('Transaction ID')}: ",
                                          style: TextStyle(fontSize: 13, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: "${widget.Data.transactionId}",
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    ),),
                                ],
                              ),
                            ): Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${lang?.translate("Received")} ${(double.parse(widget.Data.finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 20),),
                                  SizedBox(height: 2,),
                                  Text("\$${widget.Data.finalAmount}",style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight:FontWeight.w500),),
                                  SizedBox(height: 2,),
                                  Text(formattedDate,style: TextStyle(fontSize: 15,color: Colors.grey,),),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Transaction ID: ",
                                          style: TextStyle(fontSize: 13, color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: "${widget.Data.transactionId}",
                                          style: TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                      ],
                                    ),),
                                ],
                              ),
                            ),
                          ],),
                          SizedBox(height: 10,),
                          Divider(
                            thickness: 1,
                            height: 10,
                          ),
                          SizedBox(height: 12,),
                          Text("${lang?.translate('From')}: ${widget.Data.senderName}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                          SizedBox(height: 1,),
                          Row(
                            children: [
                              Text("${widget.Data.senderId}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black54),),
                              SizedBox(width: 10,),
                              InkWell(
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text:"${widget.Data.senderId}"));
                                    showSnackbarSuccess(context, '${lang?.translate('Copy Id to clipboard')}');
                                  },
                                  child: Icon(Icons.copy,size: 15,color: Colors.black54))
                            ],
                          ),
                          SizedBox(height: 12,),
                          Text("${lang?.translate('To')}: ${widget.Data.receiverName}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
                          SizedBox(height: 1,),
                          Row(
                            children: [
                              Text("${widget.Data.receiverId}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Colors.black54),),
                              SizedBox(width: 10,),
                              InkWell(
                                  onTap: (){
                                    Clipboard.setData(ClipboardData(text:"${widget.Data.receiverId}"));
                                    showSnackbarSuccess(context, '${lang?.translate('Copy Id to clipboard')}');
                                  },
                                  child: Icon(Icons.copy,size: 15,color: Colors.black54))
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            height: 20,
                          ),
                          if(widget.Data.transactionType == "user_to_agent")...[
                            if(getController.isCountry.value)...[
                              Container(
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate("Commission received")}:",style: TextStyle(fontSize: 10,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("+ ${agentChargePer.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate("You will get")}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${widget.Data.finalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                ],),
                              ),]
                            else...[
                              Container(
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate("Commission received")}:",style: TextStyle(fontSize: 10,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("+ ${(double.parse(agentChargePer.toStringAsFixed(6)) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${agentChargePer.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text("${lang?.translate("You will get")}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${(double.parse(widget.Data.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${widget.Data.amount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                ],),
                              ),
                            ]
                          ]else...[
                            if(getController.isCountry.value)...[
                              Container(
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate("You will get")}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${widget.Data.finalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                ],),
                              ),]
                            else...[
                              Container(
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text("${lang?.translate("You will get")}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${(double.parse(widget.Data.finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${widget.Data.finalAmount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                ],),
                              ),
                            ]

                          ]
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ],),
      ),
    );
  }
}

class MyDateTimeFormatter {
  static String format(DateTime dateTime) {
    final dateFormat = DateFormat('MMM d, y H:mm');
    return dateFormat.format(dateTime);
  }
}