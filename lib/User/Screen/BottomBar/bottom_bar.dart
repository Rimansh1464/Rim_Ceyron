import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:ceyron_app/User/Screen/send_money/u_transaction_history.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Api/Controller/local_stuff.dart';
import '../../Home/User_home_page.dart';
import '../../Home/show_agent.dart';
import '../profile/profile.dart';

class userBottomBarApp extends StatefulWidget {
  int visit;
  userBottomBarApp({super.key,required this.visit});

  @override

  _userBottomBarAppState createState() => _userBottomBarAppState();
}

class _userBottomBarAppState extends State<userBottomBarApp> {



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
        icon: Icons.account_circle,
        title: '${lang?.translate('Agent')}',
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
        visitHighlight: 4,
        titleStyle: TextStyle(fontWeight: FontWeight.w500),
        highlightStyle: const HighlightStyle(
            sizeLarge: true, isHexagon: true, elevation: 2),
        onTap: (int index) => setState(() {
          widget.visit = index;
        }),
      ),
      body: buildScreens()[widget.visit], // Use the function to build your screens
    );
  }

  // Define your list of screens here
  List<Widget> buildScreens() {
    return [
      UserHomePage(),
      ShowAgent(),
      UTransactionHistory(arrow: true,),
      UserProfile(),
    ];
  }
}
