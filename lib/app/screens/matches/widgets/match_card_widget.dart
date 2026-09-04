import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

      String profileId = widget.profile.profileId ?? '';
      String name = fullProfile?.name ?? widget.profile.name ?? '';
      String idDisplay = "$profileId-$name";

      final String shareText = '''
▪️ 🤵 स्थळ : ${fullProfile?.religion ?? widget.profile.religion ?? 'N/A'}-${fullProfile?.caste ?? widget.profile.caste ?? 'N/A'}
▪️ 🆔 : $idDisplay
▪️ जन्म ता : ${fullProfile?.dob ?? widget.profile.dob ?? 'N/A'}
▪️ जन्मवेळ : ${fullProfile?.birthtime ?? 'N/A'}
▪️ शिक्षण : ${fullProfile?.education ?? 'N/A'}
▪️ *व्यवसाय : ${fullProfile?.occupation ?? 'N/A'}*
▪️ वार्षिक उत्पन्न : ${fullProfile?.annualIncome ?? 'N/A'}
▪️ मुळगाव : ${fullProfile?.birthplace ?? 'N/A'}
▪️ सध्या : ${fullProfile?.location ?? widget.profile.location ?? 'N/A'}
▪️ स्थावर : ${fullProfile?.residance ?? 'N/A'}
▪️ अपेक्षा : ${fullProfile?.partnerPreferance?.generalExpt ?? 'N/A'}
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
मराठी सोयरीक संस्था
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
