import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:kiosk/const.dart';

class GBPrimePayQRCode extends StatelessWidget {
  const GBPrimePayQRCode({
    super.key,
    required this.referenceNo,
    required this.backgroundUrl,
    required this.amount,
    required this.token,
    required this.detail,
  });

  final String referenceNo;
  final double amount;
  final String token;
  final String backgroundUrl;
  final String detail;

  // request QRCode payment
  Future<Uint8List?> getGBPrimePayQRCode() async {
    var map = <String, dynamic>{};
    map['token'] = token;
    map['backgroundUrl'] = backgroundUrl;
    map['referenceNo'] = referenceNo;
    map['amount'] = '$amount';
    map['detail'] = detail;

    try {
      http.Response response = await http.post(Uri.parse(apiEndpoint), body: map);
      log('status code = ${response.statusCode}');
      log('referenceNo = ${referenceNo}');
      if (response.statusCode == 200) {
        //log('bodyBytes = ${response.bodyBytes}');
        return response.bodyBytes;
      } else {
        return null;
      }
    } catch (e) {
      log('$e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: FutureBuilder(
          future: getGBPrimePayQRCode(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const Text("Cannot load QRCode");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (snapshot.data == null) {
              return const Text("Cannot load QRCode");
            }

            // use stream to check recieve payment
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("payments").doc(referenceNo).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> paymentSnapshot) {
                  if (paymentSnapshot.hasError) {
                    return const Center(
                      child: Icon(Icons.error),
                    );
                  }

                  if (paymentSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }

                  final payment = paymentSnapshot.data;
                  if (payment!.exists != false) {
                    // has payment data show message
                    log("has payment data");
                    final doc = paymentSnapshot.data;
                    log('$doc');
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text("Payment recieved!"),
                            Text("Thank You"),
                          ],
                        ),
                      ),
                    );
                  } else {
                    // no payment data show QR Code
                    log("no payment data");
                    return Image.memory(snapshot.data);
                  }
                },
              ),
              //child:
            );
          },
        ),
      ),
    );
  }
}
