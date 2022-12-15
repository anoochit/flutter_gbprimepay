import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kiosk/app/modules/checkout/views/gbprimepay.dart';

import '../controllers/checkout_controller.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            // image
            SizedBox(
              width: 120,
              child: Image.network(controller.product.value.image),
            ),

            // title
            Text(
              controller.product.value.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 32.0),

            // pay button
            ElevatedButton.icon(
              onPressed: () {
                // create timestamp as referenceId
                final referenceNo = DateTime.now().millisecondsSinceEpoch.toString();
                final amount = controller.product.value.price;

                Get.dialog(
                  GBPrimePayQRCode(
                    referenceNo: referenceNo,
                    detail: controller.product.value.title,
                    amount: amount,
                    backgroundUrl: dotenv.env['BACKGROUND_URL'] ?? "",
                    token: dotenv.env['GB_TOKEN'] ?? "",
                  ),
                  useSafeArea: true,
                );
              },
              icon: const Icon(Icons.qr_code_2),
              label: Text('QRPayment = ${controller.product.value.price} THB'),
            )
          ],
        ),
      ),
    );
  }
}
