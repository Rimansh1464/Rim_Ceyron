// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:ceyron_app/Agent/Screen/QR_Scan/qr_code.dart';
import 'package:ceyron_app/Agent/Screen/QR_Scan/send_money.dart';
import 'package:ceyron_app/Api/Controller/transaction_provider.dart';
import 'package:ceyron_app/User/Screen/pdf/show_all_adf.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../Api/Controller/auth_provider.dart';
import '../../../../Agent/Screen/bottom_bar.dart';
import '../../../../Api/Controller/getx_controller.dart';
import '../../../../Api/Controller/local_stuff.dart';
import '../../../../Api/Model/transaction_model.dart';
import '../../../../utils/widgets.dart';

class PdfSuccess extends StatefulWidget {
  var path;
  var name;


  PdfSuccess({super.key,required this.path,required this.name});

  @override
  State<PdfSuccess> createState() => _PdfSuccessState();
}

class _PdfSuccessState extends State<PdfSuccess> {
  GetController getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    return WillPopScope(
      onWillPop: () async{
        final ts = context.read<TransactionProvider>();
        //ts.updateData();
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
              SizedBox(height: 20,),
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary)
                  // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10)]
                ),
                child: Column(children: [
                  SizedBox(height: 20,),
                  Text("${lang?.translate('Success')}!",textAlign:TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                  Container(
                    child: LottieBuilder.asset(
                      'assets/lottie/suceess.json',
                      fit: BoxFit.cover,
                      repeat: true,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text("${widget.name}",textAlign:TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                  SizedBox(height: 10,),
                  Text("${lang?.translate('Statement Downloaded Successfully')}",textAlign:TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                  SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  // final file = File(widget.path);
                                  // if (await file.exists()) {
                                  //   await OpenFile.open(file.toString());
                                  // } else {
                                  //   // Handle the case where the file doesn't exist
                                  // }
                                  OpenFile.open(widget.path);

                                  //nextScreen(context, ShowAllPDF());
                                  },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 55,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.open_in_browser,color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text(
                                        '${lang?.translate('Open')}',

                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (await File(widget.path).exists()) {
                                    Share.shareFiles([widget.path], text: 'Share PDF File'); // filePath is the path to your PDF file
                                  } else {
                                    // Handle the case where the file doesn't exist
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 55,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.share,color: Colors.white,),
                                      SizedBox(width: 10,),
                                      Text(
                                        '${lang?.translate('Share')}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                          onTap: () async {
                            // final file = File(widget.path);
                            // if (await file.exists()) {
                            //   await OpenFile.open(file.toString());
                            // } else {
                            //   // Handle the case where the file doesn't exist
                            // }
                            //OpenFile.open(widget.path);

                            nextScreen(context, ShowAllPDF());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            height: 55,
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.open_in_new,color: Colors.white,),
                                SizedBox(width: 10,),
                                Flexible(
                                  child: Text(
                                    '${lang?.translate('View All Statement')}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      height: 1.5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                ],),
              ),

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