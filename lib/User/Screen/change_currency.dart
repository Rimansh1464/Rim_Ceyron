import 'package:ceyron_app/Api/currency_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../Agent/AppBar/appbar.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/getx_controller.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/src/currency.dart';
import '../../utils/colors.dart';

class ChangeCurrency extends StatefulWidget {
  const ChangeCurrency({super.key});

  @override
  State<ChangeCurrency> createState() => _ChangeCurrencyState();
}

class _ChangeCurrencyState extends State<ChangeCurrency> {
  TextEditingController countryController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final sp = context.read<AuthProvider>();
    countryController.text = sp.userData!.currencyCountry;
  }
  GetController getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate("Change Currency")}"),
      body: Column(children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,boxShadow: [BoxShadow(
          color: Colors.grey,
          blurRadius: 10
        )]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text("   ${lang?.translate("Select Currency")}",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500),),
          Container(
            height: 55,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: countryController,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: const Color(0xFF151624),
                      ),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return 'Please Select Currency';
                        }
                      },
                      cursorColor: const Color(0xFF151624),
                      readOnly: true,
                      onTap: () {
                        showCurrencyPickers(
                          context: context,
                          showFlag: true,
                          showCurrencyName: true,
                          showCurrencyCode: true,
                          onSelect: (Currencys currency) {
                            print('Select currency: ${currency.name}');
                            print('Select currency: ${currency.name}');
                            countryController.text = currency.name;

                          },
                        );
                      },
                      decoration: InputDecoration(
                        hintText: "Select Currency",
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
          ),
          SizedBox(height: 30,),
          GestureDetector(
            onTap: () {
              // sp.signOut(context).then((value) => Navigator.pushNamed(context, 'UserLogin'));
              final sp = context.read<AuthProvider>();

              getController.changeCurrency(sp.userData!.id, countryController.text, context);
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
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "${lang?.translate('Confirm')}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
            SizedBox(height: 20,),
        ],),
      )
      ],),
    );
  }

}
