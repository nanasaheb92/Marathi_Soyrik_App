import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class ProfileSettingsForm extends GetView<SignUpController> {
  const ProfileSettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchProfileVisibilityStatus();
    return Scaffold(
      backgroundColor: ColorPallete.primary,
      body: SafeArea(
        child: Container(
          color: ColorPallete.theme,
          child: Obx(
                () =>
                Stack(
                  children: [
                    Column(
                      children: [
                        Container(
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
                                    colors: ColorPallete.linearGradientAppBar,
                                    stops: [0, 0.5],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Center(
                                    child: TextView(
                                      text:
                                      "${controller.isAuthenticated.value ? "UPDATE" : "SETUP"} PROFILE",
                                      color: ColorPallete.theme,
                                      fontSize: 22,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Form(
                              key: controller.profileSettingsFormKey,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextView(
                                    text: "Profile Settings",
                                    color: ColorPallete.secondary,
                                    fontSize: 18,
                                    weight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //ENABLE MOBILE
                                  MyFormField(
                                    fieldName: "Enable Mobile Visibility",
                                    initialValue: controller.profileSettings.value.enableMobileVisibility,
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    dropDownOptions: Constants.ON_OFF,
                                    onChanged: (value) {
                                      controller.profileSettings.value.enableMobileVisibility = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //ENABLE MOBILE
                                  MyFormField(
                                    fieldName: "Enable Photo Visibility",
                                    initialValue: controller.profileSettings.value.enablePhotoVisibility,
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    dropDownOptions: Constants.ON_OFF,
                                    onChanged: (value) {
                                      controller.profileSettings.value.enablePhotoVisibility = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: TextView(text: "* All fields are mandatory")
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: const RoundedContainer(
                                  radius: 10,
                                  color: ColorPallete.primary,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 20),
                                    child: Center(
                                      child: TextView(
                                        text: "Back",
                                        color: ColorPallete.theme,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  /*if (!controller.isLoading.value) {
                                controller.validateAndContinue(context);
                              }*/
                                  if (controller.profileSettingsFormKey.currentState!.validate()) {
                                    controller.submitProfileVisibilityStatus(context);
                                  }
                                },
                                child: const RoundedContainer(
                                  radius: 10,
                                  color: ColorPallete.primary,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 20),
                                    child: Center(
                                      child: TextView(
                                        text: "Submit",
                                        color: ColorPallete.theme,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    if (controller.isProfileSettingsLoading.value)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5), // Semi-transparent background
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}