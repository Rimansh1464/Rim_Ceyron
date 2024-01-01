import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/User/Screen/send_money/u_trasaction_history_open.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../Agent/AppBar/appbar.dart';
import '../../../Agent/Screen/QR_Scan/trasaction_history_open.dart';
import '../../../Agent/Screen/change_password.dart';
import '../../../Agent/Screen/change_pin.dart';
import '../../../Api/Controller/getx_controller.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Controller/transaction_provider.dart';
import '../../../Api/Model/transaction_model.dart';
import '../../../utils/colors.dart';
import '../../../utils/widgets.dart';

class UTransactionHistory extends StatefulWidget {
  bool arrow;


   UTransactionHistory({super.key,required this.arrow});

  @override
  State<UTransactionHistory> createState() => _UTransactionHistoryState();
}

class _UTransactionHistoryState extends State<UTransactionHistory> {

  Future getData() async {
    final sp = context.read<AuthProvider>();
    final ts = context.read<TransactionProvider>();
    getController.checkCountry(context);
    sp.getUserData();
    sp.updateData(context);
    ts.updateDatas(1,context);
    currentPage = 1;

  }
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
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
  DateTime selectedDate = DateTime.now(); // Initial date
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  int pageSize = 10;
  List<TransactionsData> combinedTransactions = [];
  int currentPage = 1;
  bool isLastPage = false;
  int totalRecords = 0;

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    TransactionProvider Tr = Provider.of<TransactionProvider>(context,listen: false);
    AuthProvider AuP = Provider.of<AuthProvider>(context,listen: false);
    void _showPopupMenu(BuildContext context) {
      final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

      showMenu(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromPoints(
            overlay.localToGlobal(Offset.zero, ancestor: overlay),
            overlay.localToGlobal(overlay.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        ),
        items: <PopupMenuEntry>[
          PopupMenuItem(
            child: Text('Option 1'),
            value: 'Option 1',
          ),
          PopupMenuItem(
            child: Text('Option 2'),
            value: 'Option 2',
          ),
          PopupMenuItem(
            child: Text('Option 3'),
            value: 'Option 3',
          ),
        ],
      ).then((value) {
        if (value != null) {
          // Handle the selected option here
          print('Selected: $value');
        }
      });
    }

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
                      return  Center(child:   Lottie.asset(
                          'assets/lottie/no_data.json',height: 250
                      ));
                    } else {
                      combinedTransactions = snapshot.data!;
                      totalRecords = Tr.TotalRecord!;
                      print(combinedTransactions.length);
                      print(totalRecords);
                      if(combinedTransactions.isEmpty){
                        return Center(child:   Lottie.asset(
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
                          child: Column(
                            children: [
                              Expanded(
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
                                            nextScreen(context, UserTransactionView(
                                              Data:combinedTransactions[i] ,
                                              transactionMode: 'send',
                                            ));
                                          }else{
                                            nextScreen(context, UserTransactionView(
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
                                                SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 5,),
                                                    combinedTransactions[i].mode == "send"?
                                                    Text("${lang?.translate('Paid To')}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),)
                                                        :Text("${lang?.translate('Received from')}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300),),
                                                    combinedTransactions[i].mode == "send"?Text("${combinedTransactions[i].receiverName.split(" ").first}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),):
                                                    Text(combinedTransactions[i].senderName.split(" ").first,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),),
                                                  ],
                                                ),
                                                Spacer(),
                                                getController.isCountry.value?
                                                buildTransactionText1(combinedTransactions[i])
                                                    :buildTransactionText2(combinedTransactions[i]),
                                              ],),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Text("${formattedDate}",style: TextStyle(fontSize: 12,color: Colors.grey),),
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
                                               if(combinedTransactions.length+1 !=totalRecords)...[
                                                 ElevatedButton(
                                                   onPressed: loadNextPage,
                                                   child: Text("${lang?.translate("Load More")}"),
                                                 ),
                                               ]


                                             ]]
                                         ]
                                          ],
                                        ),
                                      );
                                    },

                                ),
                              ),
                            ],
                          ),
                        );
                      }

                    }
                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  Widget buildTransactionText1(TransactionsData transaction) {
    final bool isSend = transaction.mode == "send";
    final String prefix = isSend ? "-" : "+";
    final Color textColor = isSend ? Colors.red : Colors.green;

    String amountText;

    switch (transaction.transactionType) {
      case "agent_to_user":
        amountText =  isSend ?"- \$${transaction.amount}" : "+ \$${transaction.amount}" ;
        break;
      case "user_to_user":
        amountText = isSend ? "- \$${transaction.finalAmount}" : "+ \$${transaction.amount}";
        break;
      case "user_to_agent":
        amountText = isSend ? "- \$${transaction.debitAmount}" : "+ \$${transaction.debitAmount}";
        break;

      default:
        amountText = isSend ? "- \$${transaction.finalAmount}" : "+ \$${transaction.finalAmount}";
    }

    return Text("$amountText", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor));
  }

  Widget buildTransactionText2(TransactionsData transaction) {
    final bool isSend = transaction.mode == "send";
    final String amount = isSend ? "- " : "+";
    final Color amountColor = isSend ? Colors.red : Colors.green;
    final Color textColor = Colors.black54;

    String mainAmount = "";
    String additionalAmount = "";

    switch (transaction.transactionType) {
      case "agent_to_user":
        mainAmount = "${(double.parse(transaction.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}";
        additionalAmount = "\$${(double.parse(transaction.amount))}";
        break;
      case "user_to_user":
        mainAmount = "${(double.parse(transaction.mode == "send" ? transaction.finalAmount : transaction.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}";
        additionalAmount = "\$${(double.parse(transaction.mode == "send" ? transaction.finalAmount : transaction.amount))}";
        break;
      case "user_to_agent":
        mainAmount = "${(double.parse(transaction.debitAmount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}";
        additionalAmount = "\$${(double.parse(transaction.debitAmount))}";
        break;
      default:
        mainAmount = "${(double.parse(transaction.mode == "send" ? transaction.finalAmount : transaction.amount) * getController.currency.value).toStringAsFixed(6)} ${getController.currencyType.value}";
        additionalAmount = "\$${(double.parse(transaction.mode == "send" ? transaction.finalAmount : transaction.amount))}";
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: 5),
        Text("$amount$mainAmount", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: amountColor)),
        SizedBox(height: 5),
        Text("$amount$additionalAmount", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: textColor)),
      ],
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
}
