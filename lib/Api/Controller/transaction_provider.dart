import 'dart:io';
import 'dart:typed_data';
import 'package:timezone/timezone.dart' as tz;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:ceyron_app/Agent/auth/create_pin.dart';
import 'package:ceyron_app/Api/Api_Helper/api.dart';
import 'package:ceyron_app/Api/Controller/auth_provider.dart';
import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Agent/Home/home_page.dart';
import '../../Agent/Screen/QR_Scan/qr_code.dart';
import '../../Agent/Screen/QR_Scan/send_money.dart';
import '../../Agent/Screen/QR_Scan/success_page.dart';
import '../../User/Screen/pdf/pdf_success.dart';
import '../../User/Screen/send_money/u_send_money.dart';
import '../../User/Screen/send_money/user_success_page.dart';
import '../../User/auth/user_create_pin.dart';
import '../../utils/notiftion_helper.dart';
import '../../utils/widgets.dart';
import '../Model/reciver_data_model.dart';
import '../Model/transaction_model.dart';
import '../Model/user_model.dart';
import 'local_stuff.dart';

class TransactionProvider extends ChangeNotifier {
  Future<List<TransactionsData>>? Transactions;
  Future<List<UserData>>? AgentData;
  Uint8List? qrImage;
  ReciverData? receiverData;
  String? TransactionsFee;
  String? adminCommission;
  String? agentCommission;
  double? TransactionLimits;

  String? receiverDataType;
  int? TotalRecord = 0;

  updateData() {
    // Transactions = getTransactions();
    notifyListeners();
  }

  updateDatas(page, context) {
    // Transactions = getTransactions();
    Transactions = getTransactionss(page, context);
    notifyListeners();
  }

  insertAgentData(value) {
    AgentData = getAgentData(value);
    notifyListeners();
  }

  Future<List<TransactionsData>> getTransactions() async {
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    final response = await http.get(
      Uri.parse(ApiUrl.transactions),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("transactions Data == $responseData");
      List<dynamic> transactionsJson = responseData['data'];
      List<TransactionsData> transactions = transactionsJson
          .map((transactionJson) => TransactionsData.fromJson(transactionJson))
          .toList();
      notifyListeners();

      return transactions;
    } else {
      throw Exception('Fetching transactions failed');
    }
  }

  Future<List<TransactionsData>> getTransactionss(page, context) async {
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };


    AuthProvider Aut = Provider.of<AuthProvider>(context, listen: false);
    AuthProvider AuP = Provider.of<AuthProvider>(context, listen: false);

    final response = await http.get(
      Uri.parse("${ApiUrl.transactions}/${Aut.userData
          ?.usersId}?pageNo=${page}&perPage=30"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['success'] == false) {
        // Handle the case when success is false
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No Data"),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ));
        return [];
      }
      print("transactions Data == $responseData");
      List<dynamic> transactionsJson = responseData['data'];
      TotalRecord = responseData['totalRecords'];
      List<TransactionsData> transactions = transactionsJson
          .map((transactionJson) => TransactionsData.fromJson(transactionJson))
          .toList();
      notifyListeners();
      transactions?.forEach((transaction) {
        if (transaction.senderName == AuP.userData?.name) {
          transaction.mode = 'send';
        }
        else if (transaction.receiverName == AuP.userData?.name) {
          transaction.mode = 'receive';
        }
      });
      return transactions;
    } else {
      throw Exception('Fetching transactions failed');
    }
  }

  Future<List<UserData>> getAgentData(value) async {
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    final response = await http.get(
      Uri.parse("${ApiUrl.searchAgent}/${value}"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print("Agent Data == $responseData");
      List<dynamic> transactionsJson = responseData['data'];
      List<UserData> transactions = transactionsJson
          .map((transactionJson) => UserData.fromJson(transactionJson))
          .toList();
      notifyListeners();

      return transactions;
    } else {
      throw Exception('Fetching transactions failed');
    }
  }

  Future<void> generateQRCode(context) async {
    AuthProvider Auth = Provider.of<AuthProvider>(context, listen: false);
    String QrApi = "https://api.qrserver.com/v1/create-qr-code/?size=500x500&data=${Auth
        .userData?.usersId}";

    try {
      final response = await http.get(Uri.parse(QrApi));
      if (response.statusCode == 200) {
        qrImage = response.bodyBytes;
      } else {
        showSnackbarError(context, "No generating QR\nPlease try again");
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error generating QR code.'),
        ),
      );
    }
  }

  Future<void> getUserData(String userid, bool qr, BuildContext context) async {
    receiverData = receiverData;
    adsLoader.show(context);
    final headers = {'Authorization': 'Bearer {{authToken}}',};
    print("api Data userid==$userid");

    final response = await http.get(

        Uri.parse("${ApiUrl.receiverData}/${userid}"),
        headers: headers
    );

    receiverData = receiverData?.clean();
    notifyListeners();
    final Aut = context.read<AuthProvider>();
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data receiverData==$responseData");
        if (responseData["success"] == true) {
          List<dynamic> userDataList = responseData['data'];
          final AuP = context.read<AuthProvider>();

          if (userDataList.isNotEmpty) {
            print("api Data receiverData List ==${responseData['data']}");

            ReciverData user = ReciverData.fromJson(userDataList[0]);
            receiverData = user;
            notifyListeners();
            adsLoader.close();
            if (receiverData?.usersId == AuP.userData?.usersId) {
              adsLoader.close();
              qr ? Navigator.pop(context) : SizedBox();
              showSnackbarError(context, 'No data found.');
            } else {
              if (AuP.userData?.role == "Agent") {
                if (AuP.userData?.role == receiverData?.role) {
                  receiverDataType = "agent_to_agent";
                } else if (receiverData?.role == "User") {
                  receiverDataType = "agent_to_user";
                }
              } else if (AuP.userData?.role == "User") {
                if (AuP.userData?.role == receiverData?.role) {
                  receiverDataType = "user_to_user";
                } else if (receiverData?.role == "Agent") {
                  receiverDataType = "user_to_agent";
                }
              }
              print("receiverDataType==${receiverDataType}");
              showTransactionFee(context, receiverDataType!).then((value) {
                if (Aut.userData?.role == "User") {
                  qr ? nextScreen(context, USendMoney(),) : SizedBox();
                } else if (Aut.userData?.role == "Agent") {
                  qr ? nextScreen(context, SendMoney(),) : SizedBox();
                }
              });
            }
          } else {
            adsLoader.close();
            qr ? Navigator.pop(context) : SizedBox();
            showSnackbarError(context, 'No data found.');
          }
          adsLoader.close();
          await Future.delayed(Duration(seconds: 2));
          notifyListeners();
        } else {
          adsLoader.close();
          qr ? Navigator.pop(context) : SizedBox();
          showSnackbarError(context, responseData["message"]);
        }

        notifyListeners();
      } else {
        throw Exception('failed');
      }
    } catch (e) {
      qr ? Navigator.pop(context) : SizedBox();
      Navigator.pop(context);
      print('Eroor = $e');
      notifyListeners();
    }
  }

  Future<void> pinVerify(int id,
      String Pin,
      String confirmPin,
      double amount,
      double finalAmount,
      String transactionType,
      String note,
      double amountoCollect,
      double agentcharge,
      double admincharge,
      BuildContext context) async {
    adsLoader.show(context);
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    final response = await http.post(
      Uri.parse("${ApiUrl.pinVerify}"),
      headers: headers,
      body: {
        'id': id.toString(),
        'pin': Pin,
        'confirm_pin': confirmPin,
      },
    );
    try {
      final AuP = context.read<AuthProvider>();
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("Api Data == $responseData");

        if (responseData["success"] == true) {
          await Future.delayed(Duration(seconds: 2));
          transferMoney(
              AuP.userData!.usersId,
              receiverData!.usersId,
              transactionType,
              amount,
              finalAmount,
              note,
              amountoCollect,
              agentcharge,
              admincharge,
              context);
          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }

        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "failed");
        throw Exception('failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Eroor = $e');
      notifyListeners();
    }
  }

  Future<void> transferMoney(String sender_id,
      String receiver_id,
      String transaction_type,
      double amount,
      double finalAmount,
      String note,
      double amountoCollect,
      double agentcharge,
      double admincharge,
      BuildContext context) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(
        context, listen: false);
    adsLoader.show(context);
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    if (sender_id.isEmpty ||
        receiver_id.isEmpty ||
        transaction_type.isEmpty) {
      // Show a SnackBar with validation error message
      showSnackbarError(context, "Please fill in all fields");
      adsLoader.close();
      adsLoader.close();
      notifyListeners();

      return;
    }

    final response = await http.post(
      Uri.parse(ApiUrl.transferCoin),
      headers: headers,
      body: {
        'sender_id': sender_id,
        'receiver_id': receiver_id,
        'transaction_type': receiverDataType,
        'amount': amount.toString(),
        'final_amount': finalAmount.toString(),
        'note': note,
        'amount_to_collect': amountoCollect.toString(),
        'agent_charge': agentcharge.toString(),
        'admin_charge': admincharge.toString(),
        'debit_amount': "0",
      },
    );
    print("sender_id:${sender_id}");
    print("receiver_id:${receiver_id}");
    print("transaction_type:${receiverDataType}");
    print("amount:${amount}");
    print("final_amount:${finalAmount}");
    print("amount_to_collect:${amountoCollect}");
    print("agent_charge:${agentcharge}");
    print("admin_charge:${admincharge}");
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);


        if (responseData["success"] == true) {
          // showSnackbarSuccess(context, responseData["status"]);
          final transaction_id = responseData['data']["transaction_id"] ?? "";
          final sender_name = responseData['data']["sender_name"] ?? "";
          final receiver_name = responseData['data']["receiver_name"] ?? "";
          final Amount = responseData['data']["final_amount"] ?? "";
          final transaction_date = responseData['data']["transaction_date"] ??
              "";
          final Note = responseData['data']["note"] ?? "";
          final Map<String, dynamic> TransactionsList = responseData['data'];
          TransactionsData user = TransactionsData.fromJson(TransactionsList);

          await Future.delayed(Duration(seconds: 2));
          notifyListeners();
          adsLoader.close();
          nextScreen(context,
              SuccessPage(
                  Data: user,
                  transaction_id: transaction_id,
                  sender_name: sender_name,
                  receiver_name: receiver_name,
                  Amount: Amount,
                  transaction_date: transaction_date,
                  Note: Note));
          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
          Navigator.pop(context);
          adsLoader.close();
          notifyListeners();
        }

        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "failed");
        throw Exception('failed');
      }
    } catch (e) {
      adsLoader.close();
      adsLoader.close();
      print('Eroor tra = ${e}');
      // _hasError = true;
      notifyListeners();
    }
  }


  Future<void> showTransactionFee(BuildContext context, String type) async {
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    final response = await http.get(
      // Uri.parse(ApiUrl.globalSetting),
        Uri.parse("${ApiUrl.globalSetting1}?charge_type=${type}"),
        headers: headers
    );
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("transaction api Data==$responseData");

        if (responseData["success"] == true) {
          print("adminCommission=${responseData['data']["admin_charge"]}");
          print("agentCommission=${responseData['data']["agent_charge"]}");
          TransactionsFee = responseData['data']["transaction_fees"] ?? "";
          TransactionLimits =
              double.parse('${responseData['data']["transaction_limits"]}');
          adminCommission = responseData['data']["admin_charge"] ?? "";
          agentCommission = responseData['data']["agent_charge"] ?? "";
          receiverDataType = responseData['data']['charge_type'] ?? "";

          notifyListeners();
        } else {}

        notifyListeners();
      } else {
        throw Exception('transaction_fees failed');
      }
    } catch (e) {
      print('Eroor = $e');
      notifyListeners();
    }
  }


