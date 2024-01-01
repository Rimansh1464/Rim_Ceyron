import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:ceyron_app/Agent/Home/transaction_history.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Api/Controller/local_stuff.dart';
import '../Home/agent_profile.dart';
import '../Home/setting.dart';
import '../auth/Login.dart';
import '../auth/forgot_passwors.dart';
import '../notification.dart';
import '../splash/splash.dart';

import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

import '../Home/home_page.dart';
import 'QR_Scan/qr_code.dart';

class MyBottomBarApp extends StatefulWidget {
  int visit;
  MyBottomBarApp({super.key,required this.visit});
  @override
  _MyBottomBarAppState createState() => _MyBottomBarAppState();
}

class _MyBottomBarAppState extends State<MyBottomBarApp> {




  Color color2 = Color(0xff3b49fc);
  Color bgColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    List<TabItem> items = [
      TabItem(
        icon: Icons.home,
        title: '${lang?.translate('Home')}',
      ),
      TabItem(
        icon: Icons.person,
        title: '${lang?.translate('My Account')}',
      ),
      TabItem(
        icon: Icons.qr_code,
        title: '${lang?.translate('QR Code')}',
      ),
      TabItem(
        icon: Icons.history,
        title: '${lang?.translate('History')}',
      ),
      TabItem(
        icon: Icons.settings,
        title: '${lang?.translate('Setting')}',
      ),
    ];
    return Scaffold(
      bottomNavigationBar: BottomBarCreative(
        items: items,
        backgroundColor: Colors.white,
        color: Colors.grey,
        colorSelected: primary,
        indexSelected: widget.visit,
        isFloating: true,
        titleStyle: TextStyle(fontWeight: FontWeight.w500),
        highlightStyle: const HighlightStyle(
            sizeLarge: true, isHexagon: true, elevation: 2),
        onTap: (int index) => setState(() {
          widget.visit = index;
        }),
      ),

      body: buildScreens()[widget.visit],
    );
  }

  // Define your list of screens here
  List<Widget> buildScreens() {
    return [
      HomePage(),
      agentProfile(),
      QrCode(),
      TransactionHistory(arrow: false),
      AgentSetting(),
    ];
  }
}
