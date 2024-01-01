// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/Agent/Screen/Kyc%20Flow/passport_verifiction.dart';
import 'package:ceyron_app/Api/Controller/kyc_provider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../Api/Controller/auth_provider.dart';
import '../../../Api/Controller/local_stuff.dart';
import '../../../Api/Controller/transaction_provider.dart';
import '../../../utils/colors.dart';
import '../../../utils/next_screen.dart';
import '../../../utils/widgets.dart';
import '../../AppBar/appbar.dart';
import 'driving_verifiction.dart';
import 'national_card_verifction.dart';

class DetailsFill extends StatefulWidget {
  const DetailsFill({super.key});

  @override
  State<DetailsFill> createState() => _DetailsFillState();
}

class _DetailsFillState extends State<DetailsFill> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () {
      final sp = context.read<AuthProvider>();
      final ts = context.read<TransactionProvider>();
      nameController.text = sp.userData!.name;
      emailController.text = sp.userData!.email;
      countryController.text = sp.userData!.country;

    });

  }
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    double size = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: CustomAppBar(title: "${lang?.translate('Your Details')}"),
       body: SingleChildScrollView(
         child: Column(children: [
           buildCard(size),
         ],),
       ),
    );
  }
  Widget buildCard(double size) {
    var lang = LocalizationStuff.of(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Authtextfeild(
                titletext: "${lang?.translate('Your Name')}",
                hintText: "${lang?.translate('Enter your name')}",
                controller: nameController,
                textSize: 15.toDouble(),
                color: Colors.grey.shade200,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate('Please Enter Name')}';
                  }
                },
                icon: Icons.supervised_user_circle_outlined),
            SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate('Email')}",
                hintText: "${lang?.translate('Enter your email')}",
                controller: emailController,
                color: Colors.grey.shade200,
                textSize: 15.toDouble(),
                TextInputTypes: TextInputType.emailAddress,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate('Please Enter Email ID')}';
                  }

                  if (!isValidEmail(input)) {
                    return '${lang?.translate('Please Enter a Valid Email ID')}';
                  }
                },
                icon: Icons.mail_outline),
            const SizedBox(
              height: 10,
            ),
            Authtextfeild(
              titletext: "${lang?.translate('Date of Birth')}",
              hintText: "${lang?.translate('Enter your birth date')}",
              color: Colors.grey.shade200,
              controller: birthDateController,
              textSize: 15.toDouble(),
              ontap: () async {
                FocusScope.of(context).requestFocus(FocusNode()); // Close keyboard
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                  birthDateController.text = formattedDate;
                }
              },
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return '${lang?.translate('Please Enter Your Birth Date')}';
                } else {
                  DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(input);
                  DateTime currentDate = DateTime.now();
                  DateTime eighteenYearsAgo = currentDate.subtract(Duration(days: 18 * 365));

                  if (selectedDate.isAfter(eighteenYearsAgo)) {
                    return '${lang?.translate('You must be at least 18 years old')}';
                  }
                }
                return null;
              },
              icon: Icons.date_range,
            ),
            const SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate('Address')}",
                hintText: "${lang?.translate('Enter your address')}",
                controller: addressController,
                color: Colors.grey.shade200,
                textSize: 15.toDouble(),
                Maxline: 1,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate('Please Enter Address')}';
                  }
                },
                icon: Icons.location_on_outlined),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Authtextfeild(
                      titletext: "${lang?.translate('City')}",
                      hintText: "${lang?.translate('Enter your city')}",
                      color: Colors.grey.shade200,
                      controller: cityController,
                      textSize: 15.toDouble(),
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return '${lang?.translate('Please Enter City Name')}';
                        }
                      },),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Authtextfeild(
                      titletext: "${lang?.translate('Zip Code')}",
                      hintText: "${lang?.translate('Enter zipcode')}",
                      color: Colors.grey.shade200,
                      controller: zipController,
                      textSize: 15.toDouble(),
                    TextInputTypes: TextInputType.number,
                    inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (input) {
                        if (input == null || input.isEmpty) {
                          return '${lang?.translate('Please Enter ZipCod')}';
                        }
                        if (input.length != 6 ||
                            int.tryParse(input) == null) {
                          return '${lang?.translate('Please Enter Valid 6-digit ZipCod')}';
                        }
                      },),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate('State')}",
                hintText: "${lang?.translate('Enter your state')}",
                controller: stateController,
                textSize: 15.toDouble(),
                color: Colors.grey.shade200,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate('Please Enter State')}';
                  }
                },
                icon: Icons.supervised_user_circle_outlined),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                '${lang?.translate('Country')}',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
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
                          // validator: validator,
                          cursorColor: const Color(0xFF151624),
                          readOnly: true,
                          validator: (input) {
                            if (input == null || input.isEmpty) {
                              return '${lang?.translate('Please Select Country')}';
                            }
                            return null;
                          },
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              // optional. Shows phone code before the country name.
                              onSelect: (country) {
                                setState(() {
                                  countryController.text = country.name;
                                });
                              },
                            );
                          },
                          decoration: InputDecoration(
                            hintText: "${lang?.translate('Select Country')}",
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
            ],),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {

                 if (_formKey.currentState!.validate()) {
                  final KP = context.read<KycProvider>();
                  final Au = context.read<AuthProvider>();
                  KP.full_name =  nameController.text;
                  KP.agentId =  Au.userData?.id;
                  KP.address =  addressController.text;
                  KP.country =  countryController.text;
                  KP.dob =  birthDateController.text;
                  KP.email =  emailController.text;
                  KP.state =  stateController.text;
                  KP.zip_code =  zipController.text;
                  KP.city =  cityController.text;
                  _showBottomSheet(context);
                 }
                // Navigator.pushNamed(context, 'MyBottomBarApp');
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
                  '${lang?.translate('Choose document')}',
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
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 40,),
              Text(
                '${lang?.translate('Choose Document Type')}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Text('${lang?.translate('Make sure the document includes a picture of your face.')}',textAlign: TextAlign.center,style: TextStyle(fontSize: 17),),
              SizedBox(height: 35.0),
              InkWell(
                onTap: (){
                  nextScreen(context, VerifyPassport());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                          color:Colors.grey.shade300,blurRadius: 7
                      )]
                  ),
                  child: Row(children: [
                    Image.asset('assets/icon/icon 1.png',scale: 5,),
                    SizedBox(width: 12,),
                    Text("${lang?.translate('Passport')}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],),
                ),
              ),
              SizedBox(height: 13.0),
              InkWell(
                onTap: (){
                  nextScreen(context, VerifyNationalCard());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                          color:Colors.grey.shade300,blurRadius: 7
                      )]
                  ),
                  child: Row(children: [
                    Image.asset('assets/icon/icon 2.png',scale: 5,),
                    SizedBox(width: 12,),
                    Text("${lang?.translate('National Card')}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],),
                ),
              ),
              SizedBox(height: 13.0),
              InkWell(
                onTap: (){
                  nextScreen(context, VerifyDriving());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                          color:Colors.grey.shade300,blurRadius: 7
                      )]
                  ),
                  child: Row(children: [
                    Image.asset('assets/icon/icon 3.png',scale: 5,),
                    SizedBox(width: 12,),
                    Text("${lang?.translate('Driving License')}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],),
                ),
              ),
              SizedBox(height: 90.0),

            ],
          ),
        );
      },
    );
  }
}