///////////////////////////////////// User //////////////////////////////////////////////

  Future<void> pinVerifyUser(int id,
      String Pin,
      String confirmPin,
      double amount,
      double finalAmount,
      String transactionType,
      String note,
      double amountoCollect,
      double agentcharge,
      double admincharge,
      double debit_amount,
      BuildContext context) async {
    adsLoader.show(context);
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    final response = await http.post(
      Uri.parse("${ApiUrl.pinVerify}"),
      headers: headers,
      body: {
        'id': id.toString(),
        'pin': Pin,
        'confirm_pin': confirmPin,
      },
    );
    try {
      final AuP = context.read<AuthProvider>();
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data == $responseData");


        if (responseData["success"] == true) {
          await Future.delayed(Duration(seconds: 2));
          transferMoneyUser(
              AuP.userData!.usersId,
              receiverData!.usersId,
              transactionType,
              amount,
              finalAmount,
              note,
              amountoCollect,
              agentcharge,
              admincharge,
              debit_amount,
              context);
          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
        }

        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "failed");
        throw Exception('failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Eroor = $e');
      notifyListeners();
    }
  }

  Future<void> transferMoneyUser(String sender_id,
      String receiver_id,
      String transaction_type,
      double amount,
      double finalAmount,
      String note,
      double amountoCollect,
      double agentcharge,
      double admincharge,
      double debit_amount,
      BuildContext context) async {
    AuthProvider authProvider = Provider.of<AuthProvider>(
        context, listen: false);
    adsLoader.show(context);
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    if (sender_id.isEmpty ||
        receiver_id.isEmpty ||
        transaction_type.isEmpty) {
      // Show a SnackBar with validation error message
      showSnackbarError(context, "Please fill in all fields");
      adsLoader.close();
      adsLoader.close();
      notifyListeners();
      return;
    }
    final response = await http.post(
      Uri.parse(ApiUrl.transferCoin),
      headers: headers,
      body: {
        'sender_id': sender_id,
        'receiver_id': receiver_id,
        'transaction_type': receiverDataType,
        'amount': "$amount",
        'final_amount': "$finalAmount",
        'note': note,
        'amount_to_collect': '0',
        'agent_charge': "${agentcharge.toString()}",
        'admin_charge': "${admincharge.toString()}",
        'debit_amount': "$debit_amount",
      },
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {
          // showSnackbarSuccess(context, responseData["status"]);
          final transaction_id = responseData['data']["transaction_id"] ?? "";
          final sender_name = responseData['data']["sender_name"] ?? "";
          final receiver_name = responseData['data']["receiver_name"] ?? "";
          final Amount = responseData['data']["final_amount"] ?? "";
          final transaction_date = responseData['data']["transaction_date"] ??
              "";
          final Note = responseData['data']["note"] ?? "";
          final Map<String, dynamic> TransactionsList = responseData['data'];
          TransactionsData user = TransactionsData.fromJson(TransactionsList);

          await Future.delayed(Duration(seconds: 2));
          notifyListeners();
          adsLoader.close();
          nextScreen(context, USuccessPage(
              Data: user,
              transaction_id: transaction_id,
              sender_name: sender_name,
              receiver_name: receiver_name,
              Amount: Amount,
              transaction_date: transaction_date,
              Note: Note));
          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, responseData["message"]);
          Navigator.pop(context);
          adsLoader.close();
          notifyListeners();
        }

        notifyListeners();
      } else {
        adsLoader.close();
        showSnackbarError(context, "failed");
        throw Exception('failed');
      }
    } catch (e) {
      adsLoader.close();
      adsLoader.close();
      print('Eroor = $e');
      // _hasError = true;
      notifyListeners();
    }
  }


