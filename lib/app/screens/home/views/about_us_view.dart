import 'package:matrimony/app/constants/constants_assets.dart';
import 'package:matrimony/app/constants/constants_brand_details.dart';

import '../../../../common/color_pallete.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/utils.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../controllers/home_controller.dart';

// ignore: must_be_immutable
class AboutUsView extends GetView<HomeController> {
  const AboutUsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    // double ffem = fem * 0.97;
    return Scaffold(
      extendBody: true,
      backgroundColor: ColorPallete.primary,
      body: SafeArea(
        child: Scaffold(
          backgroundColor: ColorPallete.theme,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: ColorPallete.theme),
            backgroundColor: ColorPallete.primary,
            title: const TextView(
              text: "About Us",
              color: ColorPallete.theme,
              fontSize: 18,
              weight: FontWeight.bold,
            ),
            centerTitle: true,
          ),
          body: RoundedContainer(
            radius: 0,
            // height: MediaQuery.of(context).size.height,
            child: Container(
              color: ColorPallete.primary,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0 * fem, vertical: 10),
                      child: RoundedContainer(
                        radius: 10,
                        color: ColorPallete.theme,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Center(
                            child: MyListView(
                              children: [
                                Center(
                                  child: Image.asset(
                                    Assets.LOGO,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: TextView(
                                    text: BrandDetailsConstant.BRAND_NAME,
                                    fontSize: 20,
                                    color: ColorPallete.primary,
                                    weight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: TextView(
                                    text: "All Rights Reserved.",
                                    fontSize: 14,
                                    color: ColorPallete.secondary,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: TextView(
                                    text: "Version ${BrandDetailsConstant.VERSION_NAME}",
                                    fontSize: 14,
                                    color: ColorPallete.secondary,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextView(
                                        text: "Contact Us :",
                                        fontSize: 14,
                                        color: ColorPallete.secondary,
                                        weight: FontWeight.w400,
                                      ),
                                      TextView(
                                        text: BrandDetailsConstant.EMAIL,
                                        fontSize: 14,
                                        color: ColorPallete.primary,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextView(
                                        text: "Website :",
                                        fontSize: 14,
                                        color: ColorPallete.secondary,
                                        weight: FontWeight.w400,
                                      ),
                                      TextView(
                                        text: BrandDetailsConstant.WEBSITE,
                                        softWrap: true,
                                        fontSize: 14,
                                        color: ColorPallete.primary,
                                        weight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Center(
                                  child: TextView(
                                    text: "Address",
                                    fontSize: 16,
                                    color: ColorPallete.secondary,
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Center(
                                  child: TextView(
                                    text: BrandDetailsConstant.ADDRESS,
                                    fontSize: 14,
                                    color: ColorPallete.secondary,
                                    weight: FontWeight.w600,
                                    alignment: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
