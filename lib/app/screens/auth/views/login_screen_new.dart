import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:otpless_flutter/otpless_flutter.dart';

import '../../../../common/color_pallete.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../../routes/app_routes.dart';
import '../controller/auth_controller.dart';

import '../../../../../../../common/transalations/translation_keys.dart'
    as translations;

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // double baseWidth = 360;
    // double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Stack(
            children: [
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.pink,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(ColorPallete.theme),
                        strokeWidth: 5.0,
                      ),
                    ),
                  ),
                ),
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/images/bg.jpeg",
                    ),
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: ColorPallete.grey.withOpacity(0.5),
                    //     spreadRadius: 5,
                    //     blurRadius: 10,
                    //   )
                    // ],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xffe92054).withOpacity(0.6),
                        Color(0xff4d1d68).withOpacity(0.9),
                        Color(0xff4d1d68).withOpacity(0.9)
                      ],
                      stops: [0, 0.3, 1],
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          // Logo Section
                          ClipOval(
                            child: Image.asset(
                              "assets/ui/logo.jpeg",
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Mobile Number Login Section
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: ColorPallete.theme),
                            ),
                          ),
                          const SizedBox(height: 20),
                          /*Row(
                        children: [
                          */ /*Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              value: '(IN) +91',
                              items: ['(IN) +91', '(US) +1'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {},
                            ),
                          ),
                          const SizedBox(width: 10),*/ /*
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mobile Number*',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: () {},
                          child: const Text('Login with OTP'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Or'),
                      const SizedBox(height: 20),*/
                          // Email and Password Login Section
                          TextFormField(
                            style: const TextStyle(
                                color: ColorPallete.theme),
                            cursorColor: ColorPallete.theme,
                            decoration:
                            InputDecoration().copyWith(
                              labelText:
                              translations.phoneNumber.tr,
                              labelStyle: const TextStyle(
                                  fontSize: 16,
                                  color: ColorPallete.theme),
                              enabledBorder:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    ColorPallete.theme),
                              ),
                              focusedBorder:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    ColorPallete.theme),
                              ),
                              border:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    ColorPallete.theme),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter text';
                              }
                              if (value.length < 6) {
                                return 'Password should be at least 6 characters long';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              controller.creds["mobile_number"] = value;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            obscureText: controller.showPassword.value,
                            style: const TextStyle(
                                color: ColorPallete.theme),
                            cursorColor: ColorPallete.theme,
                            decoration:
                            InputDecoration().copyWith(
                              labelText:
                              translations.password.tr,
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    !controller.showPassword
                                        .value
                                        ? Icons.visibility
                                        : Icons
                                        .visibility_off,
                                    color: ColorPallete.theme,
                                  ),
                                  onPressed: () {
                                    controller.showPassword
                                        .value =
                                    !controller
                                        .showPassword
                                        .value;
                                  }),
                              labelStyle: const TextStyle(
                                  fontSize: 16,
                                  color: ColorPallete.theme),
                              enabledBorder:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    ColorPallete.theme),
                              ),
                              focusedBorder:
                              const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                    ColorPallete.theme),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter text';
                              }
                              if (value.length < 6) {
                                return 'Password should be at least 6 characters long';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              controller.creds["password"] = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(Routes.FORGOT_PASSWORD);
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Login Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pink,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Adjust the radius value here
                                ),
                              ),
                              onPressed: () {
                                controller.signIn();
                                //controller.headlessOtplessInitiate(controller.creds["mobile_number"], onHeadlessResult);

                                controller.errorMessage.value == ""
                                    ? ""
                                    : Fluttertoast.showToast(
                                        msg: controller.errorMessage.value,
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Sign Up Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'New User?',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: ColorPallete.theme),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(Routes.VERIFY_MOBILE);
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onHeadlessResult(dynamic result) {
    if (result['statusCode'] == 200) {
      switch (result['responseType'] as String) {
        case 'INITIATE':
          {
            print("INItiate $result");
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
          }
          break;
      }
    } else {
      print("not 200 $result");

    }
  }


  void otplessLogin() {
    final _otplessFlutterPlugin = Otpless();
    var arg = {
      'appId': 'jxpihpm4bat6dfc1xzct',
      'deliveryChannel': 'SMS'
    };

    _otplessFlutterPlugin.openLoginPage((result) {
      var message = "";
      if (result['data'] != null) {
        final token = result['response']['token'];
        message = "token: $token";
      } else {
        message = result['errorMessage'];
      }
    }, arg);

  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ColorPallete.primary;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.10);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.50);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