///////////////////////////////////// PDF //////////////////////////////////////////////

  Future<List<TransactionsData>> makePDF(statDate, endDate, context) async {
    final headers = {
      'Authorization': 'Bearer {{authToken}}',
    };
    AuthProvider Aut = Provider.of<AuthProvider>(context, listen: false);
    AuthProvider AuP = Provider.of<AuthProvider>(context, listen: false);

    final response = await http.get(
      Uri.parse("${ApiUrl.transactions}/date-wise/${AuP.userData
          ?.usersId}?startDate=${statDate}&endDate=${endDate}"),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['data'] == null) {
        showSnackbarError(context, "No Data Found");
        Navigator.pop(context);
        return <TransactionsData>[]; // Return an empty list when there is no data
      }else{
        print("PDF Data == $responseData");
        List<dynamic> transactionsJson = responseData['data'];
        List<TransactionsData> transactions = transactionsJson
            .map((transactionJson) => TransactionsData.fromJson(transactionJson))
            .toList();
        notifyListeners();
        return transactions;
      }

    } else {
      throw Exception('Fetching transactions failed');
    }
  }

  Future<List<Map<String, dynamic>>> generateData(startDate, endDate, context) async {
    // Fetch transaction data from the API
    List<TransactionsData> transactions = await makePDF(
      startDate, // Format the date as needed
      endDate,   // Format the date as needed
      context,
    );

    // Convert transaction data to the format required for PDF
    List<Map<String, dynamic>> data = [];
    if(transactions.isEmpty){

    }else{
      for (var transaction in transactions) {
        AuthProvider AuP = Provider.of<AuthProvider>(context,listen: false);

        final inputDateString = "${transaction.transactionDate}";
        final inputDateFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSS'Z'");
        final inputDate = inputDateFormat.parse(inputDateString);

        final istTimeZoneOffset = Duration(hours: 5, minutes: 30); // UTC+05:30 for IST
        final istDateTime = inputDate.add(istTimeZoneOffset);

        final outputDateFormat = DateFormat("dd MMM yyyy, HH:mm a");
        final formattedDate = outputDateFormat.format(istDateTime);
        String? mode;
        if (transaction.senderId == AuP.userData?.usersId.toString()) {
          mode = 'send';
        } else if (transaction.receiverId == AuP.userData?.usersId.toString()) {
          mode = 'receive';
        }
        String amountText;
        if(AuP.userData!.role=="User"){switch (transaction.transactionType) {
          case "agent_to_user":
            amountText =  mode=="send" ?"- \$${transaction.amount}" : "+ \$${transaction.amount}" ;
            break;
          case "user_to_user":
            amountText = mode=="send" ? "- \$${transaction.finalAmount}" : "+ \$${transaction.amount}";
            break;
          case "user_to_agent":
            amountText = mode=="send" ? "- \$${transaction.debitAmount}" : "+ \$${transaction.debitAmount}";
            break;

          default:
            amountText = mode=="send" ? "- \$${transaction.finalAmount}" : "+ \$${transaction.finalAmount}";
        }}else{
          amountText = mode=="send" ? "- \$${transaction.finalAmount}" : "+ \$${transaction.finalAmount}";
        }

        data.add({
          'Transaction Date': formattedDate,
          if (mode == 'send')
            'Details': " Paid To ${transaction.receiverName}   ",
          if (mode == 'receive')
            'Details': " Received from ${transaction.senderName}   ",
          'Transaction ID': transaction.transactionId,
          'Type': mode == 'send' ? "Debit" : "Credit",
          'Amount': mode == 'send' ? (amountText ?? " ") : (amountText ?? " "),

        });
      }
    }


    return data;
  }

  DateTime dn = DateTime.now();

  onTaps(startDate, endDate, context) async {
    adsLoader.show(context);

    final status = await Permission.storage.request();
    final status1 = await Permission.photos.request();
    //final statuss = await Permission.manageExternalStorage.request();
    print("status==${status}");
    final inputDateFormat = DateFormat("yyyy-MM-dd");
    final outputDateFormat = DateFormat("dd-MM-yyyy");
    final inputDate1 = inputDateFormat.parse(startDate);
    final inputDate2 = inputDateFormat.parse(endDate);
    final formate1 =  outputDateFormat.format(inputDate1);
    final formate2 =  outputDateFormat.format(inputDate2);
    if (status.isGranted||status1.isGranted) {
      final pdf = pw.Document();

      final List<Map<String, dynamic>> data = await generateData(startDate, endDate, context);
      if(data.isNotEmpty){
        for (int i = 0; i < data.length; i += 15) {
          final List<Map<String, dynamic>> pageData = data.sublist(
              i, i + 15 > data.length ? data.length : i + 15);

          pdf.addPage(
            pw.Page(pageFormat: PdfPageFormat.a4,
              build: (context) {
                return pw.Column(children: [
                  pw.Text(
                    "Ceyron Statement",
                    style: pw.TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    "$formate1 To $formate2",
                    style: const pw.TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.UrlLink(
                      destination: "https://ceyronpartners.com",
                      child:pw.Text("https://ceyronpartners.com",
                        style: const pw.TextStyle(
                            fontSize: 12,color: PdfColors.blue
                        ),)),
                  pw.SizedBox(height: 20),
                  pw.Table.fromTextArray(
                    context: context,
                    headerStyle: pw.TextStyle(),
                    cellAlignment: pw.Alignment.centerLeft,
                    headerDecoration:
                    pw.BoxDecoration(color: PdfColors.grey300),
                    cellHeight: 30,
                    headerHeight: 40,

                    data: [
                      ['Transaction Date','Details','Transaction ID', 'Type', 'Amount'],
                      for (var item in pageData)
                        [
                          item['Transaction Date'],
                          item['Details'],
                          item['Transaction ID'],
                          item['Type'],
                          item['Amount'],
                        ],
                    ],
                  )
                ]);
              },
            ),
          );
        }
        AuthProvider authProvider = Provider.of<AuthProvider>(context,listen: false);

        final output = await getExternalStorageDirectory();
        final directoryPath = "${output!.path}/Download";
        final inputDateFormat = DateFormat("yyyy-MM-dd");
        final outputDateFormat = DateFormat("dd-MM-yy");
        final inputDate1 = inputDateFormat.parse(startDate);
        final inputDate2 = inputDateFormat.parse(endDate);
        final formate11 =  outputDateFormat.format(inputDate1);
        final formate22 =  outputDateFormat.format(inputDate2);
        //  final directoryPath = "/storage/emulated/0/Download";
        final filename = "${authProvider.userData?.usersId} Statement- ${formate11} to ${formate22}_${dn.second}.pdf";
        final filePath = '$directoryPath/$filename';

        final directory = Directory(directoryPath);
        await directory.create(recursive: true);

        final file = File(filePath);
        await file.writeAsBytes(await pdf.save());
        adsLoader.close();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('PDF file saved at: ${file.path}'),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
        ));
        nextScreen(context, PdfSuccess(path:file.path,name: filename));
        print("==============${file.path}");
      }else{
        Navigator.pop(context);
      }


    }
  }
  Future<void> scheduleNotifications({required id,required title,required body, required time}) async {

    showNotifications(id: 1,title: "sda",body: "ws",path: time);
    notifyListeners();

  }
}