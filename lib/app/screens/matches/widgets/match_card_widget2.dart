import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/color_pallete.dart';
import '../../../components/ui/my_list_view.dart';
import '../../../components/ui/rounded_container.dart';
import '../../../components/ui/text_view.dart';
import '../../../models/mathc_profile_model.dart';
import '../../../providers/api_endpoints.dart';
import '../../../routes/app_routes.dart';
import '../controllers/match_controller.dart';

class MatchCardWidget extends StatefulWidget {
  final MatchProfile profile;
  final String? view;
  final String? status;
  final Future<bool> Function()? sendInterest;
  final Future<bool> Function()? addToShortlist;
  final Future<bool> Function()? unblockProfile;
  final Future<bool> Function(String ststus)? updateInterestStatus;

  const MatchCardWidget(
      {super.key,
        required this.profile,
        this.sendInterest,
        this.addToShortlist,
        this.view,
        this.status,
        this.unblockProfile,
        this.updateInterestStatus});

  @override
  State<MatchCardWidget> createState() => _MatchCardWidgetState();
}

class _MatchCardWidgetState extends State<MatchCardWidget> {
  bool interestSent = false;
  bool loading = false;
  bool contactLoading = false;
  bool chatLoading = false;
  bool shortListLoading = false;
  bool shareLoading = false;

  @override
  Widget build(BuildContext context) {
    double fem = 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 50.0),
      child: InkWell(
        onTap: () async {
          Get.find<MatchController>()
              .viewedProfile(widget.profile, context)
              .then((value) {
            if (value) {
              Get.toNamed(Routes.PROFILE_DETAILS,
                  arguments: {"profile": widget.profile});
            }
          });
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: (widget.profile.photo1 ?? "") == ""
                          ? ""
                          : Urls.getImageUrl(widget.profile.photo1!),
                      placeholder: (context, url) {
                        return Image.asset(
                          "assets/ui/logo.jpeg",
                          height: 100 * fem,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return RoundedContainer(
                          radius: 0,
                          child: Center(
                            child: Image.asset(
                              "assets/ui/logo.jpeg",
                              height: 100 * fem,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  RoundedContainer(
                      radius: 20,
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            ColorPallete.secondary.withOpacity(0.5),
                            ColorPallete.secondary
                          ],
                          stops: const [
                            0.25,
                            1
                          ])),
                ],
              ),
            ),
            Positioned(
              bottom: -50,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  RoundedContainer(
                    radius: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: MyListView(
                        children: [
                          TextView(
                            text: widget.profile.name.toString().capitalize!,
                            fontSize: 16,
                            color: ColorPallete.theme,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 10 * fem,
                          ),
                          // _getDataEntry("Occupation", "XYZ"),
                          // _getDataEntry("Education", "MNO"),
                          // _getDataEntry("Income", "PQR"),
                          _getDataEntry("Profile Id", widget.profile.profileId),
                          _getDataEntry("Age & Height",
                              "${((widget.profile.dob ?? "") == "" ? 1 : DateTime.now().difference(DateFormat("yyyy-MM-dd").parse(widget.profile.dob ?? "")).inDays / 365).toStringAsFixed(0)} | ${widget.profile.height} ft"),
                          _getDataEntry("Religion", widget.profile.religion),
                          _getDataEntry("Caste", widget.profile.caste),
                          _getDataEntry("Location", widget.profile.location),
                        ],
                      ),
                    ),
                  ),
                  _getDefaultMatchCardBottom(widget.profile.mobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _shareProfile() async {
    setState(() {
      shareLoading = true;
    });

    try {
      print("Sharing profile data: ${widget.profile.toJson()}");

      String profileId = widget.profile.profileId ?? '';
      String name = widget.profile.name ?? '';
      String idDisplay = "$profileId-$name";

      final String shareText = '''
▪️ 🤵 स्थळ : ${widget.profile.religion ?? 'N/A'}-${widget.profile.caste ?? 'N/A'}
▪️ 🆔 : $idDisplay
▪️ जन्म ता : ${widget.profile.dob ?? 'N/A'}
▪️ जन्मवेळ : ${widget.profile.birthtime ?? 'N/A'}
▪️ शिक्षण : ${widget.profile.education ?? 'N/A'}
▪️ *व्यवसाय : ${widget.profile.occupation ?? 'N/A'}*
▪️ वार्षिक उत्पन्न : ${widget.profile.annualIncome ?? 'N/A'}
▪️ मुळगाव : ${widget.profile.birthplace ?? 'N/A'}
▪️ सध्या : ${widget.profile.location ?? 'N/A'}
▪️ स्थावर : ${widget.profile.assets ?? 'N/A'}
▪️ अपेक्षा : ${widget.profile.expectations ?? 'N/A'}
▪️ अधिक माहितीसाठी खालील लिंक वर टच करून पहावे👇        
https://www.marathisoyrik.in/viewFullProfile.php?id=$profileId

🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩
संपर्क:
अहिल्यानगर (अ.नगर)
वैष्णवी कॉम्प्लेक्स, जगदंबा क्लॉथ समोर, भिस्तबाग चौक, पाईपलाईन रोड,
अहिल्यानगर (अ.नगर) - ४१४००१, महाराष्ट्र. 📞 7447785910 / 8847724680

पुणे
कान्हूर पठार पतसंस्थेच्या वर, पुणे-नगर हायवे टच,
चंदननगर, पुणे. 📞 7020281282

नाशिक
शॉप नंबर 157, दुसरा मजला स्टार प्लस बिल्डिंग,
मुक्तिधाम गार्डनच्या जवळ, नाशिक रोड, नाशिक. 📞 8453902222

🚩🚩🚩🚩🚩🚩🚩🚩🚩🚩
श्री व सौ वधू वर सूचक केंद्र
📱वेळ स. 9.00 ते सायं. 8.00  
🚩👫🚩👫🚩👫🚩👫🚩
''';

      final imageUrl = (widget.profile.photo1 ?? "").isNotEmpty
          ? Urls.getImageUrl(widget.profile.photo1!)
          : null;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        final tempDir = await getTemporaryDirectory();
        final filePath = '${tempDir.path}/profile_${widget.profile.profileId ?? 'card'}.jpg';

        await Dio().download(imageUrl, filePath);

        await Share.shareXFiles(
          [XFile(filePath)],
          text: shareText,
        );
      } else {
        await Share.share(shareText);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to share profile right now',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        shareLoading = false;
      });
    }
  }

  _getDataEntry(String title, String? value) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: TextView(
            text: title.capitalize!,
            fontSize: 14,
            weight: FontWeight.w600,
            color: ColorPallete.theme,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: TextView(
            text: " : ",
            fontSize: 14,
            weight: FontWeight.w600,
            color: ColorPallete.theme,
          ),
        ),
        Expanded(
          flex: 2,
          child: TextView(
            text: (value ?? "") == "" ? "N/A" : value!,
            fontSize: 14,
            weight: FontWeight.w600,
            color: ColorPallete.theme,
          ),
        ),
      ],
    );
  }

  _getDefaultMatchCardBottom(String? number) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (number != null && number != "NA") {
                        contactLoading = true;
                        setState(() {});
                        Get.find<MatchController>()
                            .contactProfile(widget.profile, context)
                            .then((value) {
                          setState(() {
                            contactLoading = false;
                          });
                          if (value) {
                            final Uri telLaunchUri = Uri(
                              scheme: 'tel',
                              path: number,
                            );
                            launchUrl(telLaunchUri);
                          }
                        });
                      } else {
                        Get.snackbar(
                          'NA',
                          'Number not available',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blueAccent,
                          colorText: Colors.white,
                          icon: const Icon(Icons.info, color: Colors.white),
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                    child: _getBottomItem("Call", Icons.call, contactLoading),
                  ),
                  InkWell(
                    onTap: () async {
                      if (number != null && number != "NA") {
                        chatLoading = true;
                        setState(() {});
                        Get.find<MatchController>()
                            .chatProfile(widget.profile, context)
                            .then((value) {
                          setState(() {
                            chatLoading = false;
                          });
                          if (value) {
                            _launchWhatsapp(context, number);
                          }
                        });
                      } else {
                        Get.snackbar(
                          'NA',
                          'Number not available',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.blueAccent,
                          colorText: Colors.white,
                          icon: const Icon(Icons.info, color: Colors.white),
                          duration: const Duration(seconds: 3),
                        );
                      }
                    },
                    child: _getBottomItem("Message", Icons.chat, chatLoading),
                  ),
                  InkWell(
                    onTap: _shareProfile,
                    child: _getBottomItem("Share", Icons.share, shareLoading),
                  ),
                  InkWell(
                    onTap: () async {
                      if (widget.addToShortlist != null) {
                        setState(() {
                          shortListLoading = true;
                        });
                        widget.addToShortlist!().then((value) {
                          setState(() {
                            shortListLoading = false;
                          });
                        });
                      }
                    },
                    child: _getBottomItem("Shortlist", Icons.star, shortListLoading),
                  ),
                  InkWell(
                    onTap: () async {
                      if (widget.sendInterest != null) {
                        loading = true;
                        setState(() {});
                        widget.sendInterest!().then((value) {
                          loading = false;
                          if (value) {
                            interestSent = !interestSent;
                          }
                          setState(() {});
                        });
                      }
                    },
                    child: _getBottomItem(
                        interestSent ? "Sent" : "Interest",
                        Icons.check_circle,
                        loading),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getBottomItem(String text, IconData iconData, [bool isLoading = false]) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: ColorPallete.primary,
          radius: 22,
          child: isLoading
              ? const Padding(
            padding: EdgeInsets.all(6.0),
            child: CircularProgressIndicator(
              color: ColorPallete.theme,
              strokeWidth: 2,
            ),
          )
              : Icon(
            iconData,
            color: ColorPallete.theme,
            size: 20,
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        TextView(
          text: text,
          color: Colors.black,
          fontSize: 10.0,
        ),
      ],
    );
  }

  _launchWhatsapp(context, String number) async {
    var whatsapp = number;
    var whatsappAndroid = Uri.parse("whatsapp://send?phone=$whatsapp&text=");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WhatsApp is not installed on the device"),
        ),
      );
    }
  }
}