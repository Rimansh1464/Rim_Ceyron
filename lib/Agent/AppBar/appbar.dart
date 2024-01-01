// ignore_for_file: prefer_const_constructors

import 'package:ceyron_app/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Api/Controller/local_stuff.dart';
import '../../Api/Controller/transaction_provider.dart';
import '../../User/Screen/pdf/show_all_adf.dart';
import '../../utils/colors.dart';
import '../../utils/widgets.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});
  @override
  Size get preferredSize => Size.fromHeight(110); // Define the preferred height of your custom app bar

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary2, primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 53),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar2({required this.title});
  @override
  Size get preferredSize => Size.fromHeight(110); // Define the preferred height of your custom app bar

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary2, primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Add other widgets or content as needed
          ],
        ),
      ),
    );
  }
}

class CustomAppBar3 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool arrow;

  CustomAppBar3({required this.title,required this.arrow});
  @override
  Size get preferredSize => Size.fromHeight(110); // Define the preferred height of your custom app bar

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary2, primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 53),
            Row(
              children: [
                arrow ?
                 InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ):SizedBox(),
                arrow ?SizedBox(width: 15):SizedBox(),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Add other widgets or content as needed
          ],
        ),
      ),
    );
  }
}

class CustomAppBar4 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar4({required this.title});
  @override
  Size get preferredSize => Size.fromHeight(110); // Define the preferred height of your custom app bar
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var lang = LocalizationStuff.of(context);
    TransactionProvider Tr = Provider.of<TransactionProvider>(context,listen: false);

    return Container(
      height: 105,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary2, primary],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                PopupMenuButton<String>(
                  icon: Image.asset(
                    "assets/icon/ic_menu.png",
                    scale: 15,
                    color: Colors.white,
                  ),
                  onSelected: (value) {
                    // Handle the selected menu item
                    if (value == 'item1') {
                      nextScreen(context, ShowAllPDF());
                    } else if (value == 'item2') {
                      startController.clear();
                      endController.clear();
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${lang?.translate('Statement')}"),
                          ],
                        ),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Authtextfeild(
                                titletext: "${lang?.translate('Start Date')}",
                                hintText: "${lang?.translate('Select Start Date')}",
                                color: Colors.grey.shade200,
                                controller: startController,
                                textSize: 15.toDouble(),
                                ontap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode()); // Close keyboard
                                  DateTime selectedDate = DateTime.now();

                                  final yesterday = selectedDate.subtract(Duration(days: 1));
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: yesterday,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    startController.text = formattedDate;
                                  }
                                },
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return '${lang?.translate('Please Enter Start Date')}';
                                  }
                                  return null;
                                },
                                icon: Icons.date_range,
                              ),
                              SizedBox(height: 10,),
                              Authtextfeild(
                                titletext: "${lang?.translate('End Date')}",
                                hintText: "${lang?.translate('Select End Date')}",
                                color: Colors.grey.shade200,
                                controller: endController,
                                textSize: 15.toDouble(),
                                ontap: () async {
                                  FocusScope.of(context).requestFocus(FocusNode()); // Close keyboard
                                  DateTime selectedDate = DateTime.now();

                                  final yesterday = selectedDate.subtract(Duration(days: 1));

                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: yesterday,
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                                    endController.text = formattedDate;
                                  }
                                },
                                validator: (input) {
                                  if (input == null || input.isEmpty) {
                                    return '${lang?.translate('Please Enter End Date')}';
                                  }
                                  return null;
                                },
                                icon: Icons.date_range,
                              ),
                              SizedBox(height: 40,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 100,
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
                                            color: const Color(0xFF4C2E84)
                                                .withOpacity(0.2),
                                            offset: const Offset(0, 15.0),
                                            blurRadius: 60.0,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '${lang?.translate("Cancel")}',
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
                                  InkWell(
                                    onTap: () {
                                      if (_formKey.currentState!.validate()) {
                                        Tr.onTaps(startController.text, endController.text, context);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      width: 100,
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
                                            color: const Color(0xFF4C2E84)
                                                .withOpacity(0.2),
                                            offset: const Offset(0, 15.0),
                                            blurRadius: 60.0,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '${lang?.translate("Download")}',
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
                                ],
                              ),
                            ],),
                        ),
                      ));
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'item1',
                        child: Text('${lang?.translate('View All Statement')}'),

                      ),
                      PopupMenuItem<String>(
                        value: 'item2',
                        child: Text('${lang?.translate('Download Statement')}'),
                      ),
                    ];
                  },
                ),
              ],
            ),

            // Add other widgets or content as needed
          ],
        ),
      ),
    );
  }
}