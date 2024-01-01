import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:provider/provider.dart';

import '../../Agent/AppBar/appbar.dart';
import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/currency_picker.dart';
import '../../Api/src/currency.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';

class UEditAccountData extends StatefulWidget {
  const UEditAccountData({super.key});

  @override
  State<UEditAccountData> createState() => _UEditAccountDataState();
}

class _UEditAccountDataState extends State<UEditAccountData> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController contryController = TextEditingController();

  getData(context) {
    final sp = Provider.of<AuthProvider>(context, listen: false);
     //AuthProvider sp = Provider.of<AuthProvider>(context);

    contryController.text = sp.userData!.country;
    nameController.text = sp.userData!.name;
    emailController.text = sp.userData!.email;
    numberController.text = sp.userData!.phoneNumber;
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
  }


  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate("Edit")}"),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: <Widget>[
                SizedBox(height: 0),
                CommanTextField(
                    labelText: "${lang?.translate('Your Name')}",
                    controller: nameController,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter Name';
                      }

                      return null;
                    },
                    hint: "${lang?.translate('Enter your name')}"),
                SizedBox(height: 6),
                CommanTextField(
                  readOnly: true,
                    labelText: "${lang?.translate('Email Address')}",
                    controller: emailController,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter Email ID';
                      }

                      if (!isValidEmail(input)) {
                        return 'Please Enter a Valid Email ID';
                      }
                    },
                    hint: "${lang?.translate('Enter your email')}"),
                SizedBox(height: 6),
                CommanTextField(
                    labelText: "${lang?.translate('Phone Number')}",
                    controller: numberController,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Enter a Password';
                      }

                      if (input.length < 6) {
                        return 'Please Enter 6 Digit Password';
                      }
                      return null;
                    },
                    hint: "${lang?.translate('Enter your phone no.')}"),
                SizedBox(height: 6),
                CommanTextField(
                    labelText: "${lang?.translate('Country')}",
                    hint: "${lang?.translate('Select country')}",
                    readOnly: true,
                    controller:contryController ,
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return 'Please Select Country';
                      }

                      return null;
                    },
                    suffixIcon: Icon(Icons.arrow_drop_down),
                    onTap: () {
                      // showCountryPicker(
                      //   context: context,
                      //   showPhoneCode: true,
                      //
                      //   // optional. Shows phone code before the country name.
                      //   onSelect: ( country) {
                      //     contryController.text = country.name;
                      //   },
                      // );
                      showCurrencyPickers(
                        context: context,
                        showFlag: true,
                        showCurrencyName: true,
                        showCurrencyCode: true,
                        onSelect: (Currencys currency) {
                          print('Select currency: ${currency.name}');
                          print('Select currency: ${currency.name}');
                          contryController.text = currency.name;

                        },
                      );
                    }),
                SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      final sp = context.read<AuthProvider>();
                      sp.userUpdate(
                          sp.userData!.id.toString(),
                          nameController.text,
                          emailController.text,
                          numberController.text,
                          contryController.text,
                          context)
                          .then((value) => authProvider.setSignIn());
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) =>
                    //           ForgetPassword("Change Password"),
                    //     ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: LinearGradient(
                        colors: [
                          primary,
                          primary2,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4C2E84).withOpacity(0.2),
                          offset: const Offset(0, 15.0),
                          blurRadius: 60.0,
                        ),
                      ],
                    ),
                    child: Text(
                      '${lang?.translate('Update')}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
