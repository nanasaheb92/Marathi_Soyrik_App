import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class BasicPreferenceForm extends GetView<SignUpController> {
  const BasicPreferenceForm({super.key});

  @override
  Widget build(BuildContext context) {
    controller.fetchBasicPreferenceDetails();
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
                          key: controller.basicPreferenceFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: TextView(
                                  text: "Basic Preference",
                                  color: ColorPallete.secondary,
                                  fontSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              MyFormField(
                                fieldName: "Looking For",
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.text,
                                dropDownOptions: const [
                                  "Divorced",
                                  "Single",
                                  "Widow",
                                  "Widower",
                                ],
                                required: false,
                                initialValue: controller.basicPreference.value.lookingFor,
                                onChanged: (value) {
                                  controller.basicPreference.value.lookingFor = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Skin Tone",
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.text,
                                required: false,
                                dropDownOptions: Constants.SKIN_TONES_PREFS_LIST,
                                initialValue: controller.basicPreference.value.skinTone,
                                onChanged: (value) {
                                  controller.basicPreference.value.skinTone = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Mother Tongue",
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.text,
                                dropDownOptions: controller.mothertounges.map((element) => element.name).toList(),
                                required: true,
                                initialValue: controller.basicPreference.value.mothertounge,
                                onChanged: (value) {
                                  controller.basicPreference.value.mothertounge = value;
                                },
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "From Age",
                                      type: InputType.DROP_DOWN,
                                      dropDownOptions: Constants.AGE_LIST,
                                      keyboard: TextInputType.number,
                                      required: true,
                                      initialValue: controller.basicPreference.value.fromAge,
                                      onChanged: (value) {
                                        controller.basicPreference.value.fromAge = value;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "To Age",
                                      type: InputType.DROP_DOWN,
                                      dropDownOptions: Constants.AGE_LIST,
                                      keyboard: TextInputType.number,
                                      required: true,
                                      initialValue: controller.basicPreference.value.toAge,
                                      onChanged: (value) {
                                        controller.basicPreference.value.toAge = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "From Height",
                                      type: InputType.DROP_DOWN,
                                      dropDownOptions: Constants.HEIGHT_LIST,
                                      keyboard: TextInputType.number,
                                      required: true,
                                      initialValue: controller.basicPreference.value.fromHeight,
                                      onChanged: (value) {
                                        controller.basicPreference.value.fromHeight = value;
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "To Height",
                                      type: InputType.DROP_DOWN,
                                      dropDownOptions: Constants.HEIGHT_LIST,
                                      keyboard: TextInputType.number,
                                      required: true,
                                      initialValue: controller.basicPreference.value.toHeight,
                                      onChanged: (value) {
                                        controller.basicPreference.value.toHeight = value;
                                      },
                                    ),
                                  )
                                ],
                              ),
                              /*MyFormField(
                                fieldName: "Eating Habit",
                                type: InputType.DROP_DOWN,
                                dropDownOptions: Constants.DIETARY_PREFS_LIST,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.basicPreference.value.eatingHabit,
                                onChanged: (value) {
                                  controller.basicPreference.value.eatingHabit = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Drinking Habit",
                                type: InputType.DROP_DOWN,
                                dropDownOptions: Constants.DRINKING_HABITS_PREFS_LIST,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.basicPreference.value.drinkingHabit,
                                onChanged: (value) {
                                  controller.basicPreference.value.drinkingHabit = value;
                                },
                              ),*/
                              MyFormField(
                                fieldName: "General Expectations",
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.basicPreference.value.generalExpt,
                                onChanged: (value) {
                                  controller.basicPreference.value.generalExpt = value;
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
                              if (controller.basicPreferenceFormKey.currentState!.validate()) {
                                controller.saveBasicPreferenceDetails(context);
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
                if (controller.isBasicPreferenceLoading.value)
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
