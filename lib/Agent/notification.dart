import 'package:flutter/material.dart';

import 'AppBar/appbar.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
      ),
      body: Center(
        child: Text("No notifications"),
      ),
    );
  }
}
