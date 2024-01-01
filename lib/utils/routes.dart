import 'package:ceyron_app/Agent/Screen/QR_Scan/QR_receive.dart';
import 'package:flutter/cupertino.dart';

import '../Agent/Home/home_page.dart';
import '../Agent/Home/setting.dart';
import '../Agent/Screen/QR_Scan/qr_code.dart';
import '../Agent/Screen/QR_Scan/send_money.dart';
import '../Agent/Screen/bottom_bar.dart';
import '../Agent/Home/transaction_history.dart';
import '../Agent/auth/Login.dart';
import '../Agent/auth/create_pin.dart';
import '../Agent/auth/otp_screen.dart';
import '../Agent/auth/reset_password.dart';
import '../Agent/splash/splash.dart';
import '../User/Home/User_home_page.dart';
import '../User/Screen/BottomBar/bottom_bar.dart';
import '../User/auth/u_login.dart';

Map<String, Widget Function(BuildContext)> routes = {
  //admin
  AppRoutes().homePage: (context) => const HomePage(),
  AppRoutes().BottomBar: (context) => MyBottomBarApp(visit: 0),
  AppRoutes().Splash: (context) => const SplashScreen(),
  AppRoutes().login: (context) => const Login(),
  // AppRoutes().ForgetPassword: (context) =>  ForgetPassword(),
  AppRoutes().OtpPage: (context) =>  OtpPage(email: "",),
  AppRoutes().ResetPassword: (context) =>  ResetPassword(email: "",role: "",),
  AppRoutes().CreatePin: (context) =>  CreatePin(),
  AppRoutes().TransactionHistory: (context) =>  TransactionHistory(arrow: true),
  AppRoutes().QrCode: (context) => const QrCode(),
  AppRoutes().QrReceive: (context) => const QrReceive(),
  AppRoutes().SendMoney: (context) => SendMoney(),
  // AppRoutes().EnterPassword: (context) => const EnterPassword(),
  AppRoutes().QRCodeScannerWidget: (context) =>  QRViewExample(),

  //user
  AppRoutes().UserLogin: (context) => const UserLogin(),
  AppRoutes().UserBottomBar: (context) => userBottomBarApp(visit: 0,),
  AppRoutes().UserHomePage: (context) => UserHomePage(),
  AppRoutes().AgentSetting: (context) => AgentSetting(),

};

class AppRoutes {
  // Agent
  String homePage = "/";
  String BottomBar = "MyBottomBarApp";
  String Splash = "Splash";
  String login = "login";

  // String ForgetPassword = "ForgetPassword";
  String OtpPage = "OtpPage";
  String ResetPassword = "ResetPassword";
  String CreatePin = "CreatePin";
  String AcceptedPage = "AcceptedPage";
  String RejectPage = "RejectPage";
  String RequestsPage = "RequestsPage";
  String TransactionHistory = "TransactionHistory";
  String CustomerDetails = "CustomerDetails";
  String QrCode = "QrCode";
  String QrReceive = "QrReceive";
  String SendMoney = "SendMoney";
  String EnterPassword = "EnterPassword";
  String ChatPage = "ChatPage";
  String QRCodeScannerWidget = "QRCodeScannerWidget";
  String AgentSetting = "AgentSetting";

  // User
  String UserLogin = "UserLogin";
  String UserBottomBar = "userBottomBarApp";
  String UserHomePage = "UserHomePage";
  String FindCard = "FindCard";
  String AddCard = "AddCard";
  String USetting = "USetting";
  String KycUpload = "KycUpload";
  String DocVerify = "DocVerify";
  String SendMoneyCard = "SendMoneyCard";
}

// '/': (context) =>  HomePage(),
// 'BottomBar': (context) =>  MyBottomBarApp(),
// 'Splash': (context) =>  SplashScreen(),
// 'login': (context) =>  Login(),
// 'ForgetPassword': (context) =>  ForgetPassword(),
// 'OtpPage': (context) =>  OtpPage(),
// 'ResetPassword': (context) =>  ResetPassword(),
// 'CreatePin': (context) =>  CreatePin(),
// 'AcceptedPage': (context) =>  AcceptedPage(),
// 'RejectPage': (context) =>  RejectPage(),
// 'RequestsPage': (context) =>  RequestsPage(),
// 'CustomerDetails': (context) =>  CustomerDetails(),
// 'QrCode': (context) =>  QrCode(),
// 'QrReceive': (context) =>  QrReceive(),
// 'SendMoney': (context) =>  SendMoney(),
// 'EnterPassword': (context) =>  EnterPassword(),
// 'ChatPage': (context) =>  ChatPage(),
// 'QRCodeScannerWidget': (context) =>  QRViewExample(),
