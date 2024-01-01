import 'package:flutter/material.dart';

class Received_Payments extends StatefulWidget {
  const Received_Payments({super.key});

  @override
  State<Received_Payments> createState() => _Received_PaymentsState();
}

class _Received_PaymentsState extends State<Received_Payments> {
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
              'Received Payments',
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
