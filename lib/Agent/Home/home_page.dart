// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/getx_controller.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/Controller/transaction_provider.dart';
import '../../utils/colors.dart';
import '../../utils/notiftion_helper.dart';
import '../../utils/widgets.dart';
import '../Screen/Kyc Flow/choose_doc.dart';
import '../Screen/QR_Scan/QR_receive.dart';
import '../Screen/QR_Scan/qr_code.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSwitched = true;
  GetController getController = Get.put(GetController());
  Future getData() async {
    final sp = context.read<AuthProvider>();
    final ts = context.read<TransactionProvider>();
    // sp.upgradeCurrency();
    //getController.upgradeCurrency(sp.userData!.country,context);
    getController.checkCountry(context);
    ts.generateQRCode(context);
    sp.getUserData();
    //ts.updateData();
    sp.updateData(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {

      getData();
    });
  }

  Future<void> refreshh(context) async {
    try {
      getData();

      await Future.delayed(Duration(seconds: 1));
    } catch (error) {
      // Handle any errors that occur during data fetching
    }
  }
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    TransactionProvider transProvider = Provider.of<TransactionProvider>(context);
    var lang = LocalizationStuff.of(context);
    List buttonList = [
      {
        "title": "${lang?.translate("Send Money")}",
        "request": "${lang?.translate("Send Money")}",
        "color": "0xff9edaff",
        "image": "assets/image/qr-code.png",
        "ontap": ",",
      },
      {
        "title": "Add Money to Wallet",
        "request": "${lang?.translate("Received Money")}",
        "color": "0xffffe6d4",
        "image": "assets/image/recevie.png",
        "ontap": 'Add_Money("Add Money to Wallet")',
      },
      {
        "title": "Received Payments",
        "request": "${lang?.translate("Send via ID")}",
        "color": "0xffffe4f2",
        "image": "assets/image/card.png",
        "ontap": 'Received_Payments()',
      },];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/image/user.png'))),
            ),
            SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${lang?.translate('Agent ID')}: ${authProvider.userData?.usersId}',
                  style:
                  TextStyle(color: Colors.black, fontSize: 13),
                ),
                Text(
                  authProvider.userData!.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              'assets/icon/notifiction.png',
              scale: 20,
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                nextScreen(context, KycChooseDoc());
              },
              child: Text(
                '${lang?.translate('KYC')}',
                style:TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return refreshh(context);
          },
          child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 15,
                left: 15,
              ),
              child: ListView(
                children:[Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {

                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primary,
                          gradient: LinearGradient(
                            colors: [
                              primary,
                              primary2,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Obx(()=>
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${lang?.translate('Wallet')}',
                                      style: TextStyle(color: Colors.white, fontSize: 22),
                                    ),
                                    SizedBox(width: 10,),
                                    InkWell(
                                        onTap: (){
                                          getController.isAgentAmount.value =! getController.isAgentAmount.value;
                                          print("getController.isUserAmount.value ${getController.isAgentAmount.value}");
                                        },
                                        child: getController.isAgentAmount.value?Icon(Icons.visibility,color: Colors.white,):Icon(Icons.visibility_off,color: Colors.white,))
                                  ],
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                getController.isCountry.value?
                                Obx(()=> Column(children: [
                                  Text(
                                    getController.isAgentAmount.value?"\$ ${authProvider.userData!.balance}":"******",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24),
                                  ),
                                ],),
                                ):
                                Column(children: [
                                  Obx(() => Text(
                                    getController.isAgentAmount.value?"${(double.parse(authProvider.userData!.balance) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}":"******",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 24),
                                  ),),
                                  Text(
                                    getController.isAgentAmount.value?"\$ ${authProvider.userData!.balance}":"******",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                  ),


                                ],)

                              ],
                            ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              final sp = context.read<AuthProvider>();
                              adsLoader.show(context);
                              sp.updateData(context).then((value) {
                                if(authProvider.userData!.kyc_status == "approved"){
                                  adsLoader.close();
                                  Permission.camera.request().then((permissionStatus) {
                                    if (permissionStatus.isGranted) {
                                      Navigator.pushNamed(context, 'QRCodeScannerWidget');
                                    } else {
                                    }});
                                }
                                else if(authProvider.userData!.kyc_status.isEmpty){
                                  // Expanded(child: kycVerification(context));
                                  adsLoader.close();
                                  nextScreen(context, KycChooseDoc());
                                }
                                else if(authProvider.userData!.kyc_status == "pending"){
                                  adsLoader.close();
                                  nextScreen(context, KycChooseDoc());
                                  // Expanded(child: paddingVerification(context));
                                  //Expanded(child: cancelledVerification(context)),
                                }
                                else if(authProvider.userData!.kyc_status == "cancelled"){
                                  adsLoader.close();
                                  nextScreen(context, KycChooseDoc());
                                  // Expanded(child: cancelledVerification(context));
                                }
                              });
                              },
                            child: Container(
                              width: 80,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(int.parse(buttonList[0]['color']))

                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    '${buttonList[0]['image']}',
                                    scale: 14,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${buttonList[0]['request']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              nextScreen(context, QrReceive());
                              },
                            child: Container(
                              width: 80,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(int.parse(buttonList[1]['color']))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    '${buttonList[1]['image']}',
                                    scale: 14,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${buttonList[1]['request']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final ts = context.read<TransactionProvider>();

                              ts.receiverData = ts.receiverData?.clean();

                              final sp = context.read<AuthProvider>();
                              adsLoader.show(context);
                              sp.updateData(context).then((value) {
                                if(authProvider.userData!.kyc_status == "approved"){
                                  adsLoader.close();
                                  nextScreen(context, SendUsingId());
                                }
                                else if(authProvider.userData!.kyc_status.isEmpty){
                                  // Expanded(child: kycVerification(context));
                                  adsLoader.close();
                                  nextScreen(context, KycChooseDoc());
                                }
                                else if(authProvider.userData!.kyc_status == "pending"){
                                  adsLoader.close();
                                  nextScreen(context, KycChooseDoc());
                                  // Expanded(child: paddingVerification(context));
                                  //Expanded(child: cancelledVerification(context)),
                                }
                                else if(authProvider.userData!.kyc_status == "cancelled"){
                                  adsLoader.close();
                                  nextScreen(context, KycChooseDoc());
                                  // Expanded(child: cancelledVerification(context));
                                }
                              });
                            },
                            child: Container(
                              width: 80,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(int.parse(buttonList[2]['color']))
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Image.asset(
                                    '${buttonList[2]['image']}',
                                    scale: 14,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${buttonList[2]['request']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),],
              )),
        ),
      ),

    );

  }



}
