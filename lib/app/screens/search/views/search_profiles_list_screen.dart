import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/color_pallete.dart';
import '../../../components/ui/loading_widget.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../matches/controllers/match_controller.dart';
import '../../matches/widgets/match_card_widget2.dart';
import '../../signup/widgets/form_fields.dart';
import '../controllers/search_profiles_controller.dart';

class SearchProfilesListScreen extends GetView<SearchProfilesController> {
  const SearchProfilesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorPallete.theme),
        backgroundColor: ColorPallete.primary,
        title: const TextView(
          text: "Matches",
          color: ColorPallete.theme,
          fontSize: 18,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.arrow_back,
            color: ColorPallete.theme,
          ),
        ),
      ),
      body: Obx(
          () => MyListView(
              controller: controller.searchMatchesScrollController,
              scroll: true,
              children: [
                controller.searchMacthes.isEmpty &&
                    !controller.isLoading.value
                    ? SizedBox(
                  height: 200,
                  child: const Center(
                    child: TextView(
                      text: "No More Matches !",
                      color: ColorPallete.grey,
                      fontSize: 16,
                    ),
                  ),
                )
                    : MyListView(
                  children: controller.searchMacthes
                      .map(
                        (e) => MatchCardWidget(
                      profile: e,
                      sendInterest: () async {
                        return await Get.find<MatchController>()
                            .sendInterestTo(e, context)
                            .then(
                              (value) {
                            value == true
                                ? controller.searchMacthes
                                .remove(e)
                                : () {};
                            return value;
                          },
                        );
                      },
                      addToShortlist: () async {
                        return await Get.find<MatchController>()
                            .addToShorlist(e)
                            .then((value) {
                          value == true
                              ? controller.searchMacthes.remove(e)
                              : () {};
                          return value;
                        });
                      },
                    ),
                  )
                      .toList(),
                ),
                if (controller.isLoading.value) const Loading()
              ],
            ),
        ),
    );
  }
}
