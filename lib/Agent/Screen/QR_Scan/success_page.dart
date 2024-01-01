// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/Agent/Screen/QR_Scan/qr_code.dart';
import 'package:ceyron_app/Agent/Screen/QR_Scan/send_money.dart';
import 'package:ceyron_app/Api/Controller/transaction_provider.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/getx_controller.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Model/transaction_model.dart';
import '../../../utils/widgets.dart';
import '../bottom_bar.dart';

class SuccessPage extends StatefulWidget {
  var transaction_id;
  var sender_name;
  var receiver_name;
  var Amount;
  var transaction_date;
  var Note;
  TransactionsData Data;


  SuccessPage({super.key,
   required this.transaction_id,
   required this.sender_name,
   required this.receiver_name,
   required this.Amount,
   required this.transaction_date,
   required this.Note,
   required this.Data,
   });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  GetController getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    DateTime currentDateTime = DateTime.now();
    String formattedDateTime = DateFormat('MMM d, y H:mm').format(currentDateTime);
    var lang = LocalizationStuff.of(context);

    AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);
    TransactionProvider transProvider = Provider.of<TransactionProvider>(context,listen: false);
    double adminCharge = double.parse(widget.Data.adminCharge);
    double agentCharge = double.parse(widget.Data.agentCharge);
    double amount = double.parse(widget.Data.amount);
    double adminChargePer = (amount * adminCharge) / 100;
    double agentChargePer = (amount * agentCharge) / 100;
    return WillPopScope(
      onWillPop: () async{
        final ts = context.read<TransactionProvider>();
        //ts.updateData();
        nextScreen(context, MyBottomBarApp(visit: 0,));

        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
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
                        final ts = context.read<TransactionProvider>();
                        //ts.updateData();
                        nextScreen(context, MyBottomBarApp(visit: 0,));
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
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary)
                    // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]
                  ),
                child: Column(children: [
                  Container(
                    child: LottieBuilder.asset(
                      'assets/lottie/suceess.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("${lang?.translate('You Paid')} \$${widget.Amount} USD \n ${lang?.translate('to')} ${widget.receiver_name}",textAlign:TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  SizedBox(height: 40,),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(7),
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children:  [
                          Image.asset("assets/icon/ic_success.png",scale: 20,),
                          SizedBox(width: 10,),
                          getController.isCountry.value?
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${lang?.translate('Paid')} \$${widget.Amount}",style: TextStyle(fontSize: 20),),
                                SizedBox(height: 2,),
                                Text(formattedDateTime,style: TextStyle(fontSize: 15,color: Colors.grey,),),
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
                                Text("${lang?.translate('Paid')} ${(double.parse(widget.Data.amount) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}",style: TextStyle(fontSize: 20),),
                                SizedBox(height: 2,),
                                Text("\$${widget.Amount}",style: TextStyle(color: Colors.grey,fontSize: 13,fontWeight:FontWeight.w500),),
                                SizedBox(height: 2,),
                                Text(formattedDateTime,style: TextStyle(fontSize: 15,color: Colors.grey,),),
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
                        SizedBox(height: 10,),
                        Column(children: [
                          if(widget.Data.transactionType == "agent_to_agent")...[
                            if(getController.isCountry.value)...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${widget.Data.receiverName.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${widget.Data.amount} USD",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${double.parse(adminChargePer.toStringAsFixed(6))} USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${widget.Data.finalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                ],),
                            ]
                            else...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${widget.Data.receiverName.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${(amount * getController.currency.value).toStringAsFixed(4)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.amount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${(adminChargePer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${double.parse(adminChargePer.toStringAsFixed(6))} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${(double.parse(widget.Data.finalAmount)* getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.finalAmount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                            ]

                          ]
                          else...[
                            if(getController.isCountry.value)...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Your friend will get')}:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("${widget.Data.amount} USD",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${double.parse(adminChargePer.toStringAsFixed(6))} USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Agent Commission')} ${widget.Data.agentCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${double.parse(agentChargePer.toStringAsFixed(6))} USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${widget.Data.finalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Your Customer have to pay')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${widget.Data.amountToCollect} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                ],),
                            ]
                            else...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Your friend will get')}:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("${(double.parse(widget.Data.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.amount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Admin Charge')} ${widget.Data.adminCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${(double.parse(adminChargePer.toStringAsFixed(6)) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${double.parse(adminChargePer.toStringAsFixed(6))} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Agent Commission')} ${widget.Data.agentCharge}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                  Text("+ ${(double.parse(agentChargePer.toStringAsFixed(6)) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${double.parse(agentChargePer.toStringAsFixed(6))} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${(double.parse(widget.Data.finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.finalAmount} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                              SizedBox(height: 4,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("${lang?.translate('Your Customer have to pay')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                  Text("${(double.parse(widget.Data.amountToCollect) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                ],),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("${widget.Data.amountToCollect} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                ],),
                            ]
                          ]
                        ],)
                      ],),
                  ),

                ],),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final ts = context.read<TransactionProvider>();
                          //ts.updateData();
                          nextScreen(context,SendMoney());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
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
                            '${lang?.translate('Send Again')}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          final ts = context.read<TransactionProvider>();
                          //ts.updateData();
                           nextScreen(context, MyBottomBarApp(visit: 0,));
                        },
                        child:  Container(
                          alignment: Alignment.center,
                          height: 50,
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
                            '${lang?.translate('Go To Home')}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
            ],),
        ),
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