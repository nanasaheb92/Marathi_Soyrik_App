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

class IDSearchScreen extends GetView<SearchProfilesController> {
  const IDSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: MyListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const TextView(
                      text: "ID",
                      fontSize: 16,
                      color: ColorPallete.primary,
                    ),
                    MyFormField(
                      fieldName: "Enter ID",
                      showFieldName: false,
                      type: InputType.TEXT,
                      keyboard: TextInputType.text,
                      required: true,
                      initialValue: "",
                      onChanged: (value) {
                        controller.searchProfile.value.id = value;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RoundedContainer(
                radius: 0,
                height: 40,
                child: InkWell(
                  onTap: () {
                    controller.getSearchMatchesById(true);
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
    );
  }
}
