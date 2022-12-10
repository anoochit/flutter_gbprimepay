import 'package:get/get.dart';
import 'package:kiosk/app/modules/checkout/controllers/checkout_controller.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CheckoutController());
  }
}
