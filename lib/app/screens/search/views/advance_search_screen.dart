import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/color_pallete.dart';
import '../../../components/ui/loading_widget.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../matches/controllers/match_controller.dart';
import '../../matches/widgets/match_card_widget.dart';
import '../../signup/widgets/form_fields.dart';
import '../controllers/search_profiles_controller.dart';

class AdvanceSearchScreen extends GetView<SearchProfilesController> {
  const AdvanceSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => (controller.isLoading.value)
            ? const Loading()
            : Column(
                children: [
                  Expanded(
                    child: MyListView(
                      scroll: true,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: MyListView(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const TextView(
                                text: "Religion",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              MyFormField(
                                fieldName: "Religion",
                                showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                dropDownOptions: controller.religions,
                                required: true,
                                //initialValue: "",
                                onChanged: (value) {
                                  controller.searchProfile.value.religion =
                                      value;
                                },
                              ),
                              const TextView(
                                text: "Caste",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              MyFormField(
                                fieldName: "Caste",
                                showFieldName: false,
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.text,
                                dropDownOptions: controller.castes
                                    .map((element) => element.name)
                                    .toList(),
                                required: true,
                                //initialValue: "",
                                onChanged: (value) {
                                  controller.searchProfile.value.caste =
                                      value;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const TextView(
                                text: "Gender",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              MyFormField(
                                fieldName: "Gender",
                                showFieldName: false,
                                type: InputType.DROP_DOWN,
                                keyboard: TextInputType.text,
                                dropDownOptions: controller.gender,
                                required: true,
                                initialValue: controller.searchProfile.value.gender,
                                onChanged: (value) {
                                  controller.searchProfile.value.gender = value;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const TextView(
                                text: "Marital Status",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              MyFormField(
                                fieldName: "Marital Status",
                                showFieldName: false,
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.text,
                                dropDownOptions: controller.maritialStatuses,
                                required: true,
                                //initialValue: "",
                                onChanged: (value) {
                                  controller.searchProfile.value.maritalStatus =
                                      value;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const TextView(
                                text: "Mother Tongue",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              MyFormField(
                                fieldName: "Mother Tongue",
                                showFieldName: false,
                                type: InputType.MULTI_SELECT,
                                keyboard: TextInputType.text,
                                dropDownOptions: controller.mothertounges
                                    .map((element) => element.name)
                                    .toList(),
                                required: true,
                                //initialValue: "",
                                onChanged: (value) {
                                  controller.searchProfile.value.motherTongue =
                                      value;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const TextView(
                                text: "Age",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "Age From",
                                      showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.name,
                                      // required: true,
                                      dropDownOptions: List.generate(
                                          47, (index) => "${18 + index}"),
                                      // initialValue: controller.personalDetails["dob"],
                                      onChanged: (value) {
                                        controller.searchProfile.value.ageFrom =
                                            value;
                                      },
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: TextView(
                                      text: "to",
                                      fontSize: 14,
                                      color: ColorPallete.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "Age to",
                                      showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.name,
                                      // required: true,
                                      dropDownOptions: List.generate(
                                          47, (index) => "${18 + index}"),
                                      // initialValue: controller.personalDetails["dob"],
                                      onChanged: (value) {
                                        controller.searchProfile.value.ageTo =
                                            value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const TextView(
                                text: "Height",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "Height From",
                                      showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.name,
                                      // required: true,
                                      dropDownOptions: controller.heights,
                                      // initialValue: controller.personalDetails["dob"],
                                      onChanged: (value) {
                                        controller.searchProfile.value
                                            .heightFrom = value;
                                      },
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: TextView(
                                      text: "to",
                                      fontSize: 14,
                                      color: ColorPallete.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: MyFormField(
                                      fieldName: "Height to",
                                      showFieldName: false,
                                      type: InputType.DROP_DOWN,
                                      keyboard: TextInputType.name,
                                      // required: true,
                                      dropDownOptions: controller.heights,
                                      // initialValue: controller.personalDetails["dob"],
                                      onChanged: (value) {
                                        controller.searchProfile.value
                                            .heightTo = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const TextView(
                                text: "Education",
                                fontSize: 16,
                                color: ColorPallete.primary,
                              ),
                              MyFormField(
                                fieldName: "Education",
                                showFieldName: false,
                                type: InputType.MULTI_SELECT,
                                dropDownOptions: controller.educationalOptions
                                    .map((element) => element.category)
                                    .toList(),
                                keyboard: TextInputType.text,
                                required: true,
                                // initialValue: controller.searchProfile.value.education,
                                onChanged: (value) {
                                  controller.searchProfile.value.education =
                                      value;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              // const TextView(
                              //   text: "Annual Incomne",
                              //   fontSize: 16,
                              //   color: ColorPallete.primary,
                              // ),
                              // MyFormField(
                              //   fieldName: "Annual Incomne",
                              //   showFieldName: false,
                              //   type: InputType.DROP_DOWN,
                              //   keyboard: TextInputType.text,
                              //   dropDownOptions:
                              //       controller.annualIncome,
                              //   required: true,
                              //   initialValue: "",
                              //   onChanged: (value) {},
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: RoundedContainer(
                      radius: 0,
                      height: 40,
                      child: InkWell(
                        onTap: () {
                          controller.getSearchMatches(true);
                        },
                        child: RoundedContainer(
                          radius: 10,
                          height: 45,
                          color: ColorPallete.primary,
                          borderColor: ColorPallete.primary,
                          child: controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorPallete.theme,
                                  ),
                                )
                              : const Center(
                                  child: TextView(
                                    text: "Search",
                                    color: ColorPallete.theme,
                                    weight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
