import 'dart:async';

import 'package:ceyron_app/Agent/Home/home_page.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/getx_controller.dart';
import '../../Api/no_internet.dart';
import '../../User/auth/u_login.dart';
import '../../User/auth/user_create_pin.dart';
import '../../utils/next_screen.dart';
import '../../utils/notiftion_helper.dart';
import '../auth/Login.dart';
import '../../utils/colors.dart';
import '../auth/create_pin.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  Future<void> requestManageExternalStoragePermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      status = await Permission.manageExternalStorage.request();
  }}
  Future<bool> storagePermission() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;

    if(androidInfo.version.sdkInt<= 29){
      if(await Permission.storage.status.isDenied){
        await Permission.storage.request();
        return await Permission.storage.isGranted;
      }
      return await Permission.storage.isGranted;
    }else if(androidInfo.version.sdkInt>= 33){
      if(await Permission.manageExternalStorage.isDenied){
        await Permission.manageExternalStorage.request();
        return await Permission.manageExternalStorage.isGranted;
      }
      return await Permission.manageExternalStorage.isGranted;
    }else{
      if(await Permission.storage.isDenied || await Permission.manageExternalStorage.isDenied){
        await Permission.storage.request();
        await Permission.manageExternalStorage.request();
        return await Permission.manageExternalStorage.isGranted && await Permission.storage.isGranted;
      }
      return await Permission.manageExternalStorage.isGranted && await Permission.storage.isGranted;
    }
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    init(context);
    requestManageExternalStoragePermission();
    MyConnectivity.instance.initialise();
    MyConnectivity.instance.myStream.listen((onData) {
      if (MyConnectivity.instance.isIssue(onData)) {
        if (MyConnectivity.instance.isShow == false) {
          MyConnectivity.instance.isShow = true;
          showDialogNotInternet(context).then((onValue) {
            MyConnectivity.instance.isShow = false;
          });
        }
      } else {
        if (MyConnectivity.instance.isShow == true) {
          Navigator.of(context).pop();
          MyConnectivity.instance.isShow = false;
        }
      }
    });
    final sp = context.read<AuthProvider>();
    sp.getUserData();
    sp.checkSignInUser().then((value) =>
        Timer(Duration(seconds: 4), () {
      if(sp.isSignedIn){
        if(sp.userData!.role== 'User'){
          sp.getUserData().then((value) => sp.updateData(context)).then((value) => Navigator.pushNamed(context, 'userBottomBarApp'));
          //nextScreen(context, UserCreatePin(result: 'check',));
           
        }
        else if(sp.userData!.role == 'Agent'){
          sp.getUserData().then((value) => sp.updateData(context)).then((value) =>  Navigator.pushNamed(context, 'MyBottomBarApp'));
          //nextScreen(context, CreatePin(result: 'check',));
         
        } else{
          nextScreen(context, const UserLogin());
        }
      }
      else{
        nextScreen(context, const UserLogin());
      }
      // sp.isSignIn == false
      //     ? nextScreen(context, const UserLogin())
      //     :
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: double.infinity,
          width:  double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              primary,
              primary2,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 340,
              ),
              Image.asset(
                'assets/icon/AppLogo.png',
                scale: 3,
              ),
              const Spacer(),
              const SpinKitFadingCircle(color: Colors.white, size: 30),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        )
    );
  }
}
