import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/color_pallete.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../../models/my_package_details.dart';
import '../../../routes/app_routes.dart';
import '../controllers/settings_controller.dart';

class MyPackageScreen extends GetView<SettingsController> {
  const MyPackageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: ColorPallete.theme),
        backgroundColor: ColorPallete.primary,
        title: const TextView(
          text: "My Package",
          color: ColorPallete.theme,
          fontSize: 18,
          weight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  controller.fetchMyPackage();
                  return Future.value();
                },
                child: Obx(
                          () => controller.isMyPackageLoading.value
                          ? const SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(color: ColorPallete.primary),
                        ),
                      )
                          : controller.myPackage.value.packageDetails == null
                          ? const SizedBox(
                        height: 200,
                        child: Center(
                            child: TextView(
                              text: "No Package Found !",
                              color: ColorPallete.grey,
                              fontSize: 16,
                            )),
                      )
                          : MyPackageWidget(
                        myPackage: controller.myPackage.value,
                      ),
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: RoundedContainer(
                onPressed: () {
                  Get.toNamed(Routes.PACKAGES);
                },
                radius: 10,
                height: 50,
                color: ColorPallete.primary,
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: TextView(
                      text: "See All Packages",
                      color: ColorPallete.theme,
                      weight: FontWeight.bold,
                      fontSize: 14,
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

class MyPackageWidget extends StatelessWidget {
  final MyPackageDetails myPackage;
  const MyPackageWidget({super.key, required this.myPackage});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: ColorPallete.grey.withOpacity(0.25),
                blurRadius: 15,
                spreadRadius: 5,
                offset: Offset(0, 2.5),
              )
            ]),
        child: RoundedContainer(
          radius: 10,
          color: ColorPallete.theme,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: ColorPallete.grey.withOpacity(0.25),
                          blurRadius: 15,
                          spreadRadius: 5,
                          offset: Offset(0, 2.5),
                        )
                      ]),
                  child: RoundedContainer(
                    radius: 10,
                    color: ColorPallete.theme,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          TextView(
                            text: myPackage.packageDetails!.packName!,
                            fontSize: 14,
                            weight: FontWeight.bold,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.radio_button_checked,
                            color: Colors.green,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextView(
                            text:
                                "${(myPackage.userCount!.isActive ?? false) ? "ACTIVE" : "IN ACTIVE"} Plan",
                            color: (myPackage.userCount!.isActive ?? false)
                                ? Colors.green
                                : ColorPallete.red,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                EntryWidget(
                    title: "Total Amount Paid",
                    value: "₹ ${myPackage.packageDetails!.packAmmount}/-"),
                EntryWidget(
                    title: "Total Interests",
                    value:
                        "${myPackage.userCount!.totalInterest} / ${myPackage.packageDetails!.totalInterest}"),
                EntryWidget(
                    title: "Total WhatsApp Chats",
                    value:
                        "${myPackage.userCount!.totalChat} / ${myPackage.packageDetails!.totalChat}"),
                EntryWidget(
                    title: "Total Contacts",
                    value:
                        "${myPackage.userCount!.totalContact} / ${myPackage.packageDetails!.totalContact}"),
                EntryWidget(
                    title: "Days Remaining",
                    value:
                        "${myPackage.userCount!.daysRemaining} days"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EntryWidget extends StatelessWidget {
  final String title;
  final String? value;
  const EntryWidget({super.key, required this.title, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextView(
            text: "${title} : ",
            fontSize: 14,
            color: ColorPallete.secondary,
          ),
          const Spacer(),
          TextView(
            text: (value ?? "") == "" ? "N/A" : value!,
            fontSize: 14,
            // maxlines: 2,
            // overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
