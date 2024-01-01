// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../Api/Controller/getx_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/next_screen.dart';

class SendMoneyCard extends StatefulWidget {
  const SendMoneyCard({super.key});

  @override
  State<SendMoneyCard> createState() => _SendMoneyCardState();
}

class _SendMoneyCardState extends State<SendMoneyCard> {
  bool _isChecked = false;
  GetController getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
            SizedBox(
              width: 5,
            ),
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage('assets/image/user.png'))),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Send Money To Card',
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
            Spacer(),
            Image.asset(
              'assets/icon/notifiction.png',
              scale: 20,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'KYC',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "My Prepaid Card List",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => Container(
                  height: 55,
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 5)
                      ]),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icon/atmcard.png',
                        scale: 12,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '**********3050',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Prepaid Card',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Spacer(),
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Find Receoient Prapaid Card",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                // padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        color: primary.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ],
                ),
                child: IntlPhoneField(
                  dropdownDecoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  dropdownTextStyle: TextStyle(color: Colors.white),
                  dropdownIcon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  ),
                  dropdownIconPosition: IconPosition.trailing,
                  decoration: InputDecoration(
                    // contentPadding: EdgeInsets.zero,
                    //decoration for Input Field
                    hintText: '  Enter your phone', counterText: "",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter phone number';
                    }
                    return null;
                  },
                  initialCountryCode: 'IN',
                )),
            SizedBox(
              height: 30,
            ),
            Text(
              "Available Recepient Prepaid Card",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Container(
                  height: 55,
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade400, blurRadius: 5)
                      ]),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icon/atmcard.png',
                        scale: 12,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '**********3050',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Prepaid Card',
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Spacer(),
                      Checkbox(
                        value: _isChecked,
                        onChanged: (value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                comContainer(context, 45.toDouble(), 200.toDouble(), 'Send'),
              ],
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
