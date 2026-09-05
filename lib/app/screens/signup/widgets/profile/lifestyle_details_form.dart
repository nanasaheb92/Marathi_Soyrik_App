import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class LifestyleDetailsForm extends GetView<SignUpController> {
  const LifestyleDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchLifestyleDetails();
    return Scaffold(
      backgroundColor: ColorPallete.primary,
      body: SafeArea(
        child: Container(
          color: ColorPallete.theme,
          child: Obx(
            () => Stack(
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
                                  text: "${controller.isAuthenticated.value ? "UPDATE" : "SETUP"} PROFILE",
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
                          key: controller.lifestyleDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: TextView(
                                  text: "Lifestyle Details",
                                  color: ColorPallete.secondary,
                                  fontSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              MyFormField(
                                fieldName: "Body Type",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                required: true,
                                dropDownOptions: Constants.BODY_TYPE_LIST,
                                initialValue: controller.lifestyleDetails.value.bodyType,
                                onChanged: (value) {
                                  controller.lifestyleDetails.value.bodyType = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Skin Tone",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                required: true,
                                dropDownOptions: Constants.SKIN_TONES_LIST,
                                initialValue: controller.lifestyleDetails.value.skinTone,
                                onChanged: (value) {
                                  controller.lifestyleDetails.value.skinTone = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Blood Group",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                dropDownOptions: const ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.lifestyleDetails.value.bloodGroup,
                                onChanged: (value) {
                                  controller.lifestyleDetails.value.bloodGroup = value;
                                },
                              ),
                              /*MyFormField(
                                fieldName: "Eating Habit (Veg/Non-Veg)",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                required: true,
                                dropDownOptions: Constants.DIETARY_PREFS_LIST,
                                initialValue: controller.lifestyleDetails.value.eatingHabbit,
                                onChanged: (value) {
                                  controller.lifestyleDetails.value.eatingHabbit = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Smokking Habit",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                required: true,
                                dropDownOptions: const ["Yes", "No"],
                                initialValue: controller.lifestyleDetails.value.smokingHabbit,
                                onChanged: (value) {
                                  controller.lifestyleDetails.value.smokingHabbit = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Drinking Habit",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                dropDownOptions: const ["Yes", "No"],
                                required: true,
                                initialValue: controller.lifestyleDetails.value.drinkingHabbit,
                                onChanged: (value) {
                                  controller.lifestyleDetails.value.drinkingHabbit = value;
                                },
                              ),*/
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: TextView(text: "* All fields are mandatory")),
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
                                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
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
                              if (controller.lifestyleDetailsFormKey.currentState!.validate()) {
                                controller.submitLifestyleDetails(context);
                              }
                            },
                            child: const RoundedContainer(
                              radius: 10,
                              color: ColorPallete.primary,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
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
                if (controller.isLifestyleDetailsLoading.value)
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
