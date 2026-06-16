import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class EducationDetailsForm extends GetView<SignUpController> {
  const EducationDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchEducationDetails();
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
                    key: controller.educationDetailsFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: TextView(
                            text: "Education & Occupation",
                            color: ColorPallete.secondary,
                            fontSize: 18,
                            weight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        MyFormField(
                          fieldName: "Education",
                          // showFieldName: false,
                          type: InputType.MULTI_SELECT,
                          dropDownOptions: controller.educationalOptions
                              .map((element) => element.category)
                              .toList(),
                          keyboard: TextInputType.text,
                          required: true,
                          initialValue: controller.educationDetails.value.education,
                          onChanged: (value) {
                            controller.educationDetails.value.education = value;
                          },
                        ),
                        MyFormField(
                          fieldName: "Occupation",
                          // showFieldName: false,
                          type: InputType.TEXT,
                          keyboard: TextInputType.text,
                          required: false,
                          initialValue:
                              controller.educationDetails.value.occupation,
                          onChanged: (value) {
                            controller.educationDetails.value.occupation = value;
                          },
                        ),
                        MyFormField(
                          fieldName: "Employee In",
                          // showFieldName: false,
                          type: InputType.TEXT,
                          keyboard: TextInputType.text,
                          required: true,
                          initialValue:
                              controller.educationDetails.value.employeeIn,
                          onChanged: (value) {
                            controller.educationDetails.value.employeeIn = value;
                          },
                        ),
                        MyFormField(
                          fieldName: "Designation",
                          // showFieldName: false,
                          type: InputType.TEXT,
                          keyboard: TextInputType.text,
                          required: true,
                          initialValue:
                              controller.educationDetails.value.designation,
                          onChanged: (value) {
                            controller.educationDetails.value.designation = value;
                          },
                        ),
                        MyFormField(
                          fieldName: "Annual Income",
                          // showFieldName: false,
                          type: InputType.DROP_DOWN,
                          keyboard: TextInputType.text,
                          required: true,
                          dropDownOptions: Constants.ANNUAL_INCOME_LIST,
                          initialValue:
                              controller.educationDetails.value.annualIncome,
                          onChanged: (value) {
                            controller.educationDetails.value.annualIncome = value;
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
                        if(controller.educationDetailsFormKey.currentState!.validate()) {
                          controller.submitEducationDetails(context);
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
                if (controller.isEducationDetailsLoading.value)
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

