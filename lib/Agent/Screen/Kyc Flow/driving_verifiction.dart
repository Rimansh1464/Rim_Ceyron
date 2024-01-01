// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/Agent/Screen/Kyc%20Flow/upload_document.dart';
import 'package:flutter/material.dart';

import '../../../Api/Controller/local_stuff.dart';
import '../../../utils/colors.dart';
import '../../../utils/next_screen.dart';

class VerifyDriving extends StatefulWidget {
  const VerifyDriving({super.key});

  @override
  State<VerifyDriving> createState() => _VerifyDrivingState();
}

class _VerifyDrivingState extends State<VerifyDriving> {
  Color mainColor = Color(0xff80bc2c);

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 30,),
            Row(children: [
              InkWell(
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
            ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${lang?.translate("Let's Verify Your Driving Licence")}",textAlign: TextAlign.center,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: Colors.black),),
              ],
            ),
            SizedBox(height: 10,),
            Image.asset("assets/image/licence.png"),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded,color:  mainColor,),
                SizedBox(width: 5,),
                Text(" ${lang?.translate('Chosen credential must not be expired.')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black),),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded,color:  mainColor,),
                SizedBox(width: 5,),
                Flexible(child: Text(" ${lang?.translate('Document should be good condition and clearly visible.')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black),)),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_rounded,color:  mainColor,),
                SizedBox(width: 5,),
                Flexible(child: Text("${lang?.translate('Make sure the document includes a picture of your face.')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400,color: Colors.black),)),
              ],
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                nextScreen(context, UploadDoc(color: mainColor,title: "Driving License",image: "assets/image/licence.png",));

              },
              child: Container(
                height: 55,
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                    color: mainColor
                    // gradient: LinearGradient(colors: [
                    //   primary,
                    //   primary2,
                    // ])
                ),
                child: Text("${lang?.translate('Take A Picture')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
              ),
            ),
            SizedBox(height: 20,),
          ],),
        ),
      ),
    );
  }
}
