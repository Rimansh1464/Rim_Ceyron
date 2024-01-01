// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/Agent/Screen/Kyc%20Flow/passport_verifiction.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import 'details_fill.dart';
import 'driving_verifiction.dart';
import 'national_card_verifction.dart';

class KycChooseDoc extends StatefulWidget {
  const KycChooseDoc({super.key});

  @override
  State<KycChooseDoc> createState() => _KycChooseDocState();
}

class _KycChooseDocState extends State<KycChooseDoc> {
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final sp = context.read<AuthProvider>();
      sp.updateData(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    print("kyc_status====${authProvider.userData!.kyc_status}");
    return Scaffold(
      body:Column(
         children: [
           if(authProvider.userData!.kyc_status.isEmpty)
              Expanded(child: kycVerification(context)),
           if(authProvider.userData!.kyc_status == "pending")
             Expanded(child: paddingVerification(context)),
             //Expanded(child: cancelledVerification(context)),
           if(authProvider.userData!.kyc_status == "approved")
             Expanded(child: approvedVerification(context)),
           if(authProvider.userData!.kyc_status == "cancelled")
             Expanded(child: cancelledVerification(context)),
            // Expanded(child: kycVerification(context)),

         ],
       ),
    );
  }
}


Widget kycVerification(context) {
  var lang = LocalizationStuff.of(context);
  return Column(children: [
    SizedBox(height: 45,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${lang?.translate('KYC Verification')}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: primary),),
      ],
    ),
    SizedBox(height: 30,),
    Image.asset('assets/image/chooseDoc.png'),
    SizedBox(height: 30,),
    Text("${lang?.translate("First, Let's get to know you")}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 33),),
    SizedBox(height: 60,),
    Text("${lang?.translate('Please prepare one of the following document')}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w500,fontSize: 15),),
    SizedBox(height: 4,),
    SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Text(
            "${lang?.translate('National Card')}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          VerticalDivider(
            width: 10,
            color: Colors.black,
            thickness: 2,
          ),
          Text(
            "${lang?.translate('Passport')}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          VerticalDivider(
            width: 10,
            color: Colors.black,
            thickness: 2,
          ),
          Text(
            "${lang?.translate('Driving License')}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ),
    Spacer(),
    InkWell(
      onTap: (){
        // _showBottomSheet(context);
        nextScreen(context, DetailsFill());
      },
      child: Container(
        height: 55,
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              primary,
              primary2,
            ])
        ),
        child: Text("${lang?.translate('Get Start')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
      ),
    ),
    SizedBox(height: 40,),

  ],);
}
Widget approvedVerification(context) {
  var lang = LocalizationStuff.of(context);
  return Column(children: [
    SizedBox(height: 45,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${lang?.translate('KYC Verification Approved')}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: primary),),
      ],
    ),
    SizedBox(height: 100,),
    Image.asset('assets/image/ic_success.png',scale: 2),
    SizedBox(height: 100,),
    Text("${lang?.translate('KYC Verification Approved')}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
    SizedBox(height: 10,),

    Spacer(),
    InkWell(
      onTap: (){
        // _showBottomSheet(context);
        Navigator.pop(context);
      },
      child: Container(
        height: 55,
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              primary,
              primary2,
            ])
        ),
        child: Text("${lang?.translate('Go Back')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
      ),
    ),
    SizedBox(height: 40,),

  ],);
}
Widget paddingVerification(context) {
  var lang = LocalizationStuff.of(context);
  return Column(children: [
    SizedBox(height: 45,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${lang?.translate('KYC Verification Pending')}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: primary),),
      ],
    ),
    SizedBox(height: 100,),
    Image.asset('assets/image/padding.png',scale: 9 ),
    SizedBox(height: 100,),
    Text("${lang?.translate('KYC Verification Pending')}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
    SizedBox(height: 8,),
    Text("${lang?.translate('Verification should take about 48 hours.')}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400,fontSize: 14),),
    Text("${lang?.translate('We will let you know about the result')}",textAlign: TextAlign.center,style: TextStyle(color: Colors.black54,fontWeight: FontWeight.w400,fontSize: 14),),
    SizedBox(height: 4,),

    Spacer(),
    InkWell(
      onTap: (){
        // _showBottomSheet(context);
        Navigator.pop(context);
      },
      child: Container(
        height: 55,
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(colors: [
              primary,
              primary2,
            ])
        ),
        child: Text("${lang?.translate('Go Back')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
      ),
    ),
    SizedBox(height: 40,),

  ],);
}
Widget cancelledVerification(context) {
  AuthProvider authProvider = Provider.of<AuthProvider>(context);
  var lang = LocalizationStuff.of(context);

  return Column(children: [
    SizedBox(height: 45,),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${lang?.translate('KYC Verification Cancelled')}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500,color: primary),),
      ],
    ),
    SizedBox(height: 100,),
    Image.asset('assets/image/padding.png',scale: 9),
    SizedBox(height: 100,),
    Text("${lang?.translate('KYC Verification Cancelled')}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
    SizedBox(height: 8,),
    Container(
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 7),
      margin: EdgeInsets.symmetric(horizontal: 40,vertical: 7),
       decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.red.withOpacity(0.5)),
        child: Column(
          children: [
            Text("${lang?.translate('Reason!')}",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13),),
            SizedBox(height: 5,),
            Text(authProvider.userData!.kycReason,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15),),
          ],
    )),
    Spacer(),
    Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: (){
              // _showBottomSheet(context);
              Navigator.pop(context);
            },
            child: Container(
              height: 55,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    primary,
                    primary2,
                  ])
              ),
              child: Text("${lang?.translate('Go Back')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: (){
              nextScreen(context, DetailsFill());
            },
            child: Container(
              height: 55,
              width: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    primary,
                    primary2,
                  ])
              ),
              child: Text("${lang?.translate('Try again')}",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),),
            ),
          ),
        ),
      ],
    ),
    SizedBox(height: 40,),

  ],);
}
