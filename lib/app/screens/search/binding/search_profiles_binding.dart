import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_profiles_controller.dart';

class SearchProfilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchProfilesController>(() => SearchProfilesController());
  }
}
