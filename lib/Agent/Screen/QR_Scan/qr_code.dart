import 'dart:developer';
import 'dart:io';

import 'package:ceyron_app/Agent/Screen/QR_Scan/QR_receive.dart';
import 'package:ceyron_app/Agent/Screen/QR_Scan/send_money.dart';
import 'package:ceyron_app/Agent/Screen/QR_Scan/success_page.dart';
import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Controller/transaction_provider.dart';
import '../../../Api/Model/reciver_data_model.dart';
import '../../../User/Screen/send_money/u_send_money.dart';
import '../../../utils/widgets.dart';
import '../../AppBar/appbar.dart';
import '../Kyc Flow/choose_doc.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ts = context.read<TransactionProvider>();
    ts.generateQRCode(context);
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar: CustomAppBar2(
          title: "${lang?.translate('QR Code Scan to Pay')}",
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary)),
                child: Text(
                  "${lang?.translate('pay and receive')}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18, color: primary),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Lottie.asset(
                'assets/lottie/scan.json',
              ),
              InkWell(
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
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primary,
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                    child: Text(
                      "${lang?.translate('Scan QR Code')}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ),
              SizedBox(height: 10,),
              InkWell(
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
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primary,
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                    child: Text(
                      "${lang?.translate('Send money using id')}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ),
              SizedBox(height: 100,),

              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrReceive(),
                      ));
                  // nextScreen(context, SuccessPage());
                },
                child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primary,
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                    child: Text(
                      "${lang?.translate('Receive')}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}
class _QRViewExampleState extends State<QRViewExample> {
  String? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 100.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: primary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  bool shouldNavigate = true; // Add this flag

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      // If navigation is already triggered, return without doing anything
      if (!shouldNavigate) {
        return;
      }

      setState(() {
        result = scanData.code;
      });

      if (result != null && result!.isNotEmpty) {
        print("result ============= $result");
        if (result!.length == 10) {
          if (int.tryParse(result!) != null) { // Check if it's a valid integer
            shouldNavigate = false;
            final ts = context.read<TransactionProvider>();
            final Aut = context.read<AuthProvider>();

            controller.stopCamera();
            // ts.showTransactionFee(context);
            ts.getUserData(result!, true, context).then((_) {
              shouldNavigate = true;

              // Resume the camera after navigation
            }).then((value) {
              if(Aut.userData?.usersId == ts.receiverData?.usersId){}else{
                Aut.updateData(context);
              }
            } );
          } else {
            controller.stopCamera();
            showSnackbarError(context, "Invalid QR Code");
            await Future.delayed(Duration(seconds: 1));
            Navigator.pop(context);
          }
        } else {
          controller.stopCamera();
          await Future.delayed(Duration(seconds: 1));
          showSnackbarError(context, "Invalid QR Code");
          Navigator.pop(context);
        }
      }

    });
  }




  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

// send money to user id
class SendUsingId extends StatefulWidget {
  const SendUsingId({super.key});

  @override
  State<SendUsingId> createState() => _SendUsingIdState();
}
class _SendUsingIdState extends State<SendUsingId> {
  TextEditingController IdContaroller = TextEditingController();
  Future<ReciverData>?  reviversData;
  Future<ReciverData> convertToFuture(ReciverData? receiverData) async {
    await Future.delayed(Duration(seconds: 1));
    adsLoader.close();
    return receiverData!;
  }
  Future<void> fetchData() async {
    final ts = context.read<TransactionProvider>();
     reviversData = convertToFuture(ts.receiverData!);
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ts = context.read<TransactionProvider>();
    final AuP = context.read<AuthProvider>();
    // AuP.userData?.role == 'Agent'?IdContaroller.text = "5802063816" :IdContaroller.text = "4629516662";
    //fetchData();
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);

    final ts = context.read<TransactionProvider>();
    final AuP = context.read<AuthProvider>();
    return Scaffold(
      appBar: CustomAppBar(
        title: "${lang?.translate("Send Money Using Id")}",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,boxShadow: [BoxShadow(blurRadius: 10,color: Colors.grey.shade200)]),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("${lang?.translate("Agent ID or User ID")}",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                 SizedBox(height: 15,),
                 Container(
                   height:  55,
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(8),
                     color:Colors.grey.shade200,
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
                     child: Row(
                       children: [
                         SizedBox(
                           width:16,
                         ),
                         Expanded(
                           child: TextFormField(
                              controller: IdContaroller,
                             style: TextStyle(
                               fontSize: 16.0,
                               color: const Color(0xFF151624),
                             ),
                             inputFormatters:  [
                               LengthLimitingTextInputFormatter(10),
                               FilteringTextInputFormatter.digitsOnly,
                             ],
                             validator: (input) {
                               if (input == null || input.isEmpty) {
                                 return 'Please Enter ZipCod';
                               }
                             },
                             keyboardType: TextInputType.number,
                             cursorColor: const Color(0xFF151624),
                             decoration: InputDecoration(
                               hintText: "${lang?.translate("Enter agent id or user id")}",
                               hintStyle: TextStyle(
                                 fontSize: 16.0,
                                 color: const Color(0xFF151624).withOpacity(0.5),
                               ),
                               border: InputBorder.none,
                             ),
                           ),
                         ),
                       ],
                     ),
                   ),
                 ),
               ],),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              InkWell(
                onTap: (){
                  adsLoader.show(context);
                 // ts.showTransactionFee(context);
                  ts.getUserData(IdContaroller.text, false,context).then((value) {
                    if(AuP.userData?.usersId==ts.receiverData?.usersId){}else{
                      AuP.updateData(context).then((value) => setState(() {
                        if(ts.receiverData?.id != 0){
                          reviversData = convertToFuture(ts.receiverData!);
                        }
                      }));
                    }

                  }).then((value) {
                    Future.delayed(Duration(seconds: 5)).then((value) => Navigator.pop(context));

                  }
                      // Navigator.pop(context)
                  );

                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 13,vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary2, primary],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child:  Text(
                    '${lang?.translate("Search")}',
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
                SizedBox(width: 10,),
            ],),
            SizedBox(height: 20,),
            FutureBuilder(
              future: reviversData,
              builder: (context, snapshot) {
              ReciverData? Data = snapshot.data as ReciverData?;

              return Data != null?
              Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primary2, primary],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage('assets/image/user.png'),
                                ),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          "${Data?.name}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 3,),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      'ID: ${Data?.usersId}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Text(
                                      '${lang?.translate("Email")}: ${Data?.email}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        AuP.userData?.role=="Agent"?
                        nextScreen(context, SendMoney(),):
                        nextScreen(context, USendMoney(),)
                        ;},
                      child: Container(
                          width: 150,
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primary2, primary],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text("${lang?.translate("Confirm & Pay")}",style: TextStyle(color: Colors.white,fontSize: 16),)
                      ),
                    ),
                  ],
                ):
              Container();
              },)
          ],),
        ),
      ),
    );
  }
}

