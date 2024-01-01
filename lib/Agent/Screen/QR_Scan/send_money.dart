// ignore_for_file: prefer_const_constructors


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

import '../../../Api/Controller/getx_controller.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Controller/transaction_provider.dart';
import '../../../User/Home/User_home_page.dart';
import '../../../User/Screen/BottomBar/bottom_bar.dart';
import '../../../utils/widgets.dart';
import '../../AppBar/appbar.dart';
import '../bottom_bar.dart';

class SendMoney extends StatefulWidget {
   SendMoney({super.key});

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {

  TextEditingController noteController = TextEditingController();
  TextEditingController usdController = TextEditingController();
  // TextEditingController usdController = TextEditingController();
  TextEditingController inrController = TextEditingController();
  double initialAmount = 0;
 // double transferFees = 0;
  double adminCommission = 0.0;
  double adminCommissionPer = 0.0;
  double agentCommission = 0.0;
  double agentCommissionPer = 0.0;
  double customerAmount = 0;
  double totalAmount = 0;
  double margeCommission = 0;
  double totalAmountUsertoUser = 0;

  void _calculateTotalAmount() {
    double inputAmount = double.tryParse(usdController.text) ?? 0;
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
      totalAmount = (inputAmount + adminCommissionPer);
      totalAmountUsertoUser = (inputAmount + adminCommissionPer);
      margeCommission = (adminCommissionPer + agentCommissionPer);
      customerAmount = (inputAmount + margeCommission);
    }
 print("totalAmount=${inputAmount}");
 print("totalAmount=${adminCommissionPer}");
 print("totalAmount=${totalAmount}");
    //totalAmount = double.parse(totalAmount.toStringAsFixed(6));
   // customerAmount = double.parse(customerAmount.toStringAsFixed(6));
    getController.idASendMoney.value =true;
    adsLoader.close();
  }
  FocusNode inrFocusNode = FocusNode();
  FocusNode usdFocusNode = FocusNode();
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
      totalAmount = (inputAmount + adminCommissionPer);
      totalAmountUsertoUser = (inputAmount + adminCommissionPer);
      margeCommission = (adminCommissionPer + agentCommissionPer);
      customerAmount = (inputAmount + margeCommission);
    }

    // totalAmount = double.parse(totalAmount.toStringAsFixed(6));
    // customerAmount = double.parse(customerAmount.toStringAsFixed(6));
    getController.idASendMoney.value =true;
    adsLoader.close();

  }
  GetController getController = Get.put(GetController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ts = context.read<TransactionProvider>();
    // transferFees = double.parse('${ts.TransactionsFee}');
    agentCommission = double.parse('${ts.agentCommission}');
    adminCommission = double.parse('${ts.adminCommission}');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getController.idASendMoney.value = false;
    });


    print("recivetDataType${ts.receiverDataType}");
  }
  @override
  Widget build(BuildContext context) {
    final ts = context.read<TransactionProvider>();
    final AuP = context.read<AuthProvider>();
    var lang = LocalizationStuff.of(context);
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async{
       AuP.userData?.role == 'Agent'?nextScreen(context, MyBottomBarApp(visit: 2,)):nextScreen(context, userBottomBarApp(visit: 0,));
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
                  bottomLeft: Radius.circular(30),
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
                          height: 25,
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
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                        LengthLimitingTextInputFormatter(7) // Limit to 5 digits
                                      ],
                                      autofocus: true,
                                      onChanged: (value) {

                                          initialAmount = double.tryParse(value) ?? 0;
                                          //_calculateTotalAmount1();
                                          getController.idASendMoney.value =false;
 

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
                                      focusNode: inrFocusNode,
                                      autofocus: false,
                                      onFieldSubmitted: (v){

                                      },// Fix this to focus on inrFocusNode
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color(0xFF151624),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onChanged: (value) {
                                        double inrAmount = double.tryParse(value) ?? 0;
                                        double usdAmount = inrAmount / getController.currency.value;
                                        usdController.text = usdAmount.toStringAsFixed(6);
                                       // usdController1.text = usdAmount.toStringAsFixed(6);

                                       // _calculateTotalAmount();
                                        initialAmount = usdAmount ?? 0;
                                        //Future.delayed(Duration(seconds: 3)).then((value) => setState((){}));
                                        getController.idASendMoney.value =false;

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
                                      controller: usdController,
                                      focusNode: usdFocusNode,
                                      autofocus: false,// Fix this to focus on usdFocusNode
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: const Color(0xFF151624),
                                      ),
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                        LengthLimitingTextInputFormatter(7),
                                      ],
                                      onChanged: (value) {

                                        double usdAmount = double.tryParse(value) ?? 0;
                                        double inrAmount = usdAmount * getController.currency.value; // Replace exchangeRate with your actual rate
                                        inrController.text = inrAmount.toStringAsFixed(6) ;
                                        initialAmount = double.tryParse(value) ?? 0;
                                        //_calculateTotalAmount();
                                        //Future.delayed(Duration(seconds: 3)).then((value) => setState((){}));
                                        getController.idASendMoney.value =false;

                                      },
                                      onFieldSubmitted: (v){
                                      },
                                      // onEditingComplete: (){
                                      //   FocusScope.of(context).unfocus();
                                      //
                                      // },
                                      validator: (input) {
                                        if (input == null || input.isEmpty) {
                                          return '${lang?.translate("Please Enter a Amount")}';
                                        }
                                        return null;
                                      },
                                      cursorColor: const Color(0xFF151624),
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      decoration: InputDecoration(
                                        hintText: 'Enter Amount',
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
                          height: 50,
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
                              autofocus: true,

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
                             getController.idASendMoney.value?
                            ts.receiverDataType == "agent_to_agent"
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
                                      Text("${ts.receiverData?.name.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      Text("${initialAmount.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ ${adminCommissionPer} USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${totalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                      Text("${totalAmountUsertoUser.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                ]else...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${ts.receiverData?.name.split(' ')[0]} ${lang?.translate('will get')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      Text("${(initialAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${initialAmount.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ ${(adminCommissionPer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${adminCommissionPer} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      // Text("${totalAmount} USD",style: TextStyle(fontSize: 18,fontWeight:FontWeight.w500),),
                                      Text("${(totalAmountUsertoUser * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 16,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${totalAmountUsertoUser.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                ]

                              ],),
                            )
                                :Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
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
                                      Text("${lang?.translate('Your friend will get')}:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("${initialAmount?.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ ${adminCommissionPer} USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Agent Commission')} ${agentCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ ${agentCommissionPer} USD",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      Text("${totalAmount.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 17,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Your Customer have to pay')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      Text("${customerAmount.toStringAsFixed(6)} USD",style: TextStyle(fontSize: 17,fontWeight:FontWeight.w500),),
                                    ],),
                                ]else...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Your friend will get')}:",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("${(initialAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 13,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${initialAmount?.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Admin Charge')} ${adminCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ ${(adminCommissionPer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${adminCommissionPer.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Agent Commission')} ${agentCommission}%",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                      Text("+ ${(agentCommissionPer * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 14,fontWeight:FontWeight.w400),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${agentCommissionPer} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Amount will debited')} :",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      Text("${(totalAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${totalAmount.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                  SizedBox(height: 4,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${lang?.translate('Your Customer have to pay')}:",style: TextStyle(fontSize: 13,color: Colors.black87,fontWeight:FontWeight.w500),),
                                      Text("${(customerAmount * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight:FontWeight.w500),),
                                    ],),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("${customerAmount.toStringAsFixed(6)} USD",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight:FontWeight.w500),),
                                    ],),
                                ]

                              ],),
                            ):SizedBox(),
                          ],),
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Obx(() =>
                   Expanded(
                     flex:getController.idASendMoney.value? 1:0,
                    child: SingleChildScrollView(
                      child: Obx(() =>  Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getController.idASendMoney.value?InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  if (double.parse(AuP.userData!.balance) >= totalAmount ) {
                                    if(ts.TransactionLimits! >= totalAmount ){
                                      ts.receiverDataType == "agent_to_agent"
                                          ? nextScreen (context, EnterPassword(
                                          sendeId: AuP.userData!.usersId,
                                          receiverId: ts.receiverData!.usersId,
                                          transactionType: ts.receiverDataType,
                                          Amount: double.parse(initialAmount.toStringAsFixed(6)),
                                          finalAmount :double.parse(totalAmountUsertoUser.toStringAsFixed(6)),
                                          note:noteController.text ?? "",
                                          amountoCollect: 0.0,
                                          agentcharge: double.parse("${ts.agentCommission}"),
                                          admincharge: double.parse("${ts.adminCommission}"), debitAmount: 0.0,
                                      )) :  nextScreen(context, EnterPassword(
                                          sendeId: AuP.userData!.usersId,
                                          receiverId: ts.receiverData!.usersId,
                                          transactionType: "credit",
                                          Amount: double.parse(initialAmount.toStringAsFixed(6)),
                                          finalAmount :double.parse(totalAmount.toStringAsFixed(6)),
                                          note:noteController.text ?? "",
                                          amountoCollect: double.parse(customerAmount.toStringAsFixed(6)),
                                          agentcharge: double.parse("${ts.agentCommission}"),
                                          admincharge: double.parse("${ts.adminCommission}"), debitAmount: 0.0,
                                      )
                                      );
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
                                  margin: EdgeInsets.symmetric(horizontal: 20),
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
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}
