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
*🔸🤵 स्थळ :* ${getValue(fullProfile?.religion ?? widget.profile.religion)} - ${getValue(fullProfile?.caste ?? widget.profile.caste)}
*🔸 🆔* $profileId
*🔸 नाव :* $firstName
*🔸 जन्मतारीख :* $dob
*🔸 शिक्षण :* ${getValue(fullProfile?.education)}
*🔸 नोकरी / व्यवसाय :* ${getValue(fullProfile?.occupation)}
*🔸 वार्षिक पगार / उत्पन्न :* ${getValue(fullProfile?.annualIncome)}
*🔸 मुळगाव :* ${getValue(fullProfile?.nativePlace ?? fullProfile?.birthplace)}
*🔸 सध्याचा पत्ता :* ${getValue(fullProfile?.location ?? widget.profile.location)}
*🔸 अपेक्षा :* ${getValue(fullProfile?.partnerPreferance?.generalExpt)}

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

      bool sharedWithImage = false;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          final tempDir = await getTemporaryDirectory();
          final filePath = '${tempDir.path}/profile_${widget.profile.profileId ?? 'card'}.jpg';

          await Dio().download(imageUrl, filePath, options: Options(
            sendTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ));

          await Share.shareXFiles(
            [XFile(filePath)],
            text: shareText,
          );
          sharedWithImage = true;
        } catch (imageError) {
          print("Error downloading or sharing image: $imageError");
          // Fall back to text-only share if image sharing fails
        }
      }

      if (!sharedWithImage) {
        await Share.share(shareText);
      }
    } catch (e) {
      print("Global share error: $e");
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

  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0 * fem, vertical: 15 * fem),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10 * fem),
            boxShadow: [
              BoxShadow(
                color: ColorPallete.grey.withOpacity(0.25),
                blurRadius: 15 * fem,
                spreadRadius: 5 * fem,
                offset: Offset(0, 2.5 * fem),
              )
            ]),
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
          child: RoundedContainer(
            radius: 10,
            clip: Clip.antiAliasWithSaveLayer,
            color: ColorPallete.theme,
            child: MyListView(
              children: [
                RoundedContainer(
                  radius: 10,
                  // clip: Clip.antiAliasWithSaveLayer,
                  color: ColorPallete.primary.withOpacity(0.25),
                  height: MediaQuery.of(context).size.height / 3 * fem,
                  child: Stack(
                    children: [
                      MyListView(
                        children: [
                          CachedNetworkImage(
                            imageUrl: (widget.profile.photo1 ?? "") == ""
                                ? ""
                                : Urls.getImageUrl(widget.profile.photo1!),
                            placeholder: (context, url) {
                              return Image.asset(
                                "assets/ui/logo.jpeg",
                                height: 100 * fem,
                              );
                            },
                            fit: BoxFit.fill,
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
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: RoundedContainer(
                          radius: 0,
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
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: MyListView(
                              children: [
                                TextView(
                                  text: widget.profile.name
                                      .toString()
                                      .capitalize!,
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
                                _getDataEntry("स्थळ", "${widget.profile.religion ?? ''} - ${widget.profile.caste ?? ''}"),
                                _getDataEntry("जन्म ता", widget.profile.dob),
                                _getDataEntry("जन्म वेळ", widget.profile.birthtime),
                                _getDataEntry("शिक्षण", widget.profile.education),
                                _getDataEntry("नोकरी", widget.profile.occupation),
                                _getDataEntry("वार्षिक पॅकेज", widget.profile.annualIncome),
                                _getDataEntry("सध्या", widget.profile.location),
                                _getDataEntry("मुळगाव", widget.profile.birthplace),
                                _getDataEntry("स्थावर", widget.profile.assets),
                                _getDataEntry("अपेक्षा", widget.profile.expectations),
                              ],
                            ),
                          ),
                        ),
                      ),
                      (widget.view ?? "") == "BLOCKED"
                          ? Positioned(
                              bottom: 10 * fem,
                              right: 10 * fem,
                              child: InkWell(
                                onTap: () {
                                  if (widget.unblockProfile != null) {
                                    widget.unblockProfile!();
                                  }
                                },
                                child: RoundedContainer(
                                  radius: 10,
                                  color: Colors.green,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15.0 * fem,
                                        vertical: 10 * fem),
                                    child: const TextView(
                                      text: "Un Block",
                                      fontSize: 16,
                                      color: ColorPallete.theme,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
                (widget.view ?? "") == "SENT_INTEREST"
                    ? _sentInterestBottom(fem)
                    : (widget.view ?? "") == "RECEIVED_INTEREST"
                        ? _receivedInterestBottom(fem)
                        : !["BLOCKED", "SENT_INTEREST"]
                                .contains((widget.view ?? ""))
                            ? _getDefaultMatchCardBotom(fem, widget.profile.phone)
                            : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
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

  _getDefaultMatchCardBotom(double fem, String? number) {
    return Padding(
      padding: EdgeInsets.all(10.0 * fem),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10 * fem),
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
                        'NA',                     // Title of the snackbar
                        'Number not available',  // Message of the snackbar
                        snackPosition: SnackPosition.BOTTOM,  // Position of the snackbar
                        backgroundColor: Colors.blueAccent,  // Background color
                        colorText: Colors.white,     // Text color
                        icon: Icon(Icons.info, color: Colors.white),  // Optional icon
                        duration: Duration(seconds: 3),  // Duration to display the snackbar
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: ColorPallete.primary,
                    radius: 20,
                    child: contactLoading
                        ? Padding(
                            padding: EdgeInsets.all(5 * fem),
                            child: const CircularProgressIndicator(
                              color: ColorPallete.theme,
                            ),
                          )
                        : Icon(
                            Icons.call,
                            color: ColorPallete.theme,
                            size: 20 * fem,
                          ),
                  ),
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
                        'NA',                     // Title of the snackbar
                        'Number not available',  // Message of the snackbar
                        snackPosition: SnackPosition.BOTTOM,  // Position of the snackbar
                        backgroundColor: Colors.blueAccent,  // Background color
                        colorText: Colors.white,     // Text color
                        icon: Icon(Icons.info, color: Colors.white),  // Optional icon
                        duration: Duration(seconds: 3),  // Duration to display the snackbar
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: ColorPallete.primary,
                    radius: 20,
                    child: chatLoading
                        ? Padding(
                            padding: EdgeInsets.all(5 * fem),
                            child: const CircularProgressIndicator(
                              color: ColorPallete.theme,
                            ),
                          )
                        : Icon(
                            Icons.chat,
                            color: ColorPallete.theme,
                            size: 20 * fem,
                          ),
                  ),
                ),
                if (Get.find<AuthService>().currentUserRole == "1")
                  InkWell(
                    onTap: _shareProfile,
                    child: CircleAvatar(
                      backgroundColor: ColorPallete.primary,
                      radius: 20,
                      child: shareLoading
                          ? Padding(
                        padding: EdgeInsets.all(5 * fem),
                        child: const CircularProgressIndicator(
                          color: ColorPallete.theme,
                        ),
                      )
                          : Icon(
                        Icons.share,
                        color: ColorPallete.theme,
                        size: 20 * fem,
                      ),
                    ),
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
                  child: CircleAvatar(
                    backgroundColor: ColorPallete.primary,
                    radius: 20,
                    child: shortListLoading
                        ? Padding(
                            padding: EdgeInsets.all(5 * fem),
                            child: const CircularProgressIndicator(
                              color: ColorPallete.theme,
                            ),
                          )
                        : Icon(
                            widget.addToShortlist == null
                                ? Icons.star
                                : Icons.star_outline,
                            color: ColorPallete.theme,
                            size: 25 * fem,
                          ),
                  ),
                ),
              ],
            ),
          )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
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
                  child: RoundedContainer(
                    radius: 20,
                    color: ColorPallete.primary,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20 * fem, vertical: 10.0 * fem),
                      child: Center(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.favorite,
                              color: ColorPallete.theme,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5 * fem,
                            ),
                            TextView(
                              text: loading
                                  ? "Updating .."
                                  : interestSent
                                      ? "Interest Sent"
                                      : "Send Interest",
                              color: ColorPallete.theme,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _sentInterestBottom(double fem) {
    return Container(
      color: widget.status == "Pending"
          ? Colors.amber
          : widget.status == "Rejected"
              ? ColorPallete.red
              : Colors.green,
      child: Padding(
        padding: EdgeInsets.all(10.0 * fem),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedContainer(
                    radius: 20,
                    color: widget.status == "Pending"
                        ? Colors.amber
                        : widget.status == "Rejected"
                            ? ColorPallete.red
                            : Colors.green,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20 * fem, vertical: 10.0 * fem),
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              widget.status == "Pending"
                                  ? Icons.pending
                                  : widget.status == "Rejected"
                                      ? Icons.close
                                      : Icons.check,
                              color: ColorPallete.theme,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5 * fem,
                            ),
                            TextView(
                              text: widget.status!,
                              color: ColorPallete.theme,
                              fontSize: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _receivedInterestBottom(double fem) {
    return Padding(
      padding: EdgeInsets.all(10.0 * fem),
      child: Row(
        children: [
          loading
              ? const Expanded(
                  child: Center(
                  child: CircularProgressIndicator(
                    color: ColorPallete.primary,
                  ),
                ))
              : Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (widget.updateInterestStatus != null) {
                            loading = true;
                            setState(() {});
                            widget.updateInterestStatus!("Rejected")
                                .then((value) {
                              loading = false;
                              if (value) {
                                interestSent = !interestSent;
                              }
                              setState(() {});
                            });
                          }
                        },
                        child: RoundedContainer(
                          radius: 20,
                          color: ColorPallete.red,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30 * fem, vertical: 10.0 * fem),
                            child: Center(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.close,
                                    color: ColorPallete.theme,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5 * fem,
                                  ),
                                  const TextView(
                                    text: "Reject",
                                    color: ColorPallete.theme,
                                    weight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (widget.updateInterestStatus != null) {
                            loading = true;
                            setState(() {});
                            widget.updateInterestStatus!("Accepted")
                                .then((value) {
                              loading = false;
                              if (value) {
                                interestSent = !interestSent;
                              }
                              setState(() {});
                            });
                          }
                        },
                        child: RoundedContainer(
                          radius: 20,
                          color: Colors.green,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30 * fem, vertical: 10.0 * fem),
                            child: Center(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: ColorPallete.theme,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5 * fem,
                                  ),
                                  const TextView(
                                    text: "Accept",
                                    color: ColorPallete.theme,
                                    weight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
