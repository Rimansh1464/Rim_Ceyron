import 'package:ceyron_app/Api/Model/user_model.dart';
import 'package:ceyron_app/User/Screen/send_money/u_send_money.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Agent/Screen/Kyc Flow/choose_doc.dart';
import '../../Agent/Screen/change_password.dart';
import '../../Agent/Screen/change_pin.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/getx_controller.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/Controller/transaction_provider.dart';
import '../../utils/widgets.dart';
import 'chat/chat_page.dart';
import 'edit_profile.dart';

class ShowAgentDetails extends StatefulWidget {
  UserData Data;

  ShowAgentDetails({key,required this.Data});

  @override
  State<ShowAgentDetails> createState() => _ShowAgentDetailsState();
}

class _ShowAgentDetailsState extends State<ShowAgentDetails> {
  Color blue = const Color(0XFF093EFE);
  Color blueold = const Color(0XFF3A66FD);

  GetController getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    AuthProvider sp = Provider.of<AuthProvider>(context);

    var lang = LocalizationStuff.of(context);

    List<String>? nameParts = widget.Data?.name.split(" ");
    String? initials = nameParts?.map((part) => part[0]).join('');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:  Text("${lang?.translate("Agent")}",
          style: TextStyle(color: Colors.white,letterSpacing: 0.2),
        ),
        automaticallyImplyLeading: true,

        actions: [],
        elevation: 0,
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Column(
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
                  Text("${widget.Data?.name}",
                    style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25,color: Colors.white),
                  ),
                  SizedBox(height:5),
                  Text("${widget.Data?.usersId}",
                    style: TextStyle(fontWeight: FontWeight.w400,fontSize: 18,color: Colors.white70),
                  ),
                  SizedBox(height:15),

                ],
              ),
            ),
            SizedBox(height:10),
            Container(
              padding: const EdgeInsets.all(1),
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width:5),
                      const Icon(Icons.business_sharp,color: Colors.redAccent,size: 28,),
                      SizedBox(width:20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("${lang?.translate("Business Name")}",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                            ),
                            SizedBox(height:3),
                            Text(
                              "${widget.Data.businessName}",
                              style: TextStyle(fontSize: 17, color: Colors.black,letterSpacing: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:13),
                  Row(
                    children: [
                      SizedBox(width:5),
                      const Icon(Icons.business_center_sharp,color: Colors.deepPurpleAccent      ,size: 28,),
                      SizedBox(width:20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("${lang?.translate("Branch Name")}",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                            ),
                            SizedBox(height:3),
                            Text(
                              "${widget.Data.branchName}",
                              style: TextStyle(fontSize: 17, color: Colors.black,letterSpacing: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:13),
                  Row(
                    children: [
                      SizedBox(width:5),
                      const Icon(Icons.call,color: Colors.green,size: 28,),
                      SizedBox(width:20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("${lang?.translate("Mobile")}",
                            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                          ),
                          SizedBox(height:3),
                          Text("${widget.Data?.phoneNumber}",
                            style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17,color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height:13),
                  Row(
                    children: [
                      SizedBox(width:5),
                      const Icon(Icons.email,color: Colors.blue,size: 28,),
                      SizedBox(width:20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text("${lang?.translate("Email")}",
                            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                          ),
                          SizedBox(height:3),
                          Text("${widget.Data?.email}",
                            style: TextStyle(fontSize: 17,color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height:13),
                  Row(
                    children: [
                      SizedBox(width:5),
                      Icon(Icons.location_city,color: blue,size: 28,),
                      SizedBox(width:20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("${lang?.translate("Address")}",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                            ),
                            SizedBox(height:3),
                            Wrap(
                              children: [
                                Text("${widget.Data?.address}",
                                  style: TextStyle(fontSize: 17,color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:13),
                  Row(
                    children: [
                      SizedBox(width:5),
                      Icon(Icons.map_outlined,color: Colors.green,size: 28,),
                      SizedBox(width:20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${lang?.translate("City")}",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                            ),
                            SizedBox(height:3),
                            Wrap(
                              children: [
                                Text("${widget.Data?.city}",
                                  style: TextStyle(fontSize: 17,color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.maps_home_work_rounded,color: Colors.deepPurpleAccent,size: 28,),
                      SizedBox(width:20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${lang?.translate("State")}",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                            ),
                            SizedBox(height:3),
                            Wrap(
                              children: [
                                Text("${widget.Data?.state}",
                                  style: TextStyle(fontSize: 17,color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:13),
                  Row(
                    children: [
                      SizedBox(width:5),
                      const Icon(Icons.location_pin,color: Color(0XFFf7641e),size: 28,),
                      SizedBox(width:20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text("${lang?.translate("Country")}",
                              style: TextStyle(fontWeight: FontWeight.w400,fontSize: 15,color: Colors.black45),
                            ),
                            SizedBox(height:3),
                            Text(
                              "${widget.Data?.country}",
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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        launchURL();
                      },
                      child: Container(
                        height: 55,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.call, color: Colors.white),
                            Center(
                              child: Text(
                                "${lang?.translate("Call now")}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
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
                        final ts = context.read<TransactionProvider>();
                        final AuP = context.read<AuthProvider>();
                        adsLoader.show(context);
                        // ts.showTransactionFee(context);
                        sp.updateData(context).then((value) {
                          if(authProvider.userData!.kyc_status == "approved"){
                            adsLoader.close();
                            ts.getUserData(widget.Data.usersId, false,context).then((value) =>
                                AuP.updateData(context).then((value) => setState(() {
                                  if(ts.receiverData?.id != 0){
                                    // reviversData = convertToFuture(ts.receiverData!);
                                  }
                                }))).then((value) =>  nextScreen(context, USendMoney(),));
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
                        height: 55,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Icon(Icons.attach_money, color: Colors.white),
                            Center(
                              child: Text(
                                "${lang?.translate("Send Moneys")}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),)
                ],
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: (){
                nextScreen(context, ChatPage());
              },
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 20),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat, color: Colors.white),
                    SizedBox(width: 10,),
                    Center(
                      child: Text(
                        "${lang?.translate("Chat")}",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),

                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  Future<void> launchURL() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: widget.Data.phoneNumber,
    );
    await launchUrl(launchUri);
  }
  void launchURL1() async {
    final String phoneNumber = widget.Data.phoneNumber;
    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      final String url = 'tel:$phoneNumber';
      final Uri launchUri = Uri(
        scheme: 'tel',
        path: widget.Data.phoneNumber,
      );
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        print('Could not launch $launchUri');
        // Handle the error gracefully, e.g., show an error message to the user.
      }
    } else {
      print('Phone number is null or empty');
      // Handle the case where the phone number is missing.
    }
  }
}
