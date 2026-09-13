import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class LocationDetailsForm extends GetView<SignUpController> {
  const LocationDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
    //controller.fetchLocationDetails();
    Future.microtask(() => controller.fetchLocationDetails());
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
                          key: controller.locationDetailsFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: TextView(
                                  text: "Location Details",
                                  color: ColorPallete.secondary,
                                  fontSize: 18,
                                  weight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 30,
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
                                    initialValue: (controller.locationDetails.value.country ?? "") != ""
                                        ? controller.countries.where((p0) => p0.id.toString() == controller.locationDetails.value.country).isNotEmpty
                                            ? controller.countries.where((p0) => p0.id.toString() == controller.locationDetails.value.country).first.name
                                            : null
                                        : "",
                                    onChanged: (value) {
                                      controller.onCountryChanged(value, false);
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
                                      initialValue: (controller.locationDetails.value.state ?? "") != ""
                                          ? controller.states.where((p0) => p0.id.toString() == controller.locationDetails.value.state).isNotEmpty
                                              ? controller.states.where((p0) => p0.id.toString() == controller.locationDetails.value.state).first.name
                                              : null
                                          : "",
                                      onChanged: (value) {
                                        controller.onStateChanged(value, false);
                                      },
                                    ),
                                  if (controller.states.isNotEmpty)
                                    MyFormField(
                                      fieldName: "City",
                                      // showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.text,
                                      required: true,
                                      dropDownOptions: controller.cities.map((element) => element.name).toList(),
                                      initialValue: (controller.locationDetails.value.city ?? "") != ""
                                          ? controller.cities.where((p0) => p0.id.toString() == controller.locationDetails.value.city).isNotEmpty
                                              ? controller.cities.where((p0) => p0.id.toString() == controller.locationDetails.value.city).first.name
                                              : null
                                          : null,
                                      onChanged: (value) {
                                        controller.onCityChanged(value, false);
                                      },
                                    ),
                                ],
                              ),
                              MyFormField(
                                fieldName: "Address",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.locationDetails.value.address,
                                onChanged: (value) {
                                  controller.locationDetails.value.address = value;
                                },
                              ),
                              // MyFormField(
                              //   fieldName: "Mobile",
                              //   // showFieldName: false,
                              //   type: InputType.TEXT,
                              //   keyboard: TextInputType.phone,
                              //   required: true,
                              //   // initialValue:
                              //   // controller.uss.value.eatingHabbit,
                              //   onChanged: (value) {
                              //     // controller.uss.value.eatingHabbit = value;
                              //   },
                              // ),
                              // MyFormField(
                              //   fieldName: "Phone",
                              //   // showFieldName: false,
                              //   type: InputType.TEXT,
                              //   keyboard: TextInputType.phone,
                              //   required: true,
                              //   // initialValue:
                              //   // controller.lifestyleDetails.value.smokingHabbit,
                              //   onChanged: (value) {
                              //     // controller.lifestyleDetails.value.smokingHabbit = value;
                              //   },
                              // ),
                              MyFormField(
                                fieldName: "Time to Call",
                                // showFieldName: false,
                                type: InputType.TEXT,
                                keyboard: TextInputType.text,
                                required: false,
                                initialValue: controller.locationDetails.value.timeToCall,
                                onChanged: (value) {
                                  controller.locationDetails.value.timeToCall = value;
                                },
                              ),
                              MyFormField(
                                fieldName: "Residence (NRI/Citizen)",
                                // showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                required: false,
                                dropDownOptions: ["NRI", "Citizen"],
                                initialValue: controller.locationDetails.value.residance,
                                onChanged: (value) {
                                  controller.locationDetails.value.residance = value;
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
                              if (controller.locationDetailsFormKey.currentState!.validate()) {
                                controller.submitLocationDetails(context);
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
                if (controller.isLocationDetailsLoading.value)
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
