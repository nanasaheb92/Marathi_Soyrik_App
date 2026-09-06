import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/components/ui/rounded_container.dart';
import 'package:matrimony/app/constants/constants.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../../common/color_pallete.dart';
import '../../../../components/ui/text_view.dart';
import '../../controllers/sign_up_controller.dart';
import '../form_fields.dart';

class PersonalDetailsForm extends GetView<SignUpController> {
  const PersonalDetailsForm({super.key});

  @override
  Widget build(BuildContext context) {
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
                              key: controller.basicDetailsFormKey,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextView(
                                    text: "Basic Details",
                                    color: ColorPallete.secondary,
                                    fontSize: 18,
                                    weight: FontWeight.bold,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //NAME
                                  MyFormField(
                                    fieldName: "Name",
                                    initialValue: controller.basicDetails.value.name,
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    onChanged: (value) {
                                      controller.basicDetails.value.name = value;
                                    },
                                  ),
                                  //Height
                                  MyFormField(
                                    fieldName: "Height",
                                    initialValue: controller.basicDetails.value.height,
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    dropDownOptions: Constants.HEIGHT_LIST,
                                    // initialValue: controller.basicDetails.value,
                                    onChanged: (value) {
                                      controller.basicDetails.value.height = value;
                                    },
                                  ), //DOB
                                  MyFormField(
                                    controller: controller.dobController,
                                    fieldName: "Date Of Birth",
                                    type: InputType.DATE,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    validator: controller.validateDobForAdults,
                                    //initialValue: controller.basicDetails.value.dOB,
                                    onChanged: (value) {
                                      controller.basicDetails.value.dOB = value;
                                    },
                                  ),
                                  /*TextFormField(
                                  controller: _dobPANController,
                                  // Use the controller
                                  readOnly: true,
                                  // Prevent manual editing
                                  style: Theme.of(context).textTheme.labelLarge,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                    label: Text(
                                      "Date of Birth as per PAN",
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                    focusColor: kSecondaryColor,
                                    border: const OutlineInputBorder(),
                                    suffixIcon: const Icon(Icons.calendar_today), // Icon for clarity
                                  ),
                                  onTap: () async {
                                    DateTime? selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: widget.details.pandob != null && widget.details.pandob!.isNotEmpty ? DateTime.tryParse(widget.details.pandob!) ?? DateTime.now() : DateTime.now(),
                                      firstDate: DateTime(1900), // Adjust as per your requirement
                                      lastDate: DateTime.now(),
                                    );

                                    if (selectedDate != null) {
                                      // Format date if required (e.g., dd/MM/yyyy)
                                      String formattedDate = "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
                                      widget.details.pandob = formattedDate; // Update your model
                                      _dobPANController.text = formattedDate; // Update the controller's text
                                    }
                                  },
                                  validator: (String? value) {
                                    if (value == null || value.isEmpty) {
                                      return "Date of Birth is required";
                                    }
                                    return null;
                                  },
                                ),*/
                                  //Maritial Status
                                  MyFormField(
                                    fieldName: "Marital Status",
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    dropDownOptions: Constants.MARITAL_STATUS_LIST,
                                    initialValue:
                                    controller.basicDetails.value.maritalStatus,
                                    onChanged: (value) {
                                      controller.basicDetails.value.maritalStatus = value;
                                    },
                                  ),
                                  //Hobbies
                              /*    MyFormField(
                                    fieldName: "Hobbies",
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.name,
                                    required: false,
                                    initialValue: controller.basicDetails.value.hobbies,
                                    onChanged: (value) {
                                      controller.basicDetails.value.hobbies = value;
                                    },
                                  ),
                                  //Weight
                                  MyFormField(
                                    fieldName: "Weight",
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.name,
                                    required: false,
                                    initialValue: controller.basicDetails.value.weight,
                                    onChanged: (value) {
                                      controller.basicDetails.value.weight = value;
                                    },
                                  ),*/
                                  //Birth Time
                                  MyFormField(
                                    fieldName: "Birth Time",
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.name,
                                    required: false,
                                    initialValue: controller.basicDetails.value.birthtime
                                        ?.replaceAll(" ", ""),
                                    onChanged: (value) {
                                      controller.basicDetails.value.birthtime = value;
                                    },
                                  ),
                                  //No of Childern
                                  MyFormField(
                                    fieldName: "No of Children if any",
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.number,
                                    required: false,
                                    initialValue:
                                    controller.basicDetails.value.noofchildren,
                                    onChanged: (value) {
                                      controller.basicDetails.value.noofchildren = value;
                                    },
                                  ),
                                  //Mothertounge
                                  MyFormField(
                                    fieldName: "Mother Tongue",
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    dropDownOptions: controller.mothertounges
                                        .map((element) => element.name)
                                        .toList(),
                                    initialValue:
                                    controller.basicDetails.value.mothertounge,
                                    onChanged: (value) {
                                      controller.basicDetails.value.mothertounge = value;
                                    },
                                  ),
                                  //Languages
                                  MyFormField(
                                    fieldName: "Languages",
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    initialValue: controller.basicDetails.value.languages,
                                    onChanged: (value) {
                                      controller.basicDetails.value.languages = value;
                                    },
                                  ),

                                  //Birth Place
                                  MyFormField(
                                    fieldName: "Birth Place",
                                    type: InputType.TEXT,
                                    keyboard: TextInputType.name,
                                    required: false,
                                    initialValue: controller.basicDetails.value.birthplace,
                                    onChanged: (value) {
                                      controller.basicDetails.value.birthplace = value;
                                    },
                                  ),
                                  //Birth Place
                                  MyFormField(
                                    fieldName: "Profile Created By",
                                    type: InputType.DROP_DOWN,
                                    keyboard: TextInputType.name,
                                    required: true,
                                    dropDownOptions: Constants.PROFILE_CREATORS_LIST,
                                    initialValue: controller.basicDetails.value.createdBy,
                                    onChanged: (value) {
                                      controller.basicDetails.value.createdBy = value;
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
                                  if (controller.basicDetailsFormKey.currentState!.validate()) {
                                    controller.submitBasicDetails(context);
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
                    if (controller.isBasicDetailsLoading.value)
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