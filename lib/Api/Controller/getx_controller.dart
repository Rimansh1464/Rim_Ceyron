import 'dart:convert';
import 'package:ceyron_app/Api/Controller/transaction_provider.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../utils/widgets.dart';
import '../Api_Helper/api.dart';
import 'auth_provider.dart';
import 'local_stuff.dart';

class GetController extends GetxController {
  RxDouble currency = 0.0.obs;
  RxString currencyType = "".obs;
  Locale? locales;
  RxBool isCountry = false.obs;
  RxBool isUserAmount = true.obs;
  RxBool isAgentAmount = true.obs;
  RxBool idUSendMoney = false.obs;
  RxBool idASendMoney = false.obs;

  RxString LAGUAGE_CODE = 'languageCode'.obs;
  String? LanguageCode;
  String? LanguageCodes;

  RxString ENGLISH = 'en'.obs;
  RxString ARABIC = 'ar'.obs;
  RxString HINDI =  'hi'.obs;
  RxString French = 'fr'.obs;
  RxString Spanish = 'es'.obs;
  RxString Italian = 'it'.obs;
  RxString Chinese = 'zh'.obs;
  RxString Portuguese = 'pt'.obs;
  RxString Russian = 'ru'.obs;


  checkCountry(context){
    final sp= Provider.of<TransactionProvider>(context,listen: false);
    final AuP= Provider.of<AuthProvider>(context,listen: false);
    if('United States' == AuP.userData?.currencyCountry){
      isCountry.value = true;
      update();
    }else{
      isCountry.value = false;
      update();
    }
  }


  Future<Locale> setLocale(String languageCode) async {
    // SharedPreferences _prefLag = await SharedPreferences.getInstance();
    // await _prefLag.setString('LAGUAGE_CODE', languageCode);
    GetStorage _prefLag = GetStorage();
    _prefLag.write('LAGUAGE_CODE', languageCode);
    print("languageCode");
    return _locale(languageCode);
  }

  Future<Locale> GetLocat () async {

    return _locale('en_US');
  }

  copyText(text,context){
    var lang = LocalizationStuff.of(context);
    Clipboard.setData(ClipboardData(text:"$text"));
    showSnackbarSuccess(context, '${lang?.translate('Copy ID to clipboard')}');
  }

  Future<Locale> getLocale() async {
    // SharedPreferences _prefLag = await SharedPreferences.getInstance();
    // String languageCode = _prefLag.getString('LAGUAGE_CODE') ?? "en";
    GetStorage _prefLag = GetStorage();
    String languageCode = _prefLag.read('LAGUAGE_CODE') ?? "en";
    print("languageCode===${languageCode}");
    LanguageCode = languageCode;
    return _locale(languageCode);
  }

  void changeLanguage(context) async {
    Locale _locale = await setLocale('en');
    LanguageCode  = 'en';
    print("_locale==${_locale}");
     MyApp.setLocale(context, _locale);
    await Future.delayed(Duration(seconds: 2));
    update();
  }

  upgradeCurrency(
      String country, BuildContext context) async {
    final headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiam9obkBleGFtcGxlLmNvbSIsImFsZ29yaXRobSI6IlJTMjU2IiwiaWF0IjoxNjkzNzk3NzQ1fQ.3vVhhjf5oJrnGzJHEezzsIH-OU6u4ZBqj1pWAXVDe8M',
    };
    final response = await http.get(
      Uri.parse("${ApiUrl.giveCurrency}?country=$country"),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api currency Data==$responseData");

        if (responseData["success"] == true) {

          String data = responseData['data']["rates"].toString();
          currency.value = responseData['data']["rates"];
           print("currency.value==${currency.value}");
          currencyType.value = responseData['data']["symbol"];
          update();
        } else {
        }
      } else {
        update();
        throw Exception('failed');
      }
    } catch (e) {
      print('Eroor country = $e');
    }
    update();
  }

  changeCurrency(int id,
      String country, BuildContext context) async {
    adsLoader.show(context);

    final headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiam9obkBleGFtcGxlLmNvbSIsImFsZ29yaXRobSI6IlJTMjU2IiwiaWF0IjoxNjkzNzk3NzQ1fQ.3vVhhjf5oJrnGzJHEezzsIH-OU6u4ZBqj1pWAXVDe8M',
    };
    final response = await http.put(
      Uri.parse("${ApiUrl.changeCurrency}"),
      headers: headers,
      body: {
        'id': id.toString(),
        'country': country,
      },
    );
    final sp = context.read<AuthProvider>();
    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Contry Data==$responseData");

        if (responseData["success"] == true) {
          showSnackbarSuccess(context, "Currency successfully update");
          sp.updateData(context);
          adsLoader.close();
          await Future.delayed(Duration(seconds: 2));
          Navigator.pop(context);
          update();
        } else {
          adsLoader.close();
        }
      } else {
        adsLoader.close();
        update();
        throw Exception('failed');
      }
    } catch (e) {
      adsLoader.close();
      print('Eroor country = $e');
    }
    update();
  }

  getAllCountry(int id,
      String country, BuildContext context) async {
    final headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiam9obkBleGFtcGxlLmNvbSIsImFsZ29yaXRobSI6IlJTMjU2IiwiaWF0IjoxNjkzNzk3NzQ1fQ.3vVhhjf5oJrnGzJHEezzsIH-OU6u4ZBqj1pWAXVDe8M',
    };
    final response = await http.get(
      Uri.parse("${ApiUrl.getAllCountry}"),
      headers: headers,
    );

    try {
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("api Data==$responseData");

        if (responseData["success"] == true) {


          update();
        } else {
        }
      } else {
        update();
        throw Exception('failed');
      }
    } catch (e) {
      print('Eroor country = $e');
    }
    update();
  }

  Locale _locale(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return Locale(French.value, 'FR');
      case 'es':
        return Locale(Spanish.value, 'ES');
      case 'it':
        return Locale(Italian.value, 'IT');
      case 'ar':
        return Locale(ARABIC.value, "SA");
      case 'hi':
        return Locale(HINDI.value, "IN");
      case 'cn':
        return Locale(Chinese.value, "ZH");
      case 'pt':
        return Locale(Portuguese.value, "PT");
      case 'ru':
        return Locale(Russian.value, "RU");
      case 'en':
        return Locale(ENGLISH.value, "US");
      default:
        return Locale(ENGLISH.value, 'US');
    }
  }

  final supportedLangList = [
    "English",
    "French",
    "Spanish",
    "Italian",
    "Arabic",
    "Hindi",
    "Chinese",
    "Portuguese",
    "Russian",

  ];

}