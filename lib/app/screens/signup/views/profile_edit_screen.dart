import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/text_view.dart';
import 'package:matrimony/app/constants/constants_brand_details.dart';
import 'package:matrimony/app/routes/app_routes.dart';
import 'package:matrimony/app/screens/policy/views/webview_screen.dart';
import '../../../../common/color_pallete.dart';

class ProfileEditScreen extends StatelessWidget {
  const ProfileEditScreen({super.key});


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
              image: AssetImage(
                "assets/images/bg.jpeg",
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: ColorPallete.linearGradientBg,
                stops: const [0, 0.3, 1],
              ),
            ),
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Image.asset(
                        "assets/ui/logo.png",
                        height: 150,
                      ),*/
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: TextView(
                            text:
                            "UPDATE PROFILE",
                            color: ColorPallete.theme,
                            fontSize: 22,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                                  Get.toNamed(Routes.PROFILE_SETTINGS, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Profile Settings",
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
                      SizedBox(
                        height: 15,
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
                                  Get.toNamed(Routes.BASIC_DETAILS_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Personal Details",
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
                                  Get.toNamed(Routes.RELIGIOUS_DETAILS_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Religious Details",
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
                                  Get.toNamed(Routes.EDUCATION_DETAILS_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Education Details",
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
                                  Get.toNamed(Routes.LIFESTYLE_DETAILS_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Lifestyle Details",
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
                                  Get.toNamed(Routes.LOCATION_DETAILS_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Location Details",
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
                                  Get.toNamed(Routes.FAMILY_DETAILS_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Family Details",
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
                          /*    Divider(
                                thickness: 0.5, // Adjust the thickness of the line
                                color: Colors.grey, // Change the color of the line
                                indent: 0, // Space on the left side
                                endIndent: 0, // Space on the right side
                              ),
                              SizedBox(
                                height: 15.0,
                              ),*/
                             /* GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.UPLOAD_DOCS, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Upload Photos",
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
                              ),*/
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                                  Get.toNamed(Routes.BASIC_PREFERENCE_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Personal Preference",
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
                                  Get.toNamed(Routes.RELIGIOUS_PREFERENCE_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Religious Preference",
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
                                  Get.toNamed(Routes.LOCATION_PREFERENCE_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Location Preference",
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
                                  Get.toNamed(Routes.EDUCATION_PREFERENCE_FORM, arguments: {"isLoggedIn": true});
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Education Preference",
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
      ),
    );
  }
}