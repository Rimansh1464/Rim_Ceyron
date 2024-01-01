import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/getx_controller.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/Controller/transaction_provider.dart';
import '../../Api/Model/transaction_model.dart';
import '../../User/Screen/send_money/u_trasaction_history_open.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';
import '../AppBar/appbar.dart';
import '../Screen/QR_Scan/trasaction_history_open.dart';

class TransactionHistory extends StatefulWidget {
  bool arrow;


   TransactionHistory({super.key,required this.arrow});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  Future getData() async {
    final sp = context.read<AuthProvider>();
    final ts = context.read<TransactionProvider>();
    sp.getUserData();
    sp.updateData(context);
    ts.updateDatas(1,context);
    currentPage = 1;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  Future<void> refresh(context) async {

    try {
      getData();
      await Future.delayed(Duration(seconds: 1));
    } catch (error) {
      // Handle any errors that occur during data fetching
    }
  }
  GetController getController = Get.put(GetController());
  int currentPage = 1;
  bool isLastPage = false;
  int totalRecords = 0;
  List<TransactionsData> combinedTransactions = [];
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TransactionProvider Tr = Provider.of<TransactionProvider>(context,listen: false);
    AuthProvider AuP = Provider.of<AuthProvider>(context,listen: false);
    var lang = LocalizationStuff.of(context);


    return WillPopScope(
      onWillPop: () async {
        return Future.value(false);
      },
      child: Scaffold(
        appBar:CustomAppBar4(title: "${lang?.translate('Transaction History')}"),
        body: RefreshIndicator(
          onRefresh: () {
            setState(() {});
            return refresh(context);
            setState(() {});
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: InkWell(
              //         onTap: (){
              //           startController.clear();
              //           endController.clear();
              //           showDialog(context: context, builder: (context) => AlertDialog(
              //             title: Row(mainAxisAlignment: MainAxisAlignment.center,
              //               children: [
              //                 Text("${lang?.translate('Statement')}"),
              //               ],
              //             ),
              //             content: Form(
              //               key: _formKey,
              //               child: Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   Authtextfeild(
              //                     titletext: "${lang?.translate('Start Date')}",
              //                     hintText: "${lang?.translate('Select Start Date')}",
              //                     color: Colors.grey.shade200,
              //                     controller: startController,
              //                     textSize: 15.toDouble(),
              //                     ontap: () async {
              //                       FocusScope.of(context).requestFocus(FocusNode()); // Close keyboard
              //                       final pickedDate = await showDatePicker(
              //                         context: context,
              //                         initialDate: DateTime.now(),
              //                         firstDate: DateTime(1900),
              //                         lastDate: DateTime.now(),
              //                       );
              //                       if (pickedDate != null) {
              //                         String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              //                         startController.text = formattedDate;
              //                       }
              //                     },
              //                     validator: (input) {
              //                       if (input == null || input.isEmpty) {
              //                         return '${lang?.translate('Please Enter Start Date')}';
              //                       }
              //                       return null;
              //                     },
              //                     icon: Icons.date_range,
              //                   ),
              //                   SizedBox(height: 10,),
              //                   Authtextfeild(
              //                     titletext: "${lang?.translate('End Date')}",
              //                     hintText: "${lang?.translate('Select End Date')}",
              //                     color: Colors.grey.shade200,
              //                     controller: endController,
              //                     textSize: 15.toDouble(),
              //                     ontap: () async {
              //                       FocusScope.of(context).requestFocus(FocusNode()); // Close keyboard
              //                       final pickedDate = await showDatePicker(
              //                         context: context,
              //                         initialDate: DateTime.now(),
              //                         firstDate: DateTime(1900),
              //                         lastDate: DateTime.now(),
              //                       );
              //                       if (pickedDate != null) {
              //                         String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              //                         endController.text = formattedDate;
              //                       }
              //                     },
              //                     validator: (input) {
              //                       if (input == null || input.isEmpty) {
              //                         return '${lang?.translate('Please Enter End Date')}';
              //                       }
              //                       return null;
              //                     },
              //                     icon: Icons.date_range,
              //                   ),
              //                   SizedBox(height: 40,),
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //                     children: [
              //                       InkWell(
              //                         onTap: () {
              //                           Navigator.pop(context);
              //                         },
              //                         child: Container(
              //                           alignment: Alignment.center,
              //                           height: 40,
              //                           width: 100,
              //                           decoration: BoxDecoration(
              //                             borderRadius: BorderRadius.circular(12.0),
              //                             gradient: LinearGradient(
              //                               colors: [
              //                                 primary,
              //                                 primary2,
              //                               ],
              //                               begin: Alignment.centerRight,
              //                               end: Alignment.centerLeft,
              //                             ),
              //                             boxShadow: [
              //                               BoxShadow(
              //                                 color: const Color(0xFF4C2E84)
              //                                     .withOpacity(0.2),
              //                                 offset: const Offset(0, 15.0),
              //                                 blurRadius: 60.0,
              //                               ),
              //                             ],
              //                           ),
              //                           child: Text(
              //                             '${lang?.translate("Cancel")}',
              //                             style: TextStyle(
              //                               fontSize: 16.0,
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.w600,
              //                               height: 1.5,
              //                             ),
              //                             textAlign: TextAlign.center,
              //                           ),
              //                         ),
              //                       ),
              //                       InkWell(
              //                         onTap: () {
              //                           if (_formKey.currentState!.validate()) {
              //                             Tr.onTaps(startController.text, endController.text, context);
              //                           }
              //                         },
              //                         child: Container(
              //                           alignment: Alignment.center,
              //                           height: 40,
              //                           width: 100,
              //                           decoration: BoxDecoration(
              //                             borderRadius: BorderRadius.circular(12.0),
              //                             gradient: LinearGradient(
              //                               colors: [
              //                                 primary,
              //                                 primary2,
              //                               ],
              //                               begin: Alignment.centerRight,
              //                               end: Alignment.centerLeft,
              //                             ),
              //                             boxShadow: [
              //                               BoxShadow(
              //                                 color: const Color(0xFF4C2E84)
              //                                     .withOpacity(0.2),
              //                                 offset: const Offset(0, 15.0),
              //                                 blurRadius: 60.0,
              //                               ),
              //                             ],
              //                           ),
              //                           child: Text(
              //                             '${lang?.translate("Download")}',
              //                             style: TextStyle(
              //                               fontSize: 16.0,
              //                               color: Colors.white,
              //                               fontWeight: FontWeight.w600,
              //                               height: 1.5,
              //                             ),
              //                             textAlign: TextAlign.center,
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ],),
              //             ),
              //           ));
              //         },
              //         child: Container(
              //           height: 45,
              //           margin: EdgeInsets.only(left: 10,right: 10),
              //           alignment: Alignment.center,
              //           child: Text("${lang?.translate('Download Statement')}",style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w500),),
              //           decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
              //               gradient: LinearGradient(
              //                   begin: Alignment.topCenter,
              //                   end: Alignment.bottomCenter,
              //                   colors: [
              //                     primary2,primary,
              //                   ])
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              Expanded(
                child: FutureBuilder<List<TransactionsData>>(
                  future: Tr.Transactions,
                  builder: (context, snapshot) {
                    print("Data===${snapshot.data?.length}");
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child:Lottie.asset(
                          'assets/lottie/no_data.json',height: 250
                      ));
                    } else {
                      combinedTransactions = snapshot.data!;
                      totalRecords = Tr.TotalRecord!;

                      if(combinedTransactions.isEmpty){
                        return Center(child:Lottie.asset(
                            'assets/lottie/no_data.json',height: 250
                        ));
                      }else{
                        return Container(
                          margin: const EdgeInsets.only(right: 8,left: 8,top: 15),
                          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 5)
                              ]),
                          child: ListView.builder(
                              itemCount: combinedTransactions.length,
                              itemBuilder: (context, i) {
                                final inputDateString = "${combinedTransactions[i].transactionDate}";
                                final inputDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
                                final inputDate = inputDateFormat.parse(inputDateString);

                                final istTimeZoneOffset = Duration(hours: 5, minutes: 30); // UTC+05:30 for IST
                                final istDateTime = inputDate.add(istTimeZoneOffset);

                                final outputDateFormat = DateFormat("dd MMM, HH:mm a");
                                final formattedDate = outputDateFormat.format(istDateTime);
                                return InkWell(
                                  onTap: (){
                                    if(combinedTransactions[i].mode == "send"){
                                      nextScreen(context, TransactionView(
                                        Data:combinedTransactions[i] ,
                                        transactionMode: 'send',
                                      ));

                                    }else{
                                      nextScreen(context, TransactionView(
                                        Data:combinedTransactions[i] ,
                                        transactionMode: 'receive',
                                      ));

                                    }

                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          combinedTransactions[i].mode == "send"?
                                          Image.asset("assets/icon/ic_red_arrow.png",scale: 8,)
                                              :Image.asset("assets/icon/ic_green_arrow.png",scale: 8,),
                                          SizedBox(width: 7,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 5,),
                                              combinedTransactions[i].mode == "send"?
                                              Text("${lang?.translate('Paid To')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),)
                                                  :Text("${lang?.translate('Received from')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
                                              combinedTransactions[i].mode == "send"?Text("${combinedTransactions[i].receiverName.split(" ").first}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),):
                                              Text(combinedTransactions[i].senderName.split(" ").first,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                                            ],
                                          ),
                                          Spacer(),
                                          getController.isCountry.value?
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(height: 5,),
                                              combinedTransactions[i].mode == "send"?
                                              Text("- \$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.red),)
                                                  :Text("+ \$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.green),),
                                              SizedBox(height: 5,),
                                            ],
                                          ):Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(height: 5,),
                                              combinedTransactions[i].mode == "send"?
                                              Text("- ${(double.parse(combinedTransactions[i].finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.red),)
                                                  :Text("+ ${(double.parse(combinedTransactions[i].finalAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.green),),
                                              SizedBox(height: 5,),
                                              combinedTransactions[i].mode == "send"?
                                              Text("- \$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black54),)
                                                  :Text("+\$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black54),),

                                            ],
                                          ),

                                        ],),
                                      SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Text("${formattedDate}",style: TextStyle(fontSize: 11,color: Colors.grey),),
                                          Spacer(),
                                          combinedTransactions[i].mode == "send"?
                                          Text("${lang?.translate("Send from")}  ",style: TextStyle(fontSize: 13,color: Colors.grey),)
                                              :Text("${lang?.translate("Received in")}  ",style: TextStyle(fontSize: 13,color: Colors.grey),),
                                          Image.asset("assets/icon/ic_wallet.png",scale: 30,)
                                        ],
                                      ),
                                      Divider(
                                        height: 35,
                                        thickness: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                      if(totalRecords > 30 )...[
                                        if (i == combinedTransactions.length-1)...[
                                          if (combinedTransactions.length < totalRecords)...[

                                              ElevatedButton(
                                                onPressed: loadNextPage,
                                                child: Text('Load More'),
                                              ),
                                          ]]
                                      ]
                                    ],
                                  ),
                                );
                              }
                          ),
                        );
                      }

                    }
                  },
                ),
              )
              // Expanded(
              //   child: FutureBuilder<List<TransactionsData>>(
              //     future: Tr.Transactions,
              //     builder: (context, snapshot) {
              //       print("Data===${snapshot.data?.length}");
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         return Center(child: CircularProgressIndicator());
              //       } else if (snapshot.hasError) {
              //         return Text('Error: ${snapshot.error}');
              //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              //         return  Center(child:   Lottie.asset(
              //             'assets/lottie/no_data.json',height: 250
              //         ));
              //       } else {
              //         List<TransactionsData>? Data = snapshot.data?.where((transaction) => transaction.senderName == '${AuP.userData?.name}')
              //             .toList();
              //
              //         List<TransactionsData>? sentTransactions =  snapshot.data?.where((transaction) => transaction.senderName == '${AuP.userData?.name}')
              //             .toList();
              //
              //         List<TransactionsData>? receivedTransactions = snapshot.data?.where((transaction) => transaction.receiverName == '${AuP.userData?.name}')
              //             .toList();
              //         sentTransactions?.forEach((transaction) => transaction.mode = 'send');
              //         receivedTransactions?.forEach((transaction) => transaction.mode = 'receive');
              //
              //         combinedTransactions.addAll(sentTransactions as Iterable<TransactionsData>);
              //         combinedTransactions.addAll(receivedTransactions as Iterable<TransactionsData>);
              //         combinedTransactions.sort((a, b) => -a.transactionDate.compareTo(b.transactionDate));
              //         if(combinedTransactions.isEmpty){
              //           return Center(child:   Lottie.asset(
              //               'assets/lottie/no_data.json',height: 250
              //           ));
              //         }else{
              //           return Container(
              //             margin: const EdgeInsets.only(right: 8,left: 8,top: 15),
              //             padding: EdgeInsets.symmetric(horizontal: 8,vertical: 15),
              //             width: double.infinity,
              //             decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              //                 color: Colors.white,
              //                 boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 5)
              //                 ]),
              //             child: ListView.builder(
              //                 itemCount: combinedTransactions.length,
              //                 itemBuilder: (context, i) {
              //                   final inputDateString = "${combinedTransactions[i].transactionDate}";
              //                   final inputDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
              //                   final inputDate = inputDateFormat.parse(inputDateString);
              //
              //                   final istTimeZoneOffset = Duration(hours: 5, minutes: 30); // UTC+05:30 for IST
              //                   final istDateTime = inputDate.add(istTimeZoneOffset);
              //
              //                   final outputDateFormat = DateFormat("dd MMM, HH:mm a");
              //                   final formattedDate = outputDateFormat.format(istDateTime);
              //                   return InkWell(
              //                     onTap: (){
              //                       if(combinedTransactions[i].mode == "send"){
              //                         nextScreen(context, TransactionView(
              //                           Data:combinedTransactions[i] ,
              //                           transactionMode: 'send',
              //                         ));
              //
              //                       }else{
              //                         nextScreen(context, TransactionView(
              //                           Data:combinedTransactions[i] ,
              //                           transactionMode: 'receive',
              //                         ));
              //
              //                       }
              //
              //                     },
              //                     child: Column(
              //                       children: [
              //                         Row(
              //                           crossAxisAlignment: CrossAxisAlignment.start,
              //                           children: [
              //                             combinedTransactions[i].mode == "send"?
              //                             Image.asset("assets/icon/ic_red_arrow.png",scale: 8,)
              //                                 :Image.asset("assets/icon/ic_green_arrow.png",scale: 8,),
              //                             SizedBox(width: 7,),
              //                             Column(
              //                               crossAxisAlignment: CrossAxisAlignment.start,
              //                               children: [
              //                                 SizedBox(height: 5,),
              //                                 combinedTransactions[i].mode == "send"?
              //                                 Text("${lang?.translate('Paid To')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),)
              //                                     :Text("${lang?.translate('Received from')}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),
              //                                 combinedTransactions[i].mode == "send"?Text("${combinedTransactions[i].receiverName.split(" ").first}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),):
              //                                 Text(combinedTransactions[i].senderName.split(" ").first,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
              //                               ],
              //                             ),
              //                             Spacer(),
              //                             getController.isCountry.value?
              //                             Column(
              //                               crossAxisAlignment: CrossAxisAlignment.end,
              //                               children: [
              //                                 SizedBox(height: 5,),
              //                                 combinedTransactions[i].mode == "send"?
              //                                 Text("- \$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.red),)
              //                                     :Text("+ \$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.green),),
              //                                 SizedBox(height: 5,),
              //                                ],
              //                             ):Column(
              //                               crossAxisAlignment: CrossAxisAlignment.end,
              //                               children: [
              //                                 SizedBox(height: 5,),
              //                                 combinedTransactions[i].mode == "send"?
              //                                 Text("- ${(double.parse(combinedTransactions[i].finalAmount) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.red),)
              //                                     :Text("+ ${(double.parse(combinedTransactions[i].finalAmount) * getController.currency.value).toStringAsFixed(2)} ${getController.currencyType.value}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500,color: Colors.green),),
              //                                 SizedBox(height: 5,),
              //                                 combinedTransactions[i].mode == "send"?
              //                                 Text("- \$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black54),)
              //                                     :Text("+\$${combinedTransactions[i].finalAmount}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,color: Colors.black54),),
              //
              //                               ],
              //                             ),
              //
              //                           ],),
              //                         SizedBox(height: 10,),
              //                         Row(
              //                           children: [
              //                             Text("${formattedDate}",style: TextStyle(fontSize: 11,color: Colors.grey),),
              //                             Spacer(),
              //                             combinedTransactions[i].mode == "send"?
              //                             Text("${lang?.translate("Send from")}  ",style: TextStyle(fontSize: 13,color: Colors.grey),)
              //                                 :Text("${lang?.translate("Received in")}  ",style: TextStyle(fontSize: 13,color: Colors.grey),),
              //                             Image.asset("assets/icon/ic_wallet.png",scale: 30,)
              //                           ],
              //                         ),
              //                         Divider(
              //                           height: 35,
              //                           thickness: 1,
              //                           color: Colors.grey.shade300,
              //                         )
              //                       ],
              //                     ),
              //                   );
              //                 }
              //             ),
              //           );
              //         }
              //
              //       }
              //     },
              //   ),
              // )

            ],
          ),
        ),
      ),
    );
  }

  void loadNextPage() async {
    try {
      final ts = context.read<TransactionProvider>();
      final AuP = context.read<AuthProvider>();
      final nextPageData = await ts.getTransactionss(currentPage+1,context);
      if (nextPageData!.isNotEmpty) {
        setState(() {

          combinedTransactions.addAll(nextPageData);

          currentPage++;
        });
      }
    } catch (e) {
      print("Error loading next page: $e");
    }
  }
  void loadInitialData() async {
    try {
      final ts = context.read<TransactionProvider>();
      final initialData = await ts.getTransactionss(currentPage,context);
      if (initialData!.isNotEmpty) {
        final firstPage = currentPage;
        setState(() {
          combinedTransactions = initialData;
          currentPage = firstPage;
        });
      }
    } catch (e) {
      print("Error loading initial data: $e");
    }
  }
}
