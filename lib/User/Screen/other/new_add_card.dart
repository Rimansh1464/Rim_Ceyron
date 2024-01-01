import 'package:ceyron_app/utils/widgets.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../utils/colors.dart';


class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
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
              'Add New Prepaid Card',
              style: TextStyle(color: Colors.black, fontSize: 15),
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
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "ADD NEW PREPAIED CARD",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CommanTextField(
                    labelText: "First Name", hint: "Enter First Name"),
              ),
              Expanded(
                  child: CommanTextField(
                      labelText: "Last Name", hint: "Enter Last Name")),
            ],
          ),
          SizedBox(height: 10),
          CommanTextField(labelText: "Email Address", hint: "Enter your email"),
          SizedBox(height: 10),
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
          SizedBox(height: 10),
          CommanTextField(labelText: "Address", hint: "Enter Address"),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: CommanTextField(labelText: "City", hint: "Enter city"),
              ),
              Expanded(
                  child: CommanTextField(labelText: "Zip", hint: "Enter zip")),
            ],
          ),
          SizedBox(height: 10),
          CommanTextField(
              labelText: "Country",
              readOnly: true,
              hint: "Selecte country",
              suffixIcon: Icon(Icons.arrow_drop_down),
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  // optional. Shows phone code before the country name.
                  onSelect: (Country country) {
                    print('Select country: ${country.name}');
                  },
                );
              }),
          SizedBox(height: 10),
          CommanTextField(
            labelText: "State",
            hint: "Enter state",
          ),
        ],
      ),
    );
  }
}
