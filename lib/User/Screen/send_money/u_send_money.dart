// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:ceyron_app/Agent/Screen/QR_Scan/enter_password.dart';
import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/utils/colors.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../../Api/Controller/transaction_provider.dart';
import '../../../../User/Home/User_home_page.dart';
import '../BottomBar/bottom_bar.dart';
import '../../../../utils/widgets.dart';
import '../../../Agent/Screen/bottom_bar.dart';
import '../../../Api/Controller/getx_controller.dart';
import '../../../Api/Controller/local_stuff.dart';

class USendMoney extends StatefulWidget {
   USendMoney({super.key});

  @override
  State<USendMoney> createState() => _USendMoneyState();
}

class _USendMoneyState extends State<USendMoney> {
  @override
  void dispose() {
    // inrFocusNode.dispose();
    // usdFocusNode.dispose();
    super.dispose();
  }


  TextEditingController usdController = TextEditingController();
  TextEditingController usdController1 = TextEditingController();
  TextEditingController inrController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  // bool idSendMoney = false;
  double initialAmount = 0;
 // double transferFees = 0;
  double adminCommission = 0.0;
  double adminCommissionPer = 0.0;
  double agentCommission = 0.0;
  double agentCommissionPer = 0.0;
  double customerAmount = 0;
  double totalAmount = 0;
  double margeCommission = 0;
  double sendfrind = 0;
  double totalAmountUsertoUser = 0;
  FocusNode inrFocusNode = FocusNode();
  FocusNode usdFocusNode = FocusNode();
  void _calculateTotalAmount() {

    double inputAmount = double.tryParse(usdController1.text) ?? 0;
    double inputAmount1 = double.tryParse(inrController.text) ?? 0;

    if (inputAmount == 0 || inputAmount1==0) {
      adminCommissionPer = 0;
      totalAmount = 0;
      customerAmount = 0;
      agentCommissionPer = 0;
      totalAmountUsertoUser = 0;
      usdController.clear();
      inrController.clear();
    } else {
      final adminCommissionPerr = (inputAmount * adminCommission) / 100;
      final agentCommissionPerr = (inputAmount * agentCommission) / 100;
      adminCommissionPer = double.parse(adminCommissionPerr.toStringAsFixed(6));
      agentCommissionPer = double.parse(agentCommissionPerr.toStringAsFixed(6));

      totalAmount = (inputAmount + agentCommissionPer);
      totalAmountUsertoUser = (inputAmount + adminCommissionPer);
      margeCommission = (adminCommissionPer + agentCommissionPer);
      customerAmount = (inputAmount + margeCommission);
    }

    // totalAmount = double.parse(totalAmount.toStringAsFixed(6));
    // customerAmount = double.parse(customerAmount.toStringAsFixed(6));
    getController.idUSendMoney.value =true;
    adsLoader.close();
  }
  void _calculateTotalAmount1() {
    double inputAmount = double.tryParse(usdController.text) ?? 0;
    double inputAmount1 = double.tryParse(inrController.text) ?? 0;

    if (inputAmount == 0) {
      adminCommissionPer = 0;
      totalAmount = 0;
      customerAmount = 0;
      agentCommissionPer = 0;
      totalAmountUsertoUser = 0;
    } else {
      final adminCommissionPerr = (inputAmount * adminCommission) / 100;
      final agentCommissionPerr = (inputAmount * agentCommission) / 100;
      adminCommissionPer = double.parse(adminCommissionPerr.toStringAsFixed(6));
      agentCommissionPer = double.parse(agentCommissionPerr.toStringAsFixed(6));

      totalAmount = (inputAmount + agentCommissionPer);
      totalAmountUsertoUser = (inputAmount + adminCommissionPer);
      margeCommission = (adminCommissionPer + agentCommissionPer);
      customerAmount = (inputAmount + margeCommission);
    }

    // totalAmount = double.parse(totalAmount.toStringAsFixed(6));
    // customerAmount = double.parse(customerAmount.toStringAsFixed(6));
    getController.idUSendMoney.value =true;
    adsLoader.close();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ts = context.read<TransactionProvider>();
   // transferFees = double.parse('${ts.TransactionsFee}');
    agentCommission = double.parse('${ts.agentCommission}');
    adminCommission = double.parse('${ts.adminCommission}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getController.idUSendMoney.value = false;
    });  }
  GetController getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    final ts = context.read<TransactionProvider>();
    final AuP = context.read<AuthProvider>();
    // GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _formKey = GlobalKey<FormState>();

    return WillPopScope(
      onWillPop: () async{
       AuP.userData?.role == 'Agent'?
       nextScreen(context, MyBottomBarApp(visit: 2,)):
        nextScreen(context, userBottomBarApp(visit: 0,));
        adsLoader.close();
        return true;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
              // height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary2, primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft:  Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/image/user.png'))),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${ts.receiverData!.name}",
                              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 21,color: Colors.white),
                            ),

                            Text(
                              'ID: ${ts.receiverData!.usersId}',
                              style: TextStyle(fontWeight: FontWeight.w400,color: Colors.white,fontSize: 18),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${lang?.translate("How much do you want to Send")}',
                          style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20),
                        ),
                        SizedBox(height: 8,),
                        getController.isCountry.value?
                        Text(
                          '${lang?.translate("Your balance right now is")} \$${AuP.userData!.balance}',
                          style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey,fontSize: 13),textAlign: TextAlign.center,
                        ):Text(
                          '${lang?.translate("Your balance right now is")} \$${AuP.userData!.balance} \n ${(double.parse(AuP.userData!.balance) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}',
                          style: TextStyle(fontWeight: FontWeight.w400,color: Colors.grey,fontSize: 13),textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20,),
                        getController.isCountry.value?
                        Column(
                          children: [
                            Container(
                              height: 55,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(blurRadius: 7, color: Colors.grey.shade300)
                                  ]),
                              child: Row(
                                children: [
                                  Text(" USD ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                                  Container(
                                    width: 15, // Adjust the width of the divider
                                    child: VerticalDivider(
                                      color: Colors.grey, // Color of the divider line
                                      thickness: 1,       // Thickness of the divider line
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: usdController,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color(0xFF151624),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(7) // Limit to 5 digits
                                    ],
                                      autofocus: true,
                                      onChanged: (value) {

                                          initialAmount = double.tryParse(value) ?? 0;
                                          // _calculateTotalAmount1();
                                          getController.idUSendMoney.value =false;
                                      },
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return '${lang?.translate("Please Enter a Amount")}';
                                        }
                                        return null;
                                      },
                                      cursorColor: const Color(0xFF151624),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: '${lang?.translate("Enter Amount")}',
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
                          ],
                        )
                        :Column(
                          children: [
                            Container(
                              height: 55,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(blurRadius: 7, color: Colors.grey.shade300),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(" ${getController.currencyType.value} ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                  Container(
                                    width: 15,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: inrController,
                                      focusNode: inrFocusNode, // Fix this to focus on usdFocusNode
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color(0xFF151624),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (value) {
                                        double inrAmount = double.tryParse(value) ?? 0;
                                        double usdAmount = inrAmount / getController.currency.value; // Replace exchangeRate with your actual rate
                                        usdController.text = usdAmount.toStringAsFixed(10);
                                        usdController1.text = usdAmount.toStringAsFixed(6);
                                        print("usdController==${usdController.text}");
                                         initialAmount = double.tryParse(usdController.text) ?? 0;
                                        //setState(() {});
                                        //_calculateTotalAmount();
                                        getController.idUSendMoney.value =false;
                                        //Future.delayed(Duration(seconds: 3)).then((value) => ((){}));

                                      },
                                      onFieldSubmitted: (v){
                                      },
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return '${lang?.translate("Please Enter a Amount")}';
                                        }
                                        return null;
                                      },
                                      cursorColor: const Color(0xFF151624),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: '${lang?.translate("Enter Amount")}',
                                        hintStyle: TextStyle(
                                          fontSize: 16.0,
                                          color: const Color(0xFF151624).withOpacity(0.5),
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      //
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              height: 55,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(blurRadius: 7, color: Colors.grey.shade300),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Text(" USD ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                  Container(
                                    width: 15,
                                    child: VerticalDivider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: usdController1,
                                      focusNode: usdFocusNode, // Fix this to focus on usdFocusNode
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color(0xFF151624),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        LengthLimitingTextInputFormatter(7),
                                      ],
                                      onChanged: (value) {
                                        double usdAmount = double.tryParse(value) ?? 0;
                                        double inrAmount = usdAmount * getController.currency.value; // Replace exchangeRate with your actual rate
                                        inrController.text = inrAmount.toStringAsFixed(6);
                                        initialAmount = double.tryParse(value) ?? 0;
                                        // _calculateTotalAmount();
                                        // Future.delayed(Duration(seconds: 3)).then((value) => setState((){}));
                                        getController.idUSendMoney.value =false;
                                        //Future.delayed(Duration(seconds: 3)).then((value) => setState((){}));
                                      },
                                      onFieldSubmitted: (v){
                                      },
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return '${lang?.translate("Please Enter a Amount")}';
                                        }
                                        return null;
                                      },
                                      cursorColor: const Color(0xFF151624),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: '${lang?.translate("Enter Amount")}',
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
                          ],
                        ),
                        SizedBox(height: 20,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 90),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(blurRadius: 7, color: Colors.grey.shade300)
                              ]),
                          child: Center(
                            child: TextFormField(
                               controller: noteController,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: const Color(0xFF151624),
                              ),

                              cursorColor: const Color(0xFF151624),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: '${lang?.translate("Enter Notes (Optional)")}',
                                hintStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: const Color(0xFF151624).withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        InkWell(
                          onTap: (){
                            usdFocusNode.unfocus();
                            inrFocusNode.unfocus();
                            adsLoader.show(context);
                            if(getController.isCountry.value){
                              _calculateTotalAmount1();
                            }else{
                              _calculateTotalAmount();

                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 110),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(colors: [
                                  primary,
                                  primary2
                                ]),
                                boxShadow: [
                                  BoxShadow(blurRadius: 7, color: Colors.grey.shade300)
                                ]),
                            child: Center(
                              child: Text("${lang?.translate("Calculation")}",style: TextStyle(color: Colors.white,fontSize: 16),)
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Obx(() =>
                          Column(children: [
                            getController.idUSendMoney.value?
                            ts.receiverDataType == "user_to_user"
                                ?Container(
                              margin: EdgeInsets.symmetric(horizontal: 13),
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Column(children: [
                                if(getController.isCountry.value)...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${ts.receiverData?.name.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("$initialAmount USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      Text("+ $adminCommissionPer USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${totalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                      Text("$totalAmountUsertoUser USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                ]else...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${ts.receiverData?.name.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${(initialAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${initialAmount.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      Text("+ ${(adminCommissionPer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 12,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("$adminCommissionPer USD",style: TextStyle(color: Colors.grey,fontSize: 11,

                                      ),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${totalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                      Text("${(totalAmountUsertoUser * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${totalAmountUsertoUser.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                ]
                              ],),
                            )
                                :Container(
                              margin: EdgeInsets.symmetric(horizontal: 7),
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)
                              ),
                              child: Column(children: [
                                if(getController.isCountry.value)...[

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ $adminCommissionPer USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Agent Commission')} ${agentCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ $agentCommissionPer USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${ts.receiverData?.name.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${totalAmount.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${totalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                      Text("${customerAmount.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                ]
                                else...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      Text("+ ${(adminCommissionPer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(" $adminCommissionPer USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Agent Commission')} ${agentCommission}%",style: TextStyle(fontSize: 10,color: Colors.grey),),
                                      Text("+ ${(agentCommissionPer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("$agentCommissionPer USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${ts.receiverData?.name.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${initialAmount?.toInt()} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                      Text("${(totalAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${totalAmount.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 12,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${totalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                      Text("${(customerAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${customerAmount.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 6,),
                                ]

                              ],),
                            ):SizedBox(),
                          ],),
                        ),

                      ],
                    ),
                  ),
                ),


                  Obx(() =>
                     Expanded(
                      flex:getController.idUSendMoney.value? 1:0,
                      child: SingleChildScrollView(
                        child: Obx(() => Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              getController.idUSendMoney.value?InkWell(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (double.parse(AuP.userData!.balance) >= totalAmount ) {
                                      if(ts.TransactionLimits! >= totalAmount){
                                        print("initialAmount ${initialAmount}");
                                        print("finalAmount ${totalAmount}");
                                        print("agentCommission ${agentCommission}");
                                        print("adminCommissio ${adminCommission}");
                                        print("customerAmount ${customerAmount}");
                                        ts.receiverDataType == "user_to_user"
                                            ? nextScreen(context, EnterPassword(
                                          sendeId: AuP.userData!.usersId,
                                          receiverId: ts.receiverData!.usersId,
                                          transactionType: ts.receiverDataType,
                                          Amount: initialAmount,
                                          finalAmount :totalAmountUsertoUser,
                                          note:noteController.text ?? "",
                                          amountoCollect: 0.0,
                                          agentcharge: agentCommission,
                                          admincharge: adminCommission,
                                          debitAmount:0.0,
                                        ))
                                            : nextScreen(context, EnterPassword(
                                          sendeId: AuP.userData!.usersId,
                                          receiverId: ts.receiverData!.usersId,
                                          transactionType: "credit",
                                          Amount: initialAmount,
                                          finalAmount :totalAmount,
                                          note:noteController.text ?? "",
                                          amountoCollect: 0.0,
                                          agentcharge: agentCommission,
                                          admincharge: adminCommission,
                                          debitAmount: customerAmount,
                                        ));
                                      }
                                      else{
                                        showSnackbarError(context, "${lang?.translate('Money transfer limit exceeded')}: \$${ts.TransactionLimits}");
                                      }
                                    }
                                    else{
                                      showSnackbarError(context, "${lang?.translate('Insufficient balance')}.");
                                    }
                                  }
                                  // Navigator.pushNamed(context, 'EnterPassword');
                                },
                                child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(horizontal:20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                      "${lang?.translate('Send Moneys')}",
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    )),
                              ):SizedBox(),
                              SizedBox(height: 15,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          )
        ),
      ),
    );
  }
}
