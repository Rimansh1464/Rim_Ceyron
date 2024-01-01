import 'package:flutter/material.dart';

class Add_Bank_Account extends StatefulWidget {
  const Add_Bank_Account({super.key});

  @override
  State<Add_Bank_Account> createState() => _Add_Bank_AccountState();
}

class _Add_Bank_AccountState extends State<Add_Bank_Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Row(
          children: [
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
              'Add Bank Account',
              style: TextStyle(color: Colors.black, fontSize: 16),
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
    );
  }
}
