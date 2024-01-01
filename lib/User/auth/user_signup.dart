import 'package:ceyron_app/utils/widgets.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/auth_provider.dart';
import '../../Api/Controller/local_stuff.dart';
import '../../Api/currency_picker.dart';
import '../../Api/src/currency.dart';
import '../../utils/colors.dart';

class User_Signup extends StatefulWidget {
  const User_Signup({super.key});

  @override
  State<User_Signup> createState() => _User_SignupState();
}

class _User_SignupState extends State<User_Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cpasswordController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _obscureText1 = true;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.height;
    var lang = LocalizationStuff.of(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary,
                      primary2,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/icon/AppLogo.png",
                          scale: 2.5,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 280,
                        height: 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ],
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 320,
                        alignment: Alignment.center,
                        child: buildCard(size * 0.75),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                  SizedBox(height: 25)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(double size) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    var lang = LocalizationStuff.of(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 35,
                height: 4.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "${lang?.translate("User Sign up")}",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              "${lang?.translate("Let’s sign up for explore continues")}",
              style:
                  TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.5)),
            ),
            SizedBox(
              height: 20,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Your Name")}",
                hintText: "${lang?.translate("Enter your name")}",
                controller: nameController,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please Enter Name")}';
                  }
                },
                icon: Icons.supervised_user_circle_outlined),
            SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Email Address")}",
                hintText: "${lang?.translate("Enter your email")}",
                controller: emailController,
                TextInputTypes: TextInputType.emailAddress,

                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please Enter Email ID")}';
                  }

                  if (!isValidEmail(input)) {
                    return '${lang?.translate("Please Enter a Valid Email ID")}';
                  }
                },
                icon: Icons.mail_outline),
            SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Phone Number")}",
                hintText: "${lang?.translate("Enter your phone no")}",
                controller: phoneController,
                TextInputTypes: TextInputType.phone,
                inputFormatters:   [
                LengthLimitingTextInputFormatter(10),FilteringTextInputFormatter.digitsOnly,],
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please Enter a Number")}';
                  }

                  if (input.length < 10) {
                    return '${lang?.translate("Please Enter 10 Digit Number")}';
                  }
                  return null;
                },
                icon: Icons.phone_android),
            SizedBox(
              height: 10,
            ),
            Text(
              '${lang?.translate("Country")}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(248, 247, 251, 1),
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
                            return '${lang?.translate("Please Select Country")}';
                          }
                        },
                        cursorColor: const Color(0xFF151624),
                        readOnly: true,
                        onTap: () {
                          // showCountryPicker(
                          //   context: context,
                          //   showPhoneCode: true,
                          //   // optional. Shows phone code before the country name.
                          //   onSelect: (country) {
                          //     setState(() {
                          //       countryController.text = country.name;
                          //     });
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
                              countryController.text = currency.name;

                            },
                          );
                        },
                        decoration: InputDecoration(
                          hintText: "${lang?.translate("Select Country")}",
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
            SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Password")}",
                hintText: "${lang?.translate("Enter password")}",
                controller: passwordController,
                obscureTexts: _obscureText ,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle password visibility
                    });
                  },
                ),
                TextInputTypes: TextInputType.visiblePassword,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please enter a password")}';
                  }
                  if (input.length < 6) {
                    return '${lang?.translate("Please enter 6 digit password")}';
                  }


                  return null;
                },
                icon: Icons.lock_outline),
            SizedBox(
              height: 10,
            ),
            Authtextfeild(
                titletext: "${lang?.translate("Confirm Password")}",
                hintText: "${lang?.translate("Enter confirm password")}",
                controller: cpasswordController,
                obscureTexts: _obscureText1 ,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText1 ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText1 = !_obscureText1; // Toggle password visibility
                    });
                  },
                ),
                TextInputTypes: TextInputType.visiblePassword,
                validator: (input) {
                  if (input == null || input.isEmpty) {
                    return '${lang?.translate("Please enter a password")}';
                  }

                  if (input.length < 6) {
                    return '${lang?.translate("Please enter 6 digit password")}';
                  }
                  if (input != passwordController.text) {
                    return '${lang?.translate("Passwords do not match")}';
                  }

                  return null;
                },
                icon: Icons.lock_outline),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  authProvider
                      .userSignup(
                      nameController.text,
                      emailController.text,
                      phoneController.text,
                      passwordController.text,
                      cpasswordController.text,
                      countryController.text,
                      context);
                }
                // Navigator.pushNamed(context, 'MyBottomBarApp');
                // Navigator.pushNamed(context, 'KycUpload');
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
                  '${lang?.translate("Sign up")}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${lang?.translate("Already have an account?")}",
                        style: TextStyle(color: Colors.grey)),
                    TextSpan(
                        text: " ${lang?.translate("Log in")}",
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.w500)),
                  ])),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
