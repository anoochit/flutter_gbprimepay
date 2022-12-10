import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kiosk/app/data/sample/product_sample.dart';
import 'package:kiosk/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:kiosk/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final checkoutController = Get.find<CheckoutController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beer Kiosk'),
        centerTitle: true,
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: listProduct.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            elevation: 0.0,
            child: InkWell(
              onTap: () {
                checkoutController.product.value = listProduct[index];
                checkoutController.update();
                Get.toNamed(Routes.CHECKOUT);
              },
              child: GridTile(
                child: Stack(children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Image.network(
                        listProduct[index].image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          listProduct[index].title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${listProduct[index].price} THB',
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                color: Colors.green,
                              ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
