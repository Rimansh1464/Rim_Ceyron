import 'package:ceyron_app/Api/Controller/getx_controller.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../Agent/Screen/change_password.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../User/Screen/edit_profile.dart';
import '../Screen/change_pin.dart';
import '../Screen/edit_account_data.dart';

class agentProfile extends StatefulWidget {
  const agentProfile({key});

  @override
  State<agentProfile> createState() => _agentProfileState();
}

class _agentProfileState extends State<agentProfile> {
  Color blue = const Color(0XFF093EFE);
  Color blueold = const Color(0XFF3A66FD);
  Future<void> refresh(context) async {
    try {
      await Future.delayed(Duration(seconds: 1));
    } catch (error) {
      // Handle any errors that occur during data fetching
    }
  }
  GetController getController = Get.put(GetController());
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AuthProvider sp = Provider.of<AuthProvider>(context);
    var lang = LocalizationStuff.of(context);


    List<String>? nameParts = authProvider.userData?.name.split(" ");
    String? initials = nameParts?.map((part) => part[0]).join('');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("${lang?.translate('My Account')}",
          style: TextStyle(color: Colors.white,letterSpacing: 0.2),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, EditAccountData(),);
          },
              icon: const Icon(Icons.edit,color: Colors.white)),
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle the selected menu item here
              switch (value) {
                case 'changepassword':
                  nextScreen(context, ChangePassword());
                  break;
                case 'changetransactionpin':
                  nextScreen(context, ChangePin());
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
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child:  Text("${initials}",
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(width:5),
                            const Icon(Icons.call,color: Colors.green,size: 28,),
                            SizedBox(width:20),
                            Column(
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
                        SizedBox(height:25),
                        Row(
                          children: [
                            SizedBox(width: 5),
                            const Icon(Icons.email, color: Colors.blue, size: 28),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text(
                                    "${lang?.translate('Email')}",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black45),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    "${authProvider.userData?.email}",
                                    style: TextStyle(fontSize: 17, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height:25),
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
                                  Text(getController.isAgentAmount.value?"\$ ${authProvider.userData?.balance}":"*****",
                                    style: TextStyle(fontSize: 17,color: Colors.black),

                                  ),
                                ]else...[
                                  Obx(() =>Text(getController.isAgentAmount.value?"${(double.parse(authProvider.userData!.balance) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}":"*****",
                                    style: TextStyle(fontSize: 17,color: Colors.black),
                                  ),),
                                  Text(getController.isAgentAmount.value?"\$ ${authProvider.userData?.balance} ":"*****",
                                    style: TextStyle(fontSize: 13,color: Colors.black45),

                                  ),
                                ]
                              ],
                            ),)

                          ],
                        ),
                        SizedBox(height:25),
                        Row(
                          children: [
                            SizedBox(width:5),
                             Icon(Icons.location_pin,color: Color(0XFFf7641e),size: 28,),
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
                        SizedBox(height:25),
                        Row(
                          children: [
                            SizedBox(width:5),
                            const Icon(Icons.business_sharp,color: Colors.redAccent,size: 28,),
                            SizedBox(width:20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                   Text("${lang?.translate('Business Name')}",
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                                  ),
                                  SizedBox(height:3),
                                  Text(
                                    "${authProvider.userData?.businessName}",
                                    style: TextStyle(fontSize: 17, color: Colors.black,letterSpacing: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:25),
                        Row(
                          children: [
                            SizedBox(width:5),
                            const Icon(Icons.business_center_sharp,color: Colors.deepPurpleAccent      ,size: 28,),
                            SizedBox(width:20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${lang?.translate('Branch Name')}",
                                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                                  ),
                                  SizedBox(height:3),
                                  Text(
                                    "${authProvider.userData?.branchName}",
                                    style: TextStyle(fontSize: 17, color: Colors.black,letterSpacing: 0.3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:35),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
