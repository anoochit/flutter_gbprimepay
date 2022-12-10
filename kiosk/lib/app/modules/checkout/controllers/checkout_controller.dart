import 'package:get/get.dart';
import 'package:kiosk/app/data/models/product_model.dart';

class CheckoutController extends GetxController {
  Rx<Product> product = Product(id: 0, title: "", price: 0, image: "").obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
