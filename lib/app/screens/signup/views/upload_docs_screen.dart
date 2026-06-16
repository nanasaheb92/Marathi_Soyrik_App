import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/app/constants/constants_assets.dart';

import '../../../../common/color_pallete.dart';
import '../../../components/ui/image_input.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../../providers/api_endpoints.dart';
import '../controllers/sign_up_controller.dart';

class UploadDocumentsScreen extends GetView<SignUpController> {
  UploadDocumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchUploadData();
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
                    _headerSectionWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            /*_uploadImageWidget(
                              title: "Upload ID Proof (Preferably Aadhaar Card)",
                              buttonText: "Upload Proof",
                              callback: (img) {
                                controller.idProofFilepath.value = img;
                                controller.idProofFilepath.refresh();
                              },
                              imgUrl: controller.idProof.value,
                              imgFilepath: controller.idProofFilepath.value,
                            ),*/
                            SizedBox(
                              height: 25,
                            ),
                            _uploadImageWidget(
                              title: "Upload Your Photo For Profile",
                              buttonText: "Upload Photo",
                              callback: (img) {
                                controller.photo1Filepath.value = img;
                                controller.photo1Filepath.refresh();
                              },
                              imgUrl: controller.photo1.value,
                              imgFilepath: controller.photo1Filepath.value,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            _uploadImageWidget(
                              title: "Upload Your Photo 2 For Profile",
                              buttonText: "Upload Photo",
                              callback: (img) {
                                controller.photo2Filepath.value = img;
                                controller.photo2Filepath.refresh();
                              },
                              imgUrl: controller.photo2.value,
                              imgFilepath: controller.photo2Filepath.value,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            _uploadImageWidget(
                              title: "Upload Photo 3 For Profile",
                              buttonText: "Upload Photo",
                              callback: (img) {
                                controller.photo3Filepath.value = img;
                                controller.photo3Filepath.refresh();
                              },
                              imgUrl: controller.photo3.value,
                              imgFilepath: controller.photo3Filepath.value,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            _uploadImageWidget(
                              title: "Upload Photo 4 For Profile",
                              buttonText: "Upload Photo",
                              callback: (img) {
                                controller.photo4Filepath.value = img;
                                controller.photo4Filepath.refresh();
                              },
                              imgUrl: controller.photo4.value,
                              imgFilepath: controller.photo4Filepath.value,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _bottomSectionWidget()
                  ],
                ),
                if (controller.isDocsUploadLoading.value)
                  _circularProgressIndicatorOpaque(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circularProgressIndicatorOpaque() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5), // Semi-transparent background
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _uploadImageWidget({
    required String title,
    required String buttonText,
    required dynamic Function(String) callback,
    required String imgUrl,
    required String imgFilepath,
  }) {
    imgUrl = Urls.baseUrl + imgUrl;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: TextView(
            text: title,
            color: ColorPallete.primary,
            fontSize: 14,
            weight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        ImageInput(
          callback: callback,
          child: Container(
            decoration: BoxDecoration(
                color: ColorPallete.theme,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: ColorPallete.grey.withOpacity(0.4), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))]),
            child: imgFilepath != ""
                ? RoundedContainer(
                    radius: 10,
                    height: 150,
                    child: Image.file(File(imgFilepath)),
                  )
                : imgUrl != ""
                    ? Center(
                        child: RoundedContainer(
                          radius: 10,
                          height: 150,
                          child: CachedNetworkImage(
                            imageUrl: imgUrl,
                            placeholder: (context, url) {
                              return Image.asset(
                                Assets.LOGO,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.fitHeight,
                              );
                            },
                            //width: double.infinity,
                            //alignment: Alignment.topCenter,
                            // Aligns the image to the top
                            fit: BoxFit.fitHeight,
                            errorWidget: (context, url, error) {
                              return RoundedContainer(
                                radius: 0,
                                child: Center(
                                  child: Image.asset(
                                    Assets.LOGO,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : RoundedContainer(
                        radius: 10,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                          child: TextView(
                            text: buttonText,
                            color: ColorPallete.grey,
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }

  Widget _headerSectionWidget() {
    return Container(
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
    );
  }

  Widget _bottomSectionWidget() {
    return Column(
      children: [

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
                  controller.saveIdProofNProfile();
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
    );
  }
}
