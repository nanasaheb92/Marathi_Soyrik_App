import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/constants/constants_assets.dart';
import 'package:matrimony/app/screens/auth/controller/auth_controller.dart';
import 'package:matrimony/common/color_pallete.dart';

import '../../../routes/app_routes.dart';
import '../../settings/views/contact_us_screen.dart';

class OnboardingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.primary,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.BACKGROUND),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xffe92054).withOpacity(0.6),
                  const Color(0xff4d1d68).withOpacity(0.9),
                  const Color(0xff4d1d68).withOpacity(0.9),
                ],
                stops: const [0, 0.3, 1],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        Assets.LOGO,
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      margin: EdgeInsets.all(16.0),
                      shadowColor: Colors.blueGrey,
                      // Shadow color
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  Routes.LOGIN
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Text(
                                    ">",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              thickness: 0.5, // Adjust the thickness of the line
                              color: Colors.grey, // Change the color of the line
                              indent: 0, // Space on the left side
                              endIndent: 0, // Space on the right side
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.put(AuthController());
                                Get.toNamed(
                                  Routes.VERIFY_MOBILE
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Register",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Text(
                                    ">",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              thickness: 0.5, // Adjust the thickness of the line
                              color: Colors.grey, // Change the color of the line
                              indent: 0, // Space on the left side
                              endIndent: 0, // Space on the right side
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ContactUsScreen();
                                    },
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Contact us",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Text(
                                    ">",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              thickness: 0.5, // Adjust the thickness of the line
                              color: Colors.grey, // Change the color of the line
                              indent: 0, // Space on the left side
                              endIndent: 0, // Space on the right side
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                    Routes.ABOUT_US
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "About us",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Text(
                                    ">",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Divider(
                              thickness: 0.5, // Adjust the thickness of the line
                              color: Colors.grey, // Change the color of the line
                              indent: 0, // Space on the left side
                              endIndent: 0, // Space on the right side
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                    Routes.PRIVACY_POLICY
                                );
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Privacy Policy",
                                      style: TextStyle(color: Colors.black, fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(height: 0),
                                  Text(
                                    ">",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
