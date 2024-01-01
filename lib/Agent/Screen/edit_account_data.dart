import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/currency_picker.dart';
import '../../Api/src/currency.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';
import '../AppBar/appbar.dart';

class EditAccountData extends StatefulWidget {
  const EditAccountData({super.key});

  @override
  State<EditAccountData> createState() => _EditAccountDataState();
}

class _EditAccountDataState extends State<EditAccountData> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthProvider sp = Provider.of<AuthProvider>(context, listen: false);

    getData(context, sp);
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController businessController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController contryController = TextEditingController();

  getData(context, sp) {
    // final sp = context.read<AuthProvider>();
    // AuthProvider sp = Provider.of<AuthProvider>(context);

    nameController.text = sp.userData!.name;
    businessController.text = sp.userData!.businessName;
    branchController.text =sp.userData!.branchName;
    emailController.text = sp.userData!.email;
    numberController.text = sp.userData!.phoneNumber;
    contryController.text = sp.userData!.country;
  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
        appBar: CustomAppBar(title: "${lang?.translate('Edit')}"),
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
                      readOnly: false,
                      hint: "${lang?.translate('Enter your name')}"),
                  SizedBox(height: 4),
                  CommanTextField(
                      labelText: "${lang?.translate('Business Name')}",
                      controller: businessController,
                      readOnly: false,
                      hint: "${lang?.translate('Enter business name')}"),
                  SizedBox(height: 4),
                  CommanTextField(
                      labelText: "${lang?.translate('Branch Name')}",
                      controller: branchController,
                      readOnly: false,
                      hint: "${lang?.translate('Enter branch name')}"),
                  SizedBox(height: 4),
                  CommanTextField(
                      labelText: "${lang?.translate('Email Address')}",
                      controller: emailController,
                      readOnly: true,
                      hint: "${lang?.translate('Enter your email')}"),
                  SizedBox(height: 4),
                  CommanTextField(
                      labelText: "${lang?.translate('Phone Number')}",
                      controller: numberController,
                      readOnly: false,
                      hint: "${lang?.translate('Enter your phone no.')}"),
                  SizedBox(height: 4),
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
                  InkWell(
                    onTap: () {
                      final sp = context.read<AuthProvider>();
                      sp
                          .agentUpdate(
                              sp.userData!.id,
                              nameController.text,
                              businessController.text,
                              branchController.text,
                              emailController.text,
                              numberController.text,
                          contryController.text,
                              context)
                          .then((value) => authProvider.setSignIn());
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
        ));
  }
}
