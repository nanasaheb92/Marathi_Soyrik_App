import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class ReligiousPreferenceForm extends GetView<SignUpController> {
  const ReligiousPreferenceForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchReligiousPreferenceDetails();
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
                          key: controller.religiousPreferenceFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: TextView(
                                  text: "Religious Preference",
                                  color: ColorPallete.secondary,
                                  fontSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              MyFormField(
                                fieldName: "Religion",
                                type: InputType.MULTI_SELECT,
                                dropDownOptions: Constants.RELIGION_PREFS_LIST,
                                keyboard: TextInputType.none,
                                required: true,
                                initialValue: controller.religiousPreference.value.religon,
                                onChanged: (value) {
                                  controller.religiousPreference.value.religon = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Caste",
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.none,
                                required: true,
                                dropDownOptions: controller.castes.map((element) => element.name).toList(),
                                initialValue: controller.religiousPreference.value.caste,
                                onChanged: (value) {
                                  controller.religiousPreference.value.caste = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Manglik",
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.number,
                                required: false,
                                dropDownOptions: const ["Any", "Yes", "No", "Do not know"],
                                initialValue: controller.religiousPreference.value.manglik,
                                onChanged: (value) {
                                  controller.religiousPreference.value.manglik = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Star",
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.religiousPreference.value.star,
                                onChanged: (value) {
                                  controller.religiousPreference.value.star = value;
                                },
                              ),
                              SizedBox(
                                height: 10,
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
                              if (controller.religiousPreferenceFormKey.currentState!.validate()) {
                                controller.saveReligiousPreferenceDetails(context);
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
                if (controller.isReligiousPreferenceLoading.value)
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
