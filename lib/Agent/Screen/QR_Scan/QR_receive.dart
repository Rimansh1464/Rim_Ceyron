// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Controller/transaction_provider.dart';
import '../../../utils/widgets.dart';
import '../../AppBar/appbar.dart';

class QrReceive extends StatefulWidget {
  const QrReceive({super.key});

  @override
  State<QrReceive> createState() => _QrReceiveState();
}

class _QrReceiveState extends State<QrReceive> {
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    TransactionProvider TsP = Provider.of<TransactionProvider>(context,listen: false);
    AuthProvider Auth = Provider.of<AuthProvider>(context,listen: false);
    var lang = LocalizationStuff.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate('QR Code')}",),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Screenshot(
              controller: screenshotController,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade200,
                    // border: Border.all(color: primary2)
                ),
                child: Column(children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/image/user.png'))),
                  ),
                  SizedBox(height: 5,),
                  Center(child: Text("${Auth.userData!.name}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)),
                  SizedBox(height: 20,),
                  Container(
                      height: 230,
                      width: 230,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          // border: Border.all(color: primary2)
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.grey.shade200,blurRadius: 10)]

                      ),
                      child:Image.memory(TsP.qrImage!)),
                  SizedBox(height: 10,),
                  Text("${lang?.translate('Scan to pay with any Ceyron app')}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400),),
                  SizedBox(height: 20,),
                  Text("ID: ${Auth.userData!.usersId}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),

                ],),
              ),
            ),
            Divider(height: 40,thickness: 1.5,endIndent: 40,indent: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                      Clipboard.setData(ClipboardData(text:"${Auth.userData!.usersId}"));
                      showSnackbarSuccess(context, '${lang?.translate('Copy Id to clipboard')}');
                      },
                  child: Container(
                      height: 50,
                      width: 130,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: primary,gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.copy_rounded,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("${lang?.translate('Copy')}",style: TextStyle(fontSize: 16,color: Colors.white),),
                        ],
                      )

                  ),
                ),
                InkWell(
                  onTap: (){
                     shareScreenshot();
                    },
                  child: Container(
                      height: 50,
                      width: 130,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: primary,gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),),
                      child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.share_outlined,color: Colors.white,),
                      SizedBox(width: 10,),
                      Text("${lang?.translate('Share')}",style: TextStyle(fontSize: 16,color: Colors.white),),
                    ],
                  )

                  ),
                ),
              ],),
            SizedBox(height: 70,),
        ],),
      ),
    );
  }
  void shareScreenshot() async {
    try {
      final imageUint8List = await screenshotController.capture();

      if (imageUint8List!.isNotEmpty) {
        final tempDir = await getTemporaryDirectory();
        final tempFilePath = '${tempDir.path}/screenshot.png';

        File tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(imageUint8List);

        Share.shareFiles(
          [tempFilePath],
          text: 'Check out this screenshot!',
        );
      } else {
        print('Failed to capture screenshot.');
      }
    } catch (e) {
      print('Error capturing screenshot: $e');
    }
  }



}
