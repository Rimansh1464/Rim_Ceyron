
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../Agent/Screen/bottom_bar.dart';
import '../../User/Screen/BottomBar/bottom_bar.dart';
import '../../utils/next_screen.dart';
import '../../utils/widgets.dart';
import 'package:http/http.dart' as http;

import '../Api_Helper/api.dart';
import 'auth_provider.dart';

class KycProvider extends ChangeNotifier {
  // Future<List<TransactionsData>>?  Transactions;
//   Uint8List? qrImage;
//   ReciverData? receiverData;
//   String? TransactionsFee;
//   double? TransactionLimits;

  int? agentId;
  File? Selfie_with_document;
  File? KYC_Front_Image;
  File? KYC_Back_Image;
  String? full_name;
  String? email;
  String? dob;
  String? address;
  String? state;
  String? country;
  String? zip_code;
  String? city;


  Future<void> kycDetails(BuildContext context) async {
    adsLoader.show(context);

    final headers = {
      'Authorization': 'Bearer {{jwtToken}}',
    };

    final Aut = context.read<AuthProvider>();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${ApiUrl.kyc}"),
    );

    request.headers.addAll(headers);

    request.fields.addAll({
      'agents_id': Aut.userData?.usersId.toString() ??"",
      'full_name': full_name ??"",
      'email': email ??"",
      'dob': dob ??"",
      'address': address ??"",
      'state': state ??"",
      'country': country ??"",
      'zip_code': zip_code ??"",
      'city': city ?? "",

    });

    // Add images as parts of the MultipartRequest
    if (Selfie_with_document != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'Selfie_with_document',
        Selfie_with_document!.path,
      ));
    }
    if (KYC_Front_Image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'KYC_Front_Image',
        KYC_Front_Image!.path,
      ));
    }
    if (KYC_Back_Image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'KYC_Back_Image',
        KYC_Back_Image!.path,
      ));
    }
print("KYC_Front_Image_Size=== ${KYC_Front_Image?.lengthSync()}");
print("KYC_Back_Image=== ${KYC_Back_Image?.lengthSync()}");
print("Selfie_with_document_Size=== ${Selfie_with_document?.lengthSync()}");
    try {
      final response = await request.send();
      print("responseData = ${response.statusCode}");
      final responseData = await response.stream.bytesToString();
      final parsedResponse = json.decode(responseData);
      print("responseData = ${parsedResponse}");

      if (response.statusCode == 200) {
        if (parsedResponse["success"] == true) {
          // Success handling
          showSnackbarSuccess(context, parsedResponse['message']);
          await Future.delayed(Duration(seconds: 2));
          notifyListeners();
          adsLoader.close();
          AuthProvider Aup = Provider.of<AuthProvider>(context,listen: false);
          Aup.userData?.role == 'Agent'?nextScreen(context, MyBottomBarApp(visit: 2,)):nextScreen(context, userBottomBarApp(visit: 0,));

          nextScreen(context, MyBottomBarApp(visit: 0));
          notifyListeners();
        } else {
          adsLoader.close();
          showSnackbarError(context, parsedResponse["message"]);
          notifyListeners();

        }
      } else {
        adsLoader.close();
        adsLoader.close();
        showSnackbarError(context, "Request failed");
        notifyListeners();
      }
    } catch (e) {
      adsLoader.close();
      print('Error: $e');
    }
  }
}

