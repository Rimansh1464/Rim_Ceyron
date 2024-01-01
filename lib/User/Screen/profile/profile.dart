import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../Agent/Screen/change_password.dart';
import '../../../Agent/Screen/change_pin.dart';
import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/getx_controller.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../utils/langauges_page.dart';
import '../../auth/u_login.dart';
import '../change_currency.dart';
import '../edit_profile.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Color blue = const Color(0XFF093EFE);
  Color blueold = const Color(0XFF3A66FD);

  GetController getController = Get.put(GetController());
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getController.checkCountry(context);

}
  Future<void> refresh(context) async {
    try {
      await Future.delayed(Duration(seconds: 1));
    } catch (error) {
      // Handle any errors that occur during data fetching
    }
  }
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AuthProvider sp = Provider.of<AuthProvider>(context);


    List<String>? nameParts = authProvider.userData?.name.split(" ");
    String? initials = nameParts?.map((part) => part[0]).join('');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var lang = LocalizationStuff.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("${lang?.translate("Profile")}",
          style: TextStyle(color: Colors.white,letterSpacing: 0.2),
        ),
        automaticallyImplyLeading: false,

        actions: [
          IconButton(onPressed: (){
            // Navigator.push(context, MaterialPageRoute(
            //     builder: (_)=> Update_Page(
            //       first: 'Sahil',last: 'Patel',
            //       busy: 'Graphic Designer',mob: '9632587410',
            //       email: 'sahil123@gmail.com',gender: 'Male',
            //       add: 'Suzy Queue 4455 Landing Lange, APT 4 Louisville, KY 40018-1234',
            //     ))
            // );
            nextScreen(context, UEditAccountData(),);
          },
              icon: const Icon(Icons.edit,color: Colors.white)),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'changepassword':
                  nextScreen(context,  const ChangePassword());
                  break;
                case 'changetransactionpin':
                  nextScreen(context, const ChangePin());
                  break;
                case 'logout':
                  sp.signOut(context).then((value) => Navigator.pushNamed(context, 'UserLogin'));
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'changepassword',
                  child: Text('${lang?.translate('Change Password')}'),
                ),
                PopupMenuItem<String>(
                  value: 'changetransactionpin',
                  child: Text('${lang?.translate('Change Transaction Pin')}'),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('${lang?.translate('Logout')}'),
                ),
              ];
            },
          ),
          SizedBox(width:5),
          SizedBox(width:5),
        ],
        elevation: 0,
        backgroundColor: primary,
      ),
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: RefreshIndicator(
          onRefresh: () {
            getController.checkCountry(context);

            setState(() {});
            return refresh(context);
            setState(() {});
          },
          child: ListView(
            children: [
              Column(
                children: [
                  Container(

                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height:15),
                        Container(
                          height: 70,
                          width: 70,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child:  Text("$initials",
                            style: TextStyle(fontWeight: FontWeight.w600,fontSize: 26,color: Colors.black),
                          ),
                        ),
                        SizedBox(height:15),
                         Text("${authProvider.userData?.name}",
                          style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.white),
                        ),
                        SizedBox(height:5),
                         Text("${authProvider.userData?.usersId}",
                          style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white70),
                        ),
                        SizedBox(height:15),

                      ],
                    ),
                  ),
                  SizedBox(height:5),
                  Container(
                    padding: const EdgeInsets.all(1),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width:5),
                            const Icon(Icons.call,color: Colors.green,size: 28,),
                            SizedBox(width:20),
                            Column (
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("${lang?.translate('Mobile')}",
                                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                                ),
                                SizedBox(height:3),
                                 Text("${authProvider.userData?.phoneNumber}",
                                  style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        Row(
                          children: [
                            SizedBox(width:5),
                            const Icon(Icons.email,color: Colors.blue,size: 28,),
                            SizedBox(width:20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Text("${lang?.translate('Email')}",
                                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                                ),
                                SizedBox(height:3),
                                 Text("${authProvider.userData?.email}",
                                  style: TextStyle(fontSize: 17,color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height:10),
                        Row(
                          children: [
                            SizedBox(width:5),
                            Icon(Icons.account_balance_wallet,color: blue,size: 28,),
                            SizedBox(width:20),
                            Obx(() => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${lang?.translate('Balance')}",
                                  style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                                ),
                                SizedBox(height:3),
                                if(getController.isCountry.value)...[
                                  Text(getController.isUserAmount.value?"\$ ${authProvider.userData?.balance}":"*****",
                                    style: TextStyle(fontSize: 17,color: Colors.black),

                                  ),
                                ]else...[
                                  Obx(() =>Text(getController.isUserAmount.value?"${(double.parse(authProvider.userData!.balance) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}":"*****",
                                    style: TextStyle(fontSize: 17,color: Colors.black),
                                  ),),
                                  Text(getController.isUserAmount.value?"\$ ${authProvider.userData?.balance} ":"*****",
                                    style: TextStyle(fontSize: 13,color: Colors.black45),

                                  ),
                                ]
                              ],
                            ),)

                          ],
                        ),
                        SizedBox(height:12),
                        Row(
                          children: [
                            SizedBox(width:5),
                            const Icon(Icons.location_pin,color: Color(0XFFf7641e),size: 28,),
                            SizedBox(width:20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text("${lang?.translate('Country')}",
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                                  ),
                                  SizedBox(height:3),
                                  Text(
                                    "${authProvider.userData?.country}",
                                    style: TextStyle(fontSize: 17, color: Colors.black,letterSpacing: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              nextScreen(context, UEditAccountData(),);
                            },
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    // Color(0XFF02C9C4),
                                    // Color(0XFF09BDE8),
                                    Color(0XFF3757fa),
                                    Color(0XFF21b2e9),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(width: 15),
                                  const Icon(Icons.edit, color: Colors.white),
                                   Expanded(
                                    child: Center(
                                      child: Text(
                                        "${lang?.translate('Edit Profile')}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child:InkWell(
                          onTap: (){
                            nextScreen(context, ChangePassword());
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  // Color(0XFF7B10EA),
                                  // Color(0XFF9C4CFD),
                                  Color(0XFF3757fa),
                                  Color(0XFF21b2e9),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width:10),
                                const Icon(Icons.lock, color: Colors.white,size: 20,),
                                 Expanded(
                                    child: Center(
                                      child: Text(
                                        "${lang?.translate('Change Password')}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),)
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                        nextScreen(context, ChangeCurrency());
                     },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: const Color(0XFFDF0000),
                        gradient:  LinearGradient(
                          colors: [
                            primary,
                            primary2
                            // Color(0XFFDF0000),
                            // Color(0XFFFAB0AF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width:20),
                          const Icon(Icons.currency_exchange,color: Colors.white,size: 28,),
                           Expanded(
                            child: Center(
                              child: Text(
                                "${lang?.translate('Change default currency')}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  InkWell(
                    onTap: (){
                      nextScreen(context, LanguagePage());
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            // Color(0XFF7B10EA),
                            // Color(0XFF9C4CFD),
                            Color(0XFF3757fa),
                            Color(0XFF21b2e9),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child:  Row(
                        children: [
                          SizedBox(width:15),
                          Icon(Icons.translate, color: Colors.white,size: 30,),
                          Expanded(
                              child: Center(
                                child: Text(
                                  "${lang?.translate("Change Language")}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                       sp.signOut(context).then((value) => getController.getLocale()).then((value) => Navigator.pushNamed(context, 'UserLogin'));

                      // sp.signOut(context).then((value) => Navigator.pushNamed(context, 'UserLogin')).then((value) => getController.changeLanguage(context));

                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: const Color(0XFFDF0000),
                        gradient:  LinearGradient(
                          colors: [
                            primary,
                            primary2
                            // Color(0XFFDF0000),
                            // Color(0XFFFAB0AF),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width:20),
                          const Icon(Icons.logout,color: Colors.white,size: 28,),
                           Expanded(
                            child: Center(
                              child: Text(
                                "${lang?.translate('Log out')}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
