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
import '../../../models/api_response.dart';
import '../../../models/mathc_profile_model.dart';
import '../../../models/profile_details_model.dart';
import '../../../providers/api_endpoints.dart';
import '../../../repositories/matches_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
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
      print("Fetching full profile for sharing: ${widget.profile.profileId}");

      // Fetch full details
      final response = await MatchesRepository().fetchProfileDetails({"id": widget.profile.profileId});

      ProfileDetails? fullProfile;
      if (response.status == Status.COMPLETED) {
        fullProfile = response.data as ProfileDetails;
      }

      String getValue(String? val, {bool checkNumeric = true}) {
        if (val == null || val.isEmpty || val == 'null' || val == 'N/A' || val == 'undefined') return '-';
        if (checkNumeric && RegExp(r'^\d+$').hasMatch(val.trim())) return '-';
        return '$val';
      }

      String profileId = widget.profile.profileId ?? '-';
      String fullName = fullProfile?.name ?? widget.profile.name ?? '';
      String firstName = fullName.split(' ').first;
      if (firstName.isEmpty) firstName = '-';

      String dob = getValue(fullProfile?.dob ?? widget.profile.dob);
      if (dob != '-') {
        try {
          DateTime date = DateFormat("yyyy-MM-dd").parse(dob);
          dob = DateFormat("dd-MM-yyyy").format(date);
        } catch (e) {
          // if it's already in dd-MM-yyyy or other format, keep it
        }
      }

      final currentUser = Get.find<AuthService>().user.value;
      String bLoc = (currentUser.location == null || currentUser.location!.isEmpty || currentUser.location == 'null') ? '-' : currentUser.location!;
      String bMob = (currentUser.mobile == null || currentUser.mobile!.isEmpty || currentUser.mobile == 'null') ? '-' : currentUser.mobile!;

      final String shareText = '''
🔸🤵 स्थळ :* ${getValue(fullProfile?.religion ?? widget.profile.religion)} - ${getValue(fullProfile?.caste ?? widget.profile.caste)}
🔸 🆔 $profileId
🔸नाव :* $firstName
🔸जन्मतारीख :* $dob
🔸शिक्षण :* ${getValue(fullProfile?.education)}
🔸नोकरी / व्यवसाय :* ${getValue(fullProfile?.occupation)}
🔸वार्षिक पगार / उत्पन्न :* ${getValue(fullProfile?.annualIncome)}
🔸मुळगाव :* ${getValue(fullProfile?.birthplace)}
🔸सध्याचा पत्ता :* ${getValue(fullProfile?.location ?? widget.profile.location)}
🔸अपेक्षा :* ${getValue(fullProfile?.partnerPreferance?.generalExpt)}

*अधिक माहितीसाठी खालील लिंक वर क्लिक करावे.👇*       
https://www.marathisoyrik.in/viewFullProfile.php?id=$profileId

🌺🌺🌺🌺🌺🌺

*संपर्क : मराठा सोयरीक संस्था,*
महाराष्ट्रातील नं. १ विश्वसनीय वधुवर सुचक संस्था 
*आमच्या शाखा*  
$bLoc $bMob
*वेळ : स.10 ते सायं.7 पर्यंत*
👩‍❤️‍👨   👩‍❤️‍👨   👩‍❤️‍👨  👩‍❤️‍👨  👩‍❤️‍👨
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
                //  if (Get.find<AuthService>().currentUserRole == "1")
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