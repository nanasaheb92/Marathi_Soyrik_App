import 'package:get/get.dart';

import '../controllers/home_feeds_controller.dart';

class HomeFeedsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeFeedsController>(HomeFeedsController());
  }
}
