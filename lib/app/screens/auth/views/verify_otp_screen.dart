import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/constants/constants_assets.dart';
import 'package:matrimony/app/routes/app_routes.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

import '../../../../common/color_pallete.dart';
import '../../../../common/utils.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../controller/auth_controller.dart';

class VerifyOTPScreen extends GetView<AuthController> {
   VerifyOTPScreen({super.key});

  //OtpFieldController otpFieldController = Get.put(OtpFieldController());

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPallete.theme,
        resizeToAvoidBottomInset: true,
        body: Column(children: [
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
            child: Obx(
              () => Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0 * fem, vertical: 20 * fem),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/ui/otp2.png",
                            height: MediaQuery.of(context).size.height * 0.30,
                          ),
                          SizedBox(
                            height: 20 * fem,
                          ),
                          const Center(
                            child: TextView(
                              text: "A 6-Digit OTP set to you phone number please enter otp to verify your phone number",
                              color: ColorPallete.secondary,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 20 * fem,
                          ),
                          RoundedContainer(
                            radius: 0,
                            // height: 50,
                            child: OTPTextField(
                              //controller: otpFieldController,
                              length: 6,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: 50 * fem,
                              style: SafeGoogleFont(
                                'Roboto',
                                fontSize: 25 * ffem,
                                fontWeight: FontWeight.w500,
                                height: 1.5 * ffem / fem,
                                letterSpacing: -0.349999994 * fem,
                                color: ColorPallete.secondary,
                              ),
                              contentPadding: EdgeInsets.all(15 * fem),
                              // obscureText: true,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.box,
                              otpFieldStyle: OtpFieldStyle(
                                borderColor: ColorPallete.greyContainer,
                                enabledBorderColor: ColorPallete.greyContainer,
                                backgroundColor: ColorPallete.greyContainer,
                                focusBorderColor: ColorPallete.greyContainer,
                              ),
                              onCompleted: (pin) {
                                controller.creds["otp"] = pin;
                              },
                              onChanged: (value) {
                                controller.creds["otp"] = value.length > 5 ? value : "";
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20 * fem,
                          ),
                          InkWell(
                            onTap: () {
                              controller.headlessOtplessVerifyOtp(controller.creds["otp"], onHeadlessResult);
                              // if (!controller.isLoading.value)
                              //   controller.verifyOTP();
                            },
                            child: RoundedContainer(
                              radius: 10,
                              height: 50,
                              color: ColorPallete.primary,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0 * fem),
                                child: const Center(
                                  child: TextView(
                                    text: "Verify OTP",
                                    fontSize: 16,
                                    color: ColorPallete.theme,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              ),
            ),
          ),
        ]),
      ),
    );
  }

  void onHeadlessResult(dynamic result) {
    controller.isLoading.value = false;
    if (result['statusCode'] == 200) {
      switch (result['responseType'] as String) {
        case 'INITIATE':
          {
            print("INItiateotp $result");
          }
          break;
        case 'VERIFY':
          {
            print("VERIFYotp $result");
            // notify that verification is completed
            // and this is notified just before "ONETAP" final response
          }
          break;
        case 'OTP_AUTO_READ':
          {
            print("OTP_AUTO_READotp $result");
            if (Platform.isAndroid) {
              var otp = result['response']['otp'] as String;
              //otpFieldController.set(otp.split(""));
              //controller.headlessOtplessVerifyOtp(controller.creds["otp"], onHeadlessResult);
            }
          }
          break;
        case 'ONETAP':
          {
            print("ONETAPotp $result");
            final token = result["response"]["token"];
            Get.showSnackbar(
              const GetSnackBar(
                duration: Duration(seconds: 2),
                message: "OTP Verified Successfully!",
              ),
            );
            Get.offNamed(Routes.REGISTER);
          }
          break;
      }
    } else {
      print("not 200otp $result");
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 2),
          message: result['response']['errorMessage'] as String,
        ),
      );
    }
  }
}
