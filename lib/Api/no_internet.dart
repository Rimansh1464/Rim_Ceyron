import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyConnectivity {
  MyConnectivity._internal();
  static final MyConnectivity _instance = MyConnectivity._internal();
  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();
  Stream get myStream => controller.stream;
  bool isShow = false;

  Future<void> initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    await _checkStatus(result);
    connectivity.onConnectivityChanged.listen(_checkStatus);
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // printLog("[MyConnectivity] online");
        isOnline = true;
      } else {
        // printLog("[MyConnectivity] offline");
        isOnline = false;
      }
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  bool isIssue(dynamic onData) =>
      onData.keys.toList()[0] == ConnectivityResult.none;

  void disposeStream() => controller.close();
}

Future<dynamic> showDialogNotInternet(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Container(
            height: 200,
            // width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            // padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Color(0xFFf65656),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 45,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("ERROR",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          )),
                      SizedBox(height: 8),
                      Text("NO AVAILABLE CONNECTION",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            color: Colors.black,
                            letterSpacing: 0.3,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          )),
                      // SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text("Connection could not be able to Reconnect",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black54,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
