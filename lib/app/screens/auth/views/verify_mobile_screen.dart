import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:matrimony/app/constants/constants_assets.dart';
import 'package:matrimony/app/routes/app_routes.dart';

import '../../../../common/color_pallete.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../signup/widgets/form_fields.dart';
import '../controller/auth_controller.dart';

class VerifyMobileScreen extends GetView<AuthController> {
  const VerifyMobileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          color: ColorPallete.theme,
          child: Column(
            children: [
              RoundedContainer(
                radius: 0,
                height: 120,
                color: ColorPallete.primary,
                child: Stack(
                  children: [
                    Image.asset(
                      Assets.BACKGROUND,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xffe92054).withOpacity(0.6),
                            Color(0xffe92054).withOpacity(0.8),
                          ],
                          stops: [0, 0.5],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios,
                                        color: ColorPallete.theme,
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                            const Expanded(
                              child: RoundedContainer(
                                radius: 0,
                                child: Center(
                                  child: TextView(
                                    text: "SIGN UP",
                                    color: ColorPallete.theme,
                                    fontSize: 22,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
                child: Obx(() => Stack(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                      child: TextView(
                                        text: "MOBILE NO.",
                                        color: ColorPallete.secondary,
                                      ),
                                    ),
                                    MyFormField(
                                      fieldName: "Enter Mobile Number",
                                      initialValue: controller.user.value.mobile,
                                      showFieldName: false,
                                      type: InputType.TEXT,
                                      keyboard: TextInputType.phone,
                                      onChanged: (value) {
                                        controller.user.value.mobile = value;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 7.5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.headlessOtplessInitiate(controller.user.value.mobile!, onHeadlessResult);
                                          },
                                          child: const RoundedContainer(
                                            radius: 10,
                                            //height: 45,
                                            color: Colors.green,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                              child: TextView(
                                                text: "Verify Mobile",
                                                color: ColorPallete.theme,
                                                weight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7.5,
                                    )
                                  ],
                                ),
                            ),
                        if (controller.isLoading.value)
                          Container(
                              color: Colors.black.withOpacity(0.5),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorPallete.primary,
                                ),
                              ),
                            ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onHeadlessResult(dynamic result) {
    print("out $result");
    controller.isLoading.value = false;
    if (result['statusCode'] == 200) {
      switch (result['responseType'] as String) {
        case 'INITIATE':
          {
            print("INItiate $result");
            Get.showSnackbar(
              const GetSnackBar(
                duration: Duration(seconds: 2),
                message:
                "OTP Sent Successfully!",
              ),
            );
            Get.toNamed(Routes.VERIFY_OTP);
          }
          break;
        case 'VERIFY':
          {
            print("VERIFY $result");
            // notify that verification is completed
            // and this is notified just before "ONETAP" final response
          }
          break;
        case 'OTP_AUTO_READ':
          {
            print("OTP_AUTO_READ $result");
            if (Platform.isAndroid) {
              var otp = result['response']['otp'] as String;
            }
          }
          break;
        case 'ONETAP':
          {
            print("ONETAP $result");
            final token = result["response"]["token"];
            Get.showSnackbar(
              const GetSnackBar(
                duration: Duration(seconds: 2),
                message:
                "Mobile Verified Successfully!",
              ),
            );
            Get.toNamed(Routes.REGISTER);
          }
          break;
      }
    } else {
      print("not 200 $result");
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 2),
          message:
          result['response']['errorMessage'] as String,
        ),
      );
    }
  }
}
