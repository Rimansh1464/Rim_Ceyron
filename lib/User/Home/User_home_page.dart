// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/Agent/Screen/QR_Scan/send_money.dart';
import 'package:ceyron_app/Api/Controller/transaction_provider.dart';
import 'package:ceyron_app/Api/Model/transaction_model.dart';
import 'package:ceyron_app/User/Screen/other/add_bank_account.dart';
import 'package:ceyron_app/User/Screen/other/received_payment.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Agent/Screen/Kyc Flow/choose_doc.dart';
import '../../Agent/Screen/QR_Scan/QR_receive.dart';
import '../../Agent/Screen/QR_Scan/qr_code.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/getx_controller.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';
import '../Screen/other/add_money.dart';
import '../Screen/other/find_prepaid_card.dart';
import '../Screen/other/send_money_prepaidcard.dart';
import '../auth/user_create_pin.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  GetController getController = Get.put(GetController());

  Future getData() async {
    // final sp = context.read<AuthProvider>();
    // final ts = context.read<TransactionProvider>();
    final ts = Provider.of<TransactionProvider>(context, listen: false);
    final sp = Provider.of<AuthProvider>(context, listen: false);
    getController.checkCountry(context);
    ts.generateQRCode(context);
    sp.getUserData();
    sp.updateData(context);
    // ts.updateData();
    print("getController${getController.isCountry}");
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getData();
    });

}
  Future<void> refresh(context) async {
    try {
      getData();
      await Future.delayed(Duration(seconds: 1));
    } catch (error) {
      // Handle any errors that occur during data fetching
    }
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    List buttonLists = [
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
              children:  [
                Text(
                  '${lang?.translate('User ID')}: ${authProvider.userData?.usersId}',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                Text(
                  authProvider.userData!.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 18 ),
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
                //nextScreen(context, UserCreatePin());
                 nextScreen(context, KycChooseDoc());
              },
              child: Text(
                'KYC',
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
            return refresh(context);
            setState(() {});
          },
          child: Padding(
              padding: const EdgeInsets.only(
                top: 15,
                right: 15,
                left: 15,
              ),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                            getController.isUserAmount.value =! getController.isUserAmount.value;
                                            print("getController.isUserAmount.value ${getController.isUserAmount.value}");
                                          },
                                          child: getController.isUserAmount.value?Icon(Icons.visibility,color: Colors.white,):Icon(Icons.visibility_off,color: Colors.white,))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  getController.isCountry.value?
                                  Obx(()=> Column(children: [
                                    Text(
                                      getController.isUserAmount.value?"\$ ${authProvider.userData!.balance}":"******",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 24),
                                    ),
                                  ],),
                                  ):
                                  Column(children: [
                                    Obx(() => Text(
                                      getController.isUserAmount.value?"${(double.parse(authProvider.userData!.balance) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}":"******",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24),
                                    ),),
                                    Text(
                                      getController.isUserAmount.value?"\$ ${authProvider.userData!.balance}":"******",
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
                        height: 10,
                      ),
                      Text(
                        "${lang?.translate('Transfer Money')}",
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   children: [
                      //     InkWell(
                      //       onTap: (){
                      //       //  nextScreen(context,QRViewExample());
                      //         final sp = context.read<AuthProvider>();
                      //         adsLoader.show(context);
                      //         sp.updateData(context).then((value) {
                      //           if(authProvider.userData!.kyc_status == "approved"){
                      //             adsLoader.close();
                      //             Permission.camera.request().then((permissionStatus) {
                      //               if (permissionStatus.isGranted) {
                      //                 Navigator.pushNamed(context, 'QRCodeScannerWidget');
                      //               } else {
                      //               }});
                      //           }
                      //           else if(authProvider.userData!.kyc_status.isEmpty){
                      //             // Expanded(child: kycVerification(context));
                      //             adsLoader.close();
                      //             nextScreen(context, KycChooseDoc());
                      //           }
                      //           else if(authProvider.userData!.kyc_status == "pending"){
                      //             adsLoader.close();
                      //             nextScreen(context, KycChooseDoc());
                      //             // Expanded(child: paddingVerification(context));
                      //             //Expanded(child: cancelledVerification(context)),
                      //           }
                      //           else if(authProvider.userData!.kyc_status == "cancelled"){
                      //             adsLoader.close();
                      //             nextScreen(context, KycChooseDoc());
                      //             // Expanded(child: cancelledVerification(context));
                      //           }
                      //         });
                      //       },
                      //       child: Image.asset("assets/image/1.png",scale:2.80)),
                      //     InkWell(
                      //         onTap: (){
                      //           nextScreen(context, QrReceive());
                      //         },
                      //         child: Image.asset("assets/image/2.png",scale:2.80)),
                      //     InkWell(
                      //         onTap: (){
                      //          final ts = context.read<TransactionProvider>();
                      //          ts.receiverData = ts.receiverData?.clean();
                      //          final sp = context.read<AuthProvider>();
                      //           adsLoader.show(context);
                      //           sp.updateData(context).then((value) {
                      //             if(authProvider.userData!.kyc_status == "approved"){
                      //               adsLoader.close();
                      //               nextScreen(context, SendUsingId());
                      //             }
                      //             else if(authProvider.userData!.kyc_status.isEmpty){
                      //               // Expanded(child: kycVerification(context));
                      //               adsLoader.close();
                      //               nextScreen(context, KycChooseDoc());
                      //             }
                      //             else if(authProvider.userData!.kyc_status == "pending"){
                      //               adsLoader.close();
                      //               nextScreen(context, KycChooseDoc());
                      //               // Expanded(child: paddingVerification(context));
                      //               //Expanded(child: cancelledVerification(context)),
                      //             }
                      //             else if(authProvider.userData!.kyc_status == "cancelled"){
                      //               adsLoader.close();
                      //               nextScreen(context, KycChooseDoc());
                      //               // Expanded(child: cancelledVerification(context));
                      //             }
                      //           });
                      //           },
                      //         child: Image.asset("assets/image/3.png",scale:2.80)),
                      // ],),
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
                                      '${buttonLists[0]['image']}',
                                      scale: 14,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${buttonLists[0]['request']}",
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
                                      '${buttonLists[1]['image']}',
                                      scale: 14,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${buttonLists[1]['request']}",
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
                                      '${buttonLists[2]['image']}',
                                      scale: 14,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${buttonLists[2]['request']}",
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

                      // Text(
                      //   "Quick Links",
                      //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   child: GridView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //         crossAxisCount: 3,
                      //         crossAxisSpacing: 10,
                      //         mainAxisSpacing: 10,
                      //         childAspectRatio: 1),
                      //     itemCount: 6,
                      //     padding: EdgeInsets.zero,
                      //     itemBuilder: (context, index) => InkWell(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => buttonList[index]['ontap'],
                      //             ));
                      //       },
                      //       child: Container(
                      //         width: double.infinity,
                      //         padding: EdgeInsets.all(10),
                      //         alignment: Alignment.center,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20),
                      //             color: Color(int.parse(buttonList[index]['color']))
                      //             //color: Color(0xff9edaff),
                      //             // color: Color(0xfffdac92),
                      //             // color: Color(0xffffe4f2),
                      //             // color: Color(0xffede4ff),
                      //             ),
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Image.asset(
                      //               '${buttonList[index]['image']}',
                      //               scale: 14,
                      //             ),
                      //             SizedBox(
                      //               height: 10,
                      //             ),
                      //             Text(
                      //               "${buttonList[index]['request']}",
                      //               textAlign: TextAlign.center,
                      //               style: TextStyle(
                      //                   fontSize: 13, fontWeight: FontWeight.w500),
                      //             )
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   "Pay Utility Bills",
                      //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // SizedBox(
                      //   height: 100,
                      //   child: ListView.builder(
                      //     itemCount: 4,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) => Container(
                      //       height: 100,
                      //       width: 75,
                      //       margin: EdgeInsets.only(right: 10),
                      //       padding: EdgeInsets.all(5),
                      //       alignment: Alignment.center,
                      //       decoration: BoxDecoration(
                      //           border: Border.all(color: primary.withOpacity(0.5)),
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: primary2.withOpacity(0.1)),
                      //       child: Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           Image.asset(PayBillList[index]["icon"], scale: 15),
                      //           SizedBox(
                      //             height: 6,
                      //           ),
                      //           Flexible(
                      //               child: Text(
                      //             PayBillList[index]["title"],
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //                 fontSize: 12, fontWeight: FontWeight.w500),
                      //           )),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  List buttonList = [
    {
      "title": "Send Money",
      "request": "Send\nMoney",
      "color": "0xff9edaff",
      "image": "assets/icon/dollar.png",
      "ontap": SendMoneyCard(),
    },
    {
      "title": "Add Money to Wallet",
      "request": "Add\nMoney",
      "color": "0xffffe6d4",
      "image": "assets/icon/credit-card (1).png",
      "ontap": Add_Money("Add Money to Wallet"),
    },
    {
      "title": "Received Payments",
      "request": "Receive Payment",
      "color": "0xffffe4f2",
      "image": "assets/icon/receive-money.png",
      "ontap": Received_Payments(),
    },
    {
      "title": "Add Bank Account",
      "request": "Add Bank Account",
      "color": "0xffede4ff",
      "image": "assets/icon/bank-building.png",
      "ontap": Add_Bank_Account(),
    },
    {
      "title": "Add Card",
      "request": "Add\nCard",
      "color": "0xffFFD1DA",
      "image": "assets/icon/credit-card.png",
      "ontap": FindCard(),
    },
    {
      "title": "Add Prepaid Card",
      "request": "Add Prepaid Card",
      "color": "0xffede4ff",
      "image": "assets/icon/payment-method.png",
      "ontap": FindCard(),
    },
  ];
  List PayBillList = [
    {
      "icon": "assets/icon/ic_phone.png",
      "title": "Mobile Recharge",
    },
    {
      "icon": "assets/icon/ic_electric.png",
      "title": "Electricity Bill",
    },
    {
      "icon": "assets/icon/ic_gas.png",
      "title": "Gas\nBill",
    },
    {
      "icon": "assets/icon/ic_water.png",
      "title": "Water\nBill",
    },
  ];
}
