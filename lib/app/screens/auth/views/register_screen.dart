import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../common/color_pallete.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../signup/widgets/form_fields.dart';
import '../controller/auth_controller.dart';

class RegisterScreen extends GetView<AuthController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                  text: "SIGN UP",
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: controller.registerFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "VAR / VADHU NAME",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Enter Var/Vadhu Name",
                                required: true,
                                initialValue: controller.user.value.name,
                                showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                onChanged: (value) {
                                  controller.user.value.name = value;
                                },
                              ),
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: TextView(
                                  text: "GENDER",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: Constants.GENDER_LIST.map((e) {
                                    bool selected = (controller.isMale.value && e == "Male") || (!controller.isMale.value && e == "Female");
                                    return Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          color: ColorPallete.theme,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [BoxShadow(color: ColorPallete.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))]),
                                      child: InkWell(
                                        onTap: () {
                                          if (controller.isMale.value && e == "Female") {
                                            controller.isMale.value = false;
                                            controller.user.value.gender = "Female";
                                          } else if (!controller.isMale.value && e == "Male") {
                                            controller.isMale.value = true;
                                            controller.user.value.gender = "Male";
                                          }
                                          controller.isMale.refresh();
                                        },
                                        child: RoundedContainer(
                                          radius: 10,
                                          width: 100,
                                          color: ColorPallete.theme,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  selected ? Icons.radio_button_checked : Icons.radio_button_off,
                                                  color: selected ? ColorPallete.primary : ColorPallete.grey,
                                                ),
                                                Expanded(
                                                    child: Center(
                                                        child: TextView(
                                                  text: e,
                                                  fontSize: 14,
                                                  color: selected ? ColorPallete.primary : ColorPallete.grey,
                                                  weight: FontWeight.bold,
                                                )))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "Date Of Birth",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              //DOB
                              MyFormField(
                                controller: controller.dobController,
                                fieldName: "Date Of Birth",
                                type: InputType.DATE,
                                keyboard: TextInputType.name,
                                showFieldName: false,
                                required: true,
                                initialValue: controller.user.value.dOB,
                                onChanged: (value) {
                                  controller.user.value.dOB = value;
                                },
                              ),
                             const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "MARITAL STATUS",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Marital Status",
                                initialValue: controller.user.value.maritalStatus,
                                showFieldName: false,
                                required: true,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                dropDownOptions: Constants.MARITAL_STATUS_LIST,
                                onChanged: (value) {
                                  controller.user.value.maritalStatus = value;
                                },
                              ),
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "LOCATION",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Enter Candidate Location",
                                initialValue: controller.user.value.location,
                                showFieldName: false,
                                type: InputType.DROP_DOWN,
                                required: true,
                                dropDownOptions: controller.locations,
                                keyboard: TextInputType.text,
                                onChanged: (value) {
                                  controller.user.value.location = value;
                                },
                              ),
                              /*const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "MOBILE NO.",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Enter Candidate's Mobile Number",
                                initialValue: controller.user.value.mobile,
                                showFieldName: false,
                                required: true,
                                type: InputType.TEXT,
                                keyboard: TextInputType.phone,
                                onChanged: (value) {
                                  controller.user.value.mobile = value;
                                },
                              ),*/
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "EMAIL",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Enter Candidate Email",
                                initialValue: controller.user.value.email,
                                required: true,
                                showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                onChanged: (value) {
                                  controller.user.value.email = value;
                                },
                              ),
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "CREATE PASSWORD",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Password",
                                showFieldName: false,
                                required: true,
                                type: InputType.TEXT,
                                keyboard: TextInputType.visiblePassword,
                                onChanged: (value) {
                                  controller.user.value.password = value;
                                },
                              ),
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "RELIGION",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Enter Candidate's Religion",
                                initialValue: controller.user.value.religion,
                                showFieldName: false,
                                type: InputType.DROP_DOWN,
                                required: true,
                                dropDownOptions: Constants.RELIGION_LIST,
                                keyboard: TextInputType.text,
                                onChanged: (value) {
                                  controller.user.value.religion = value;
                                },
                              ),
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "CASTE",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Enter Candidate's Caste",
                                initialValue: controller.user.value.caste,
                                showFieldName: false,
                                type: InputType.DROP_DOWN,
                                dropDownOptions: controller.castes.map((element) => element.name).toSet().toList(),
                                required: true,
                                keyboard: TextInputType.text,
                                onChanged: (value) {
                                  controller.user.value.caste = value;
                                },
                              ),
                              /*const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "MOTHER TONGUE",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Mother Tongue",
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.name,
                                required: true,
                                showFieldName: false,
                                dropDownOptions: controller.mothertounges
                                    .map((element) => element.name)
                                    .toList(),
                                initialValue:
                                controller.user.value.motherTongue,
                                onChanged: (value) {
                                  controller.user.value.motherTongue = value;
                                },
                              ),
                              const SizedBox(
                                height: 7.5,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "EDUCATION",
                                  color: ColorPallete.secondary,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Education",
                                // showFieldName: false,
                                type: InputType.MULTI_SELECT,
                                dropDownOptions: controller.educationalOptions
                                    .map((element) => element.category)
                                    .toList(),
                                showFieldName: false,
                                keyboard: TextInputType.text,
                                required: true,
                                initialValue: controller.user.value.education,
                                onChanged: (value) {
                                  controller.user.value.education = value;
                                },
                              ),*/


                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: TextView(text: "* All fields are mandatory")),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              if (controller.registerFormKey.currentState!.validate()) {
                                controller.setupAccount();
                              }
                            },
                            child: RoundedContainer(
                              radius: 10,
                              color: Colors.green,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                                child: const TextView(
                                  text: "Create Profile",
                                  color: ColorPallete.theme,
                                  weight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 7.5,
                    )
                  ],
                ),
                if (controller.isLoading.value)
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
