import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class ReligiousInformationForm extends GetView<SignUpController> {
  const ReligiousInformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchReligiousDetails();
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
                          key: controller.religiousDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: TextView(
                                  text: "Religious Information",
                                  color: ColorPallete.secondary,
                                  fontSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              MyFormField(
                                fieldName: "Religion",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                dropDownOptions: Constants.RELIGION_LIST,
                                keyboard: TextInputType.text,
                                required: true,
                                initialValue: controller.religiousDetails.value.religion,
                                onChanged: (value) {
                                  controller.religiousDetails.value.religion = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Caste",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                dropDownOptions: controller.castes.map((element) => element.name).toSet().toList(),
                                keyboard: TextInputType.text,
                                required: true,
                                initialValue: controller.religiousDetails.value.caste,
                                onChanged: (value) {
                                  controller.religiousDetails.value.caste = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Subcaste",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                // dropDownOptions: ["Maratha", "Marwadi", "Agri"],
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.subcaste,
                                onChanged: (value) {
                                  controller.religiousDetails.value.subcaste = value;
                                },
                              ),
                              /*const SizedBox(
                                height: 10,
                              ),
                              const Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextView(
                                  text: "Are You Manglik ?",
                                  color: ColorPallete.primary,
                                  fontSize: 14,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              MyFormField(
                                fieldName: "Manglik",
                                showFieldName: false,
                                type: InputType.DROP_DOWN,
                                dropDownOptions: const ["YES", "NO", "Do not know"],
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.manglik,
                                onChanged: (value) {
                                  controller.religiousDetails.value.manglik = value;
                                },
                              ),*/
                              MyFormField(
                                fieldName: "Devak",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.devak,
                                onChanged: (value) {
                                  controller.religiousDetails.value.devak = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Gan",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.gan,
                                onChanged: (value) {
                                  controller.religiousDetails.value.gan = value;
                                },
                              ),
                             /* MyFormField(
                                fieldName: "Gotra",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.gotra,
                                onChanged: (value) {
                                  controller.religiousDetails.value.gotra = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Charan",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.charan,
                                onChanged: (value) {
                                  controller.religiousDetails.value.charan = value;
                                },
                              ),*/
                              MyFormField(
                                fieldName: "Rashi",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousDetails.value.rashi,
                                onChanged: (value) {
                                  controller.religiousDetails.value.rashi = value;
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
                              if (controller.religiousDetailsFormKey.currentState!.validate()) {
                                controller.submitReligiousDetails(context);
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
                if (controller.isReligiousDetailsLoading.value)
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
