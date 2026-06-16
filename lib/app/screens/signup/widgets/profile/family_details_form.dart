import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class FamilyDetailsForm extends GetView<SignUpController> {
  const FamilyDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchFamilyDetails();
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
                          key: controller.familyDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const TextView(
                                text: "Family Details",
                                color: ColorPallete.secondary,
                                fontSize: 18,
                                weight: FontWeight.bold,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyFormField(
                                fieldName: "Family Type (Joint / Nuclear)",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                required: true,
                                dropDownOptions: const ["Joint", "Nuclear"],
                                initialValue: controller.familyDetails.value.familyType,
                                onChanged: (value) {
                                  controller.familyDetails.value.familyType = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Father's Name",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: true,
                                initialValue: controller.familyDetails.value.fathersName,
                                onChanged: (value) {
                                  controller.familyDetails.value.fathersName = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Father's Occupation",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.familyDetails.value.fathersOccupation,
                                onChanged: (value) {
                                  controller.familyDetails.value.fathersOccupation = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Mother's Name",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: true,
                                initialValue: controller.familyDetails.value.mothersName,
                                onChanged: (value) {
                                  controller.familyDetails.value.mothersName = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Mother's Occupation",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.familyDetails.value.mothersOccupation,
                                onChanged: (value) {
                                  controller.familyDetails.value.mothersOccupation = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "No. Of Brothers",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.number,
                                required: false,
                                initialValue: controller.familyDetails.value.noOfBrothers,
                                onChanged: (value) {
                                  controller.familyDetails.value.noOfBrothers = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "No. Of Married Brothers",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.number,
                                required: false,
                                initialValue: controller.familyDetails.value.noOfMarriedBrothers,
                                onChanged: (value) {
                                  controller.familyDetails.value.noOfMarriedBrothers = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "No. Of Sisters",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.number,
                                required: false,
                                initialValue: controller.familyDetails.value.noOfSisters,
                                onChanged: (value) {
                                  controller.familyDetails.value.noOfSisters = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "No. Of Married Sisters",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.number,
                                required: false,
                                initialValue: controller.familyDetails.value.noOfMarriedSisters,
                                onChanged: (value) {
                                  controller.familyDetails.value.noOfMarriedSisters = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "About My Family",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.familyDetails.value.aboutFamily,
                                onChanged: (value) {
                                  controller.familyDetails.value.aboutFamily = value;
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
                                    text: "Previous",
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
                              if (controller.familyDetailsFormKey.currentState!.validate()) {
                                controller.submitFamilyDetails(context);
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
                if (controller.isFamilyDetailsLoading.value)
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
