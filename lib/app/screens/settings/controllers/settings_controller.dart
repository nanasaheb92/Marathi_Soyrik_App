import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/color_pallete.dart';
import '../../../models/api_response.dart';
import '../../../models/my_package_details.dart';
import '../../../models/package_model.dart';
import '../../../models/success_story_model.dart';
import '../../../repositories/settings_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/phonepe_gateway_service.dart';

class SettingsController extends GetxController {
  late SettingsRepository _settingsRepository;
  SettingsController() {
    _settingsRepository = SettingsRepository();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    fetchPackages();
  }

  RxInt selectedPage = 1.obs;

  RxList<Package> packages = <Package>[].obs;

  void fetchPackages() async {
    await _settingsRepository.fetchPackages().then((value) {
      if (value.status == Status.COMPLETED) {
        packages.value = value.data;
      }
    });
  }

  RxBool isPaymentLoading = false.obs;

  /// 1. server creates signed PhonePe request  (phonepe_initiate.php)
  /// 2. PhonePe SDK opens the payment page

  Future<void> makePayment(BuildContext context, Package package) async {
    if (isPaymentLoading.value) return;
    isPaymentLoading.value = true;
    try {
      final init = await _settingsRepository
          .initiatePhonePePayment(package.packId ?? package.id ?? "");
      if (init.status != Status.COMPLETED) {
        _showPaymentMessage(init.message ?? "Payment initiation failed", false);
        return;
      }
      final data = init.data["data"];
      final String transactionId = data["transaction_id"].toString();

      final sdkStatus = await PhonePePG.getInstance.startTransaction(
        env: data["env"].toString(),
        merchantId: data["merchant_id"].toString(),
        body: data["body"].toString(),
        checksum: data["checksum"].toString(),
        callbackUrl: data["callback_url"].toString(),
      );
      if (sdkStatus == "INTERRUPTED") {
        _showPaymentMessage("Payment cancelled", false);
        return;
      }
      if (sdkStatus == "INIT_FAILED" || sdkStatus.startsWith("ERROR")) {
        _showPaymentMessage("Could not open PhonePe ($sdkStatus)", false);
        return;
      }

      // Never trust the SDK result alone - ask the server.
      final status =
          await _settingsRepository.checkPhonePeStatus(transactionId);
      final String state = status.status == Status.COMPLETED
          ? status.data["data"]["state"].toString()
          : "FAILED";

      if (state == "COMPLETED") {
        _showPaymentMessage("Payment successful. Package activated!", true);
        fetchMyPackage();
        Get.offAllNamed(Routes.HOME);
        Get.toNamed(Routes.MY_PACKAGE);
      } else if (state == "PENDING" && sdkStatus != "FAILURE") {
        _showPaymentMessage(
            "Payment is pending. Your package will be activated once confirmed.",
            false);
      } else {
        _showPaymentMessage("Payment failed. Please try again.", false);
      }
    } finally {
      isPaymentLoading.value = false;
    }
  }

  void _showPaymentMessage(String message, bool success) {
    Get.showSnackbar(GetSnackBar(
      backgroundColor: success ? ColorPallete.primary : ColorPallete.red,
      duration: const Duration(seconds: 3),
      message: message,
    ));
  }

  RxBool isLoading = false.obs;
  RxBool isMyPackageLoading = false.obs;
  RxList<SuccessStory> successStories = <SuccessStory>[].obs;

  void getSuccessStories() async {
    isLoading.value = true;
    await _settingsRepository.getSuccessStories().then((value) {
      isLoading.value = false;
      if (value.status == Status.COMPLETED) {
        successStories.value = value.data;
        successStories.refresh();
      }
    });
  }

  Rx<MyPackageDetails> myPackage = MyPackageDetails().obs;

  void fetchMyPackage() async {
    isMyPackageLoading.value = true;
    await _settingsRepository.fetchMyPackage().then((value) {
      if (value.status == Status.COMPLETED) {
        myPackage.value = value.data;
        myPackage.refresh();
      }
      isMyPackageLoading.value = false;
    });
  }
}
