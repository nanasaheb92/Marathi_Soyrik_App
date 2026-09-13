import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class LocationPreferenceForm extends GetView<SignUpController> {
  const LocationPreferenceForm({super.key});

  @override
  Widget build(BuildContext context) {
    //controller.fetchLocationPreferenceDetails();
    Future.microtask(() => controller.fetchLocationPreferenceDetails());
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
                          key: controller.locationPreferenceFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: TextView(
                                  text: "Location Preference",
                                  color: ColorPallete.secondary,
                                  fontSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  MyFormField(
                                    fieldName: "Country",
                                    // showFieldName: false,
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.text,
                                    required: true,
                                    dropDownOptions: controller.countries.map((element) => element.name).toList(),
                                    initialValue: (controller.locationPreference.value.country ?? "") != ""
                                        ? controller.countries.where((p0) => p0.id.toString() == controller.locationPreference.value.country).isNotEmpty
                                            ? controller.countries.where((p0) => p0.id.toString() == controller.locationPreference.value.country).first.name
                                            : null
                                        : "",
                                    onChanged: (value) {
                                      controller.onCountryPrefChanged(value, false);
                                    },
                                  ),
                                  if (controller.states.isNotEmpty)
                                    MyFormField(
                                      fieldName: "State",
                                      // showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.text,
                                      required: true,
                                      dropDownOptions: controller.states.map((element) => element.name).toList(),
                                      initialValue: (controller.locationPreference.value.state ?? "") != ""
                                          ? controller.states.where((p0) => p0.id.toString() == controller.locationPreference.value.state).isNotEmpty
                                              ? controller.states.where((p0) => p0.id.toString() == controller.locationPreference.value.state).first.name
                                              : null
                                          : "",
                                      onChanged: (value) {
                                        controller.onStatePrefChanged(value, false);
                                      },
                                    ),
                                  if (controller.cities.isNotEmpty)
                                    MyFormField(
                                      fieldName: "City",
                                      // showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.text,
                                      required: true,
                                      dropDownOptions: controller.cities.map((element) => element.name).toList(),
                                      initialValue: (controller.locationPreference.value.city ?? "") != ""
                                          ? controller.cities.where((p0) => p0.id.toString() == controller.locationPreference.value.city).isNotEmpty
                                              ? controller.cities.where((p0) => p0.id.toString() == controller.locationPreference.value.city).first.name
                                              : null
                                          : "",
                                      onChanged: (value) {
                                        controller.onCityPrefChanged(value, false);
                                      },
                                    ),
                                ],
                              ),
                              MyFormField(
                                fieldName: "Residence (Citizen/NRI)",
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.number,
                                required: false,
                                dropDownOptions: ["Citizen", "NRI"],
                                initialValue: controller.locationPreference.value.residence,
                                onChanged: (value) {
                                  controller.locationPreference.value.residence = value;
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
                              if (controller.locationPreferenceFormKey.currentState!.validate()) {
                                controller.saveLocationPreferenceDetails(context);
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
                if (controller.isLocationPreferenceLoading.value)
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
