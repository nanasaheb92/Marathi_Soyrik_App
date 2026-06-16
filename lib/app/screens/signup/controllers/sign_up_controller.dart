import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:matrimony/app/models/profile_settings_model.dart';

import '../../../../common/color_pallete.dart';
import '../../../models/api_response.dart';
import '../../../models/master_data_model.dart' as md;
import '../../../models/mathc_profile_model.dart';
import '../../../models/partner_preference_model.dart';
import '../../../models/search_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/membership_repository.dart';
import '../../../repositories/settings_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../home/controllers/home_controller.dart';

class SignUpController extends GetxController {
  late MembershipRepository _membershipRepository;
  late SettingsRepository _settingsRepository;

  SignUpController() {
    _membershipRepository = MembershipRepository();
    _settingsRepository = SettingsRepository();
  }

  Rx<User> user = User().obs;
  late TextEditingController dobController;

  @override
  void onInit() {
    super.onInit();

    dobController = TextEditingController();

    user.value = Get.find<AuthService>().user.value;
    Get.find<AuthService>().user.listen((p0) {
      user.value = p0;
      user.refresh();
    });
    basicDetails.value = BasicDetails.fromJson(user.value.toJson());

    searchMatchesScrollController.addListener(() {
      if (searchMatchesScrollController.position.pixels == searchMatchesScrollController.position.maxScrollExtent && page.value < totalPage.value) {
        page.value = page.value + 1;
        isLoading.value = true;
        Future.delayed(const Duration(milliseconds: 500), () {
          searchMatchesScrollController.jumpTo(searchMatchesScrollController.position.maxScrollExtent);
          getSearchMatches(false);
        });
      }
    });
    isAuthenticated.value = Get.arguments?["isLoggedIn"] ?? false;
    fetchData();
  }

  RxBool isAuthenticated = false.obs;
  RxInt selectedTile = 1.obs;

  RxString image = "".obs;
  Rx<ProfileSettings> profileSettings = ProfileSettings().obs;
  Rx<BasicDetails> basicDetails = BasicDetails().obs;
  Rx<ReligiousDetails> religiousDetails = ReligiousDetails().obs;
  Rx<EducationDetails> educationDetails = EducationDetails().obs;
  Rx<LifestyleDetails> lifestyleDetails = LifestyleDetails().obs;
  Rx<LocationDetails> locationDetails = LocationDetails().obs;
  Rx<FamilyDetails> familyDetails = FamilyDetails().obs;

  List<String> profileLabels = [
    "Basic Details",
    "Religious Details",
    "Education Details",
    "Lifestyle Details",
    "Location Details",
    "Family Details",
  ];

  GlobalKey<FormState> profileSettingsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> basicDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> religiousDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> educationDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> lifestyleDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> locationDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> familyDetailsFormKey = GlobalKey<FormState>();

  fetchData() async {
    await fetchBasicDetails();
    await fetchMotherTounges();
    await fetchCountries(true);
    await fetchCastes();
    await fetchEducationalOptions();
  }

  RxList<md.MotherTounge> mothertounges = <md.MotherTounge>[].obs;

  fetchMotherTounges() async {
    await _settingsRepository.fetchMotherToungesOptions().then((value) {
      if (value.status == Status.COMPLETED) {
        mothertounges.value = value.data;
        mothertounges.refresh();
      }
    });
  }

  RxList<md.Caste> castes = <md.Caste>[].obs;

  fetchCastes() async {
    await _settingsRepository.fetchCastes().then((value) {
      if (value.status == Status.COMPLETED) {
        castes.value = value.data;
        castes.refresh();
      }
    });
  }

  RxList<md.Education> educationalOptions = <md.Education>[].obs;

  fetchEducationalOptions() async {
    await _settingsRepository.fetchEductaionOptions().then((value) {
      if (value.status == Status.COMPLETED) {
        educationalOptions.value = value.data;
        educationalOptions.refresh();
      }
    });
  }

  RxList<md.Country> countries = <md.Country>[].obs;
  Rx<md.Country> selectedCountry = md.Country().obs;

  fetchCountries(bool isPref) async {
    countries.value = [];
    states.value = [];
    final value = await _settingsRepository.fetchCountries();

      if (value.status == Status.COMPLETED) {
        countries.value = value.data;
        countries.refresh();
        if (!isPref && locationDetails.value.country != null) {
          onCountryChanged(countries.where((p0) => p0.id.toString() == locationDetails.value.country!).first.name!, isPref);
        } else {
          if (locationPreference.value.country != null) {
            onCountryPrefChanged(countries.where((p0) => p0.id.toString() == locationPreference.value.country!).first.name!, isPref);
          }
        }
      }
  }

  void onCountryChanged(String value, bool isPref) async {
    selectedCountry.value = countries.where((p0) => p0.name == value).first;
    locationDetails.value.country = selectedCountry.value.id.toString();
    // locationDetails.value.state = null;
    // locationDetails.value.city = null;
    await fetchStates(isPref);
  }

  RxList<md.State> states = <md.State>[].obs;
  Rx<md.State> selectedState = md.State().obs;

  fetchStates(bool isPref) async {
    states.value = [];
    cities.value = [];
    await _settingsRepository.fetchStatesByCountry(selectedCountry.value).then((value) {
      if (value.status == Status.COMPLETED) {
        states.value = value.data;
        states.refresh();
        if (!isPref && locationDetails.value.state != null) {
          onStateChanged(states.where((p0) => p0.id.toString() == locationDetails.value.state!).first.name!, isPref);
        } else {
          if (locationPreference.value.state != null) {
            onStatePrefChanged(states.where((p0) => p0.id.toString() == locationPreference.value.state!).first.name!, isPref);
          }
        }
      }
    });
  }

  void onStateChanged(String value, bool isPref) async {
    selectedState.value = states.where((p0) => p0.name == value).first;
    locationDetails.value.state = selectedState.value.id.toString();
    // locationDetails.value.city = null;
    await fetchCities(isPref);
  }

  RxList<md.City> cities = <md.City>[].obs;
  Rx<md.City> selectedCity = md.City().obs;

  fetchCities(bool isPref) async {
    cities.value = [];
    await _settingsRepository.fetchCitiesByState(selectedState.value).then((value) {
      if (value.status == Status.COMPLETED) {
        // cities = <md.City>[].obs;
        cities.value = value.data;
        cities.refresh();
        if (!isPref && locationDetails.value.city != null) {
          onCityChanged(cities.where((p0) => p0.id.toString() == locationDetails.value.city).first.name!, isPref);
        } else {
          if (locationPreference.value.city != null) {
            onCityPrefChanged(cities.where((p0) => p0.id.toString() == locationPreference.value.city!).first.name!, isPref);
          }
        }
      }
    });
  }

  void onCityChanged(String value, bool isPref) async {
    selectedCity.value = cities.where((p0) => p0.name == value).first;
    locationDetails.value.city = selectedCity.value.id.toString();
    locationDetails.refresh();
  }

  RxBool isLoading = false.obs;
  RxBool isProfileSettingsLoading = false.obs;
  RxBool isBasicDetailsLoading = false.obs;
  RxBool isReligiousDetailsLoading = false.obs;
  RxBool isEducationDetailsLoading = false.obs;
  RxBool isLifestyleDetailsLoading = false.obs;
  RxBool isLocationDetailsLoading = false.obs;
  RxBool isFamilyDetailsLoading = false.obs;
  RxBool isBasicPreferenceLoading = false.obs;
  RxBool isReligiousPreferenceLoading = false.obs;
  RxBool isLocationPreferenceLoading = false.obs;
  RxBool isEducationPreferenceLoading = false.obs;
  RxBool isDocsUploadLoading = false.obs;

  String? validateDobForAdults(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'Date Of Birth is required';
    }
    if (!_isAdultDob(value!)) {
      return 'Only users aged 18 or above can register';
    }
    return null;
  }

  bool _isAdultDob(String value) {
    final dob = _parseDob(value);
    if (dob == null) {
      return false;
    }

    final now = DateTime.now();
    var age = now.year - dob.year;
    final hasNotHadBirthday =
        now.month < dob.month || (now.month == dob.month && now.day < dob.day);
    if (hasNotHadBirthday) {
      age -= 1;
    }
    return age >= 18;
  }

  DateTime? _parseDob(String raw) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }

    final direct = DateTime.tryParse(value);
    if (direct != null) {
      return direct;
    }

    final formats = <DateFormat>[
      DateFormat('yyyy-M-d'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('MM/dd/yyyy'),
    ];

    for (final format in formats) {
      try {
        return format.parseStrict(value);
      } catch (_) {
        // Try the next date format.
      }
    }
    return null;
  }

  void validateAndContinue(context) async {
    // selectedTile.value = 6;
    GlobalKey<FormState> key = selectedTile.value == 1
        ? basicDetailsFormKey
        : selectedTile.value == 2
            ? religiousDetailsFormKey
            : selectedTile.value == 3
                ? educationDetailsFormKey
                : selectedTile.value == 4
                    ? lifestyleDetailsFormKey
                    : selectedTile.value == 5
                        ? locationDetailsFormKey
                        : familyDetailsFormKey;
    if (key.currentState!.validate()) {
      var result = false;
      isLoading.value = true;
      switch (selectedTile.value) {
        case 1:
          final dobValidation = validateDobForAdults(basicDetails.value.dOB ?? dobController.text);
          if (dobValidation != null) {
            isLoading.value = false;
            Get.showSnackbar(GetSnackBar(
              backgroundColor: ColorPallete.red,
              duration: const Duration(seconds: 3),
              message: dobValidation,
            ));
            return;
          }
          basicDetails.value.id = user.value.userId;
          result = await _membershipRepository
              .saveBasicDetails(
                basicDetails.value.toJson(),
              )
              .then((value) => value.data);
          if (result) {
            religiousDetails.value = await _membershipRepository.fetchReligiousDetails({"id": user.value.userId}).then((value) => value.data);
          }
          break;
        case 2:
          religiousDetails.value.id = user.value.userId;
          result = await _membershipRepository.saveReligiousDetails(religiousDetails.value.toJson()).then((value) => value.data);
          if (result) {
            educationDetails.value = await _membershipRepository.fetchEducationDetails({"id": user.value.userId}).then((value) => value.data);
          }
          break;
        case 3:
          educationDetails.value.id = user.value.userId;
          result = await _membershipRepository.saveEducationDetails(educationDetails.value.toJson()).then((value) => value.data);
          if (result) {
            lifestyleDetails.value = await _membershipRepository.fetchLifestyleDetails({"id": user.value.userId}).then((value) => value.data);
          }
          break;
        case 4:
          lifestyleDetails.value.id = user.value.userId;
          result = await _membershipRepository.saveLifestyleDetails(lifestyleDetails.value.toJson()).then((value) => value.data);
          if (result) {
            locationDetails.value = await _membershipRepository.fetchLocationDetails({"id": user.value.userId}).then((value) => value.data);

            if ((locationDetails.value.country ?? "") != "") {
              onCountryChanged(countries.where((p0) => p0.id.toString() == locationDetails.value.country).first.name!, false);
            }
          }
          break;
        case 5:
          locationDetails.value.id = user.value.userId;
          result = await _membershipRepository.saveLocationDetails(locationDetails.value.toJson()).then((value) => value.data);
          if (result) {
            familyDetails.value = await _membershipRepository.fetchFamilyDetails({"id": user.value.userId}).then((value) => value.data);
          }
          break;
        case 6:
          familyDetails.value.id = user.value.userId;
          result = await _membershipRepository.saveFamilyDetails(familyDetails.value.toJson()).then((value) => value.data);
          break;
        default:
          result = false;
      }
      isLoading.value = false;
      if (result) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: ColorPallete.primary,
          duration: const Duration(seconds: 2),
          message: "Details ${isAuthenticated.value ? "Updated" : "Submitted"} Successfully !!",
        ));

        if (selectedTile.value == 6) {
          fetchUploadData();
          if (!isAuthenticated.value) {
            Future.delayed(const Duration(seconds: 2), () {
              Get.toNamed(Routes.UPLOAD_DOCS);
            });
          } else {
            Future.delayed(const Duration(seconds: 1), () {
              Get.toNamed(Routes.UPLOAD_DOCS);
            });
          }
        }
        selectedTile.value = selectedTile.value + 1 > profileLabels.length ? profileLabels.length : selectedTile.value + 1;
        selectedTile.refresh();
      } else {
        Get.showSnackbar(const GetSnackBar(
          backgroundColor: ColorPallete.red,
          duration: Duration(seconds: 2),
          message: "Error Occured while Updating Details !",
        ));
      }
    }
  }

  RxString idProof = "".obs;
  RxString idProofFilepath = "".obs;

  //RxString profilePic = "".obs;
  RxString photo1 = "".obs;
  RxString photo2 = "".obs;
  RxString photo3 = "".obs;
  RxString photo4 = "".obs;
  RxString photo1Filepath = "".obs;
  RxString photo2Filepath = "".obs;
  RxString photo3Filepath = "".obs;
  RxString photo4Filepath = "".obs;

  Rx<BasicPreference> basicPreference = BasicPreference().obs;
  Rx<ReligiousPreference> religiousPreference = ReligiousPreference().obs;
  Rx<EducationPreference> educationPreference = EducationPreference().obs;
  Rx<LocationPreference> locationPreference = LocationPreference().obs;

  List<String> preferenceLabels = [
    "Basic Preference",
    "Religious Preference",
    "Location Preference",
    "Education & Occupation",
  ];

  GlobalKey<FormState> basicPreferenceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> religiousPreferenceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> educationPreferenceFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> locationPreferenceFormKey = GlobalKey<FormState>();

  RxInt selectedPreferenceTile = 1.obs;

  void onCountryPrefChanged(String value, bool isPref) async {
    selectedCountry.value = countries.where((p0) => p0.name == value).first;
    locationPreference.value.country = selectedCountry.value.id.toString();
    // locationPreference.value.state = null;
    // locationPreference.value.city = null;
    await fetchStates(isPref);
  }

  void onStatePrefChanged(String value, bool isPref) async {
    selectedState.value = states.where((p0) => p0.name == value).first;
    locationPreference.value.state = selectedState.value.id.toString();
    // locationPreference.value.city = null;
    await fetchCities(isPref);
  }

  void onCityPrefChanged(String value, bool isPref) async {
    selectedCity.value = cities.where((p0) => p0.name == value).first;
    locationPreference.value.city = selectedCity.value.id.toString();
    locationPreference.refresh();
  }

  void validateAndContinue2(context) async {
    // selectedPreferenceTile.value = 4;
    GlobalKey<FormState> key = selectedPreferenceTile.value == 1
        ? basicPreferenceFormKey
        : selectedPreferenceTile.value == 2
            ? religiousPreferenceFormKey
            : selectedPreferenceTile.value == 3
                ? locationPreferenceFormKey
                : educationPreferenceFormKey;
    if (key.currentState!.validate()) {
      var result = false;
      isLoading.value = true;
      switch (selectedPreferenceTile.value) {
        case 1:
          basicPreference.value.vId = user.value.userId;
          result = await _membershipRepository
              .saveBasicPreference(
                basicPreference.toJson(),
              )
              .then((value) => value.data);
          if (result) {
            religiousPreference.value = await _membershipRepository.fetchReligiousPreference({"v_id": user.value.userId}).then((value) => value.data);
          }
          break;
        case 2:
          religiousPreference.value.vId = user.value.userId;
          result = await _membershipRepository.saveReligiousPreference(religiousPreference.toJson()).then((value) => value.data);
          if (result) {
            locationPreference.value = await _membershipRepository.fetchLocationPreference({"v_id": user.value.userId}).then((value) => value.data);

            if ((locationPreference.value.country ?? "") != "") {
              onCountryPrefChanged(countries.where((p0) => p0.id.toString() == locationPreference.value.country!).first.name!, true);
            }
          }
          break;
        case 3:
          locationPreference.value.vId = user.value.userId;
          result = await _membershipRepository.saveLocationPreference(locationPreference.toJson()).then((value) => value.data);
          if (result) {
            educationPreference.value = await _membershipRepository.fetchEducationPreference({"v_id": user.value.userId}).then((value) => value.data);
          }
          break;
        case 4:
          educationPreference.value.vId = user.value.userId;
          result = await _membershipRepository.saveEducationPreference(educationPreference.toJson()).then((value) => value.data);
          break;
        default:
          result = false;
      }
      isLoading.value = false;
      if (result) {
        Get.showSnackbar(GetSnackBar(
          backgroundColor: ColorPallete.primary,
          duration: const Duration(seconds: 2),
          message: "Details ${isAuthenticated.value ? "Updated" : "Submitted"} Successfully !!",
        ));

        if (selectedPreferenceTile.value == 4) {
          if (!isAuthenticated.value) {
            Get.showSnackbar(
              const GetSnackBar(
                duration: Duration(seconds: 3),
                message: "Seting Up App ..\nAnd Going to Home Screen",
              ),
            );
            Future.delayed(const Duration(seconds: 1), () {
              Get.offAllNamed(
                Routes.HOME,
                predicate: (route) => Get.currentRoute == "/home",
              );
              // paymentGateway(context).then((value) {});
            });
          } else {
            Future.delayed(const Duration(seconds: 1), () {
              Get.offAllNamed(
                Routes.HOME,
                predicate: (route) => Get.currentRoute == "/home",
              );
              // paymentGateway(context).then((value) {});
            });
          }
        }
        selectedPreferenceTile.value = selectedPreferenceTile.value + 1 > preferenceLabels.length ? preferenceLabels.length : selectedPreferenceTile.value + 1;
        selectedPreferenceTile.refresh();
      } else {
        Get.showSnackbar(const GetSnackBar(
          backgroundColor: ColorPallete.red,
          duration: Duration(seconds: 2),
          message: "Error Occured while Updating Details !",
        ));
      }
    }
  }

//SEARCH
  Rx<Search> searchProfile = Search().obs;
  ScrollController searchMatchesScrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt totalPage = 1.obs;
  RxBool showSearchResults = false.obs;
  RxList<MatchProfile> searchMacthes = <MatchProfile>[].obs;

  void getSearchMatches(bool reinit) async {
    List<MatchProfile> emptyList = [];
    if (reinit) {
      page.value = 1;
      totalPage.value = 1;
      searchMacthes.value = [];
    }
    isLoading.value = true;
    showSearchResults.value = true;
    await _settingsRepository.searchProfiles(searchProfile.value, page.value).then((value) {
      isLoading.value = false;
      if (value.status == Status.COMPLETED) {
        totalPage.value = (value.data["total_pages"] ?? "") == "" ? 1 : value.data["total_pages"];
        // ((value.data["count_total"] / value.data["count"]) as double).round();
        emptyList.addAll((value.data["profiles"] as List).map((e) => MatchProfile.fromJson(e)).toList());
        if (reinit) {
          searchMacthes.value = emptyList;
        } else {
          isLoading.value = false;
          searchMacthes.addAll(emptyList);
        }
        searchMacthes.refresh();
      }
    });
  }

  fetchUploadData() async {
    isDocsUploadLoading.value = true;
    await _membershipRepository.fetchUploadData({"id": user.value.userId}).then((value) {
      // if (value.status == Status.COMPLETED) {
      idProof.value = value.data["idProof"];
      photo1.value = value.data["profilePic"][0];
      photo2.value = value.data["profilePic"][1];
      photo3.value = value.data["profilePic"][2];
      photo4.value = value.data["profilePic"][3];
      idProof.refresh();
      photo1.refresh();
      photo2.refresh();
      photo3.refresh();
      photo4.refresh();
      // }
    });
    isDocsUploadLoading.value = false;
  }

  void saveIdProofNProfile() async {
    if (photo1Filepath.isEmpty && photo2Filepath.isEmpty && photo3Filepath.isEmpty && photo4Filepath.isEmpty && idProofFilepath.isEmpty) {
      displayNextScreen();
      showSnackbar(true);
      return;
    }

    isDocsUploadLoading.value = true;
    bool idProofResult = true;

    if (idProofFilepath.isNotEmpty) {
      await _membershipRepository.saveIdProof(
          {"id_proof": idProofFilepath.value, "photo1": photo1Filepath.value, "photo2": photo2Filepath.value, "photo3": photo3Filepath.value, "photo4": photo4Filepath.value, "id": user.value.userId}).then((value) async {
        if (photo1Filepath.isEmpty && photo2Filepath.isEmpty && photo3Filepath.isEmpty && photo4Filepath.isEmpty) {

          displayNextScreen();
          if (value.status == Status.COMPLETED) {
            Get.showSnackbar(GetSnackBar(
              backgroundColor: ColorPallete.primary,
              duration: const Duration(seconds: 2),
              message: "ID Proof Uploaded Successfully !!",
            ));
          } else {
            Get.showSnackbar(const GetSnackBar(
              backgroundColor: ColorPallete.red,
              duration: Duration(seconds: 2),
              message: "Error Occurred while Uploading ID Proof !",
            ));
          }
        }

        if (value.status != Status.COMPLETED) {
          idProofResult = false;
        }
      });
    }

    if (photo1Filepath.isNotEmpty || photo2Filepath.isNotEmpty || photo3Filepath.isNotEmpty || photo4Filepath.isNotEmpty) {
      await _membershipRepository.saveProfilePic(
          {"id_proof": idProofFilepath.value, "photo1": photo1Filepath.value, "photo2": photo2Filepath.value, "photo3": photo3Filepath.value, "photo4": photo4Filepath.value, "id": user.value.userId}).then((value) async {

            displayNextScreen();

            if(!idProofResult) {
              Get.showSnackbar(const GetSnackBar(
                backgroundColor: ColorPallete.red,
                duration: Duration(seconds: 2),
                message: "Error Occurred while Uploading ID Proof !",
              ));
            }
        if (value.status == Status.COMPLETED) {
          Get.showSnackbar(GetSnackBar(
            backgroundColor: ColorPallete.primary,
            duration: const Duration(seconds: 2),
            message: "Photos Uploaded Successfully !!",
          ));
        } else {
          Get.showSnackbar(const GetSnackBar(
            backgroundColor: ColorPallete.red,
            duration: Duration(seconds: 2),
            message: "Error Occurred while Uploading Photos !",
          ));
        }

        Get.find<HomeController>().updateUser();
      });
    }

    isDocsUploadLoading.value = false;

  }

  fetchProfileVisibilityStatus() async {
    isProfileSettingsLoading.value = true;
    await _membershipRepository.fetchProfileVisibilityStatus({"check_status": user.value.userId}).then((value) {
      profileSettings.value = value.data;
      profileSettings.refresh();
    });
    isProfileSettingsLoading.value = false;
  }

  void submitProfileVisibilityStatus(context) async {
    isProfileSettingsLoading.value = true;

    profileSettings.value.id = user.value.userId;
    profileSettings.value.enableEmailVisibility = "on";

    final result = await _membershipRepository
        .saveProfileVisibilityStatus(
          profileSettings.value.toJson(),
        )
        .then((value) => value.data);

    Get.back();
    showSnackbar(result);
    isProfileSettingsLoading.value = false;
  }

  fetchBasicDetails() async {
    isBasicDetailsLoading.value = true;
    await _membershipRepository.fetchBasicDetails({"id": user.value.userId}).then((value) {
      basicDetails.value = value.data;
      basicDetails.refresh();
    });

    if (basicDetails.value.dOB != null) {
      dobController.text = basicDetails.value.dOB!;
    }
    isBasicDetailsLoading.value = false;
  }

  void submitBasicDetails(context) async {
    final dobValidation = validateDobForAdults(dobController.text);
    if (dobValidation != null) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: ColorPallete.red,
        duration: const Duration(seconds: 3),
        message: dobValidation,
      ));
      return;
    }

    isBasicDetailsLoading.value = true;

    basicDetails.value.dOB = dobController.text;
    basicDetails.value.id = user.value.userId;

    final result = await _membershipRepository
        .saveBasicDetails(
          basicDetails.value.toJson(),
        )
        .then((value) => value.data);

    isBasicDetailsLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchReligiousDetails() async {
    isReligiousDetailsLoading.value = true;
    await _membershipRepository.fetchReligiousDetails({"id": user.value.userId}).then((value) {
      religiousDetails.value = value.data;
      religiousDetails.refresh();
    });
    isReligiousDetailsLoading.value = false;
  }

  void submitReligiousDetails(context) async {
    isReligiousDetailsLoading.value = true;

    religiousDetails.value.id = user.value.userId;

    final result = await _membershipRepository.saveReligiousDetails(religiousDetails.value.toJson()).then((value) => value.data);
    if (result) {
      //educationDetails.value = await _membershipRepository.fetchEducationDetails({"id": user.value.userId}).then((value) => value.data);
    }

    isReligiousDetailsLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchEducationDetails() async {
    isEducationDetailsLoading.value = true;
    await _membershipRepository.fetchEducationDetails({"id": user.value.userId}).then((value) {
      educationDetails.value = value.data;
      educationDetails.refresh();
    });
    isEducationDetailsLoading.value = false;
  }

  void submitEducationDetails(context) async {
    isEducationDetailsLoading.value = true;

    educationDetails.value.id = user.value.userId;
    final result = await _membershipRepository.saveEducationDetails(educationDetails.value.toJson()).then((value) => value.data);
    if (result) {
      //lifestyleDetails.value = await _membershipRepository.fetchLifestyleDetails({"id": user.value.userId}).then((value) => value.data);
    }

    isEducationDetailsLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchLifestyleDetails() async {
    isLifestyleDetailsLoading.value = true;
    await _membershipRepository.fetchLifestyleDetails({"id": user.value.userId}).then((value) {
      lifestyleDetails.value = value.data;
      lifestyleDetails.refresh();
    });
    isLifestyleDetailsLoading.value = false;
  }

  void submitLifestyleDetails(context) async {
    isLifestyleDetailsLoading.value = true;

    lifestyleDetails.value.id = user.value.userId;
    final result = await _membershipRepository.saveLifestyleDetails(lifestyleDetails.value.toJson()).then((value) => value.data);
    if (result) {
      /*locationDetails.value = await _membershipRepository.fetchLocationDetails({"id": user.value.userId}).then((value) => value.data);

      if ((locationDetails.value.country ?? "") != "") {
        onCountryChanged(countries.where((p0) => p0.id.toString() == locationDetails.value.country).first.name!, false);
      }*/
    }

    isLifestyleDetailsLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchLocationDetailsOld() async {
    isLocationDetailsLoading.value = true;
    await fetchCountries(true);
    await _membershipRepository.fetchLocationDetails({"id": user.value.userId}).then((value) {
      locationDetails.value = value.data;
      if ((locationDetails.value.country ?? "") != "") {
        onCountryChanged(countries.where((p0) => p0.id.toString() == locationDetails.value.country).first.name!, false);
      }
      locationDetails.refresh();
    });
    isLocationDetailsLoading.value = false;
  }

  fetchLocationDetails() async {
    isLocationDetailsLoading.value = true;
    await fetchCountries(false);
    await _membershipRepository.fetchLocationDetails({"id": user.value.userId}).then((value) {
      locationDetails.value = value.data;

      if ((locationDetails.value.country ?? "").isNotEmpty) {
        var matchingCountries = countries.where((p0) => p0.id.toString() == locationDetails.value.country!).toList();

        if (matchingCountries.isNotEmpty) {
          onCountryChanged(matchingCountries.first.name!, false);
        } else {
          debugPrint("No matching country found for ID: ${locationDetails.value.country}");
        }
      }

      locationDetails.refresh();
    });
    isLocationDetailsLoading.value = false;
  }

  void submitLocationDetails(context) async {
    isLocationDetailsLoading.value = true;

    locationDetails.value.id = user.value.userId;
    final result = await _membershipRepository.saveLocationDetails(locationDetails.value.toJson()).then((value) => value.data);
    if (result) {
      //familyDetails.value = await _membershipRepository.fetchFamilyDetails({"id": user.value.userId}).then((value) => value.data);
    }

    isLocationDetailsLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchFamilyDetails() async {
    isFamilyDetailsLoading.value = true;
    await _membershipRepository.fetchFamilyDetails({"id": user.value.userId}).then((value) {
      familyDetails.value = value.data;
      familyDetails.refresh();
    });
    isFamilyDetailsLoading.value = false;
  }

  void submitFamilyDetails(context) async {
    isFamilyDetailsLoading.value = true;

    familyDetails.value.id = user.value.userId;
    final result = await _membershipRepository.saveFamilyDetails(familyDetails.value.toJson()).then((value) => value.data);
    if (result) {}

    isFamilyDetailsLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchBasicPreferenceDetails() async {
    isBasicPreferenceLoading.value = true;
    await _membershipRepository.fetchBasicPreference({"v_id": user.value.userId}).then((value) {
      basicPreference.value = value.data;
      basicPreference.refresh();
    });
    isBasicPreferenceLoading.value = false;
  }

  void saveBasicPreferenceDetails(context) async {
    isBasicPreferenceLoading.value = true;

    basicPreference.value.vId = user.value.userId;
    final result = await _membershipRepository
        .saveBasicPreference(
          basicPreference.toJson(),
        )
        .then((value) => value.data);
    if (result) {
      //religiousPreference.value = await _membershipRepository.fetchReligiousPreference({"v_id": user.value.userId}).then((value) => value.data);
    }

    isBasicPreferenceLoading.value = false;
    displayNextScreen();
    showSnackbar(result);
  }

  fetchReligiousPreferenceDetails() async {
    isReligiousPreferenceLoading.value = true;
    await _membershipRepository.fetchReligiousPreference({"v_id": user.value.userId}).then((value) {
      religiousPreference.value = value.data;
      religiousPreference.refresh();
    });
    isReligiousPreferenceLoading.value = false;
  }

  void saveReligiousPreferenceDetails(context) async {
    isReligiousPreferenceLoading.value = true;

    religiousPreference.value.vId = user.value.userId;
    final result = await _membershipRepository.saveReligiousPreference(religiousPreference.toJson()).then((value) => value.data);
    if (result) {
      /*locationPreference.value = await _membershipRepository.fetchLocationPreference({"v_id": user.value.userId}).then((value) => value.data);

      if ((locationPreference.value.country ?? "") != "") {
        onCountryPrefChanged(countries.where((p0) => p0.id.toString() == locationPreference.value.country!).first.name!, true);
      }*/
    }
    isReligiousPreferenceLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchLocationPreferenceDetailsOld() async {
    isLocationPreferenceLoading.value = true;
    await fetchCountries(true);
    await _membershipRepository.fetchLocationPreference({"v_id": user.value.userId}).then((value) {
      locationPreference.value = value.data;
      if ((locationPreference.value.country ?? "") != "") {
        onCountryPrefChanged(countries.where((p0) => p0.id.toString() == locationPreference.value.country!).first.name!, true);
      }
      locationPreference.refresh();
    });
    isLocationPreferenceLoading.value = false;
  }

  fetchLocationPreferenceDetails() async {
    isLocationPreferenceLoading.value = true;
    await fetchCountries(true);
    await _membershipRepository.fetchLocationPreference({"v_id": user.value.userId}).then((value) {
      locationPreference.value = value.data;

      if ((locationPreference.value.country ?? "").isNotEmpty) {
        var matchingCountries = countries.where((p0) => p0.id.toString() == locationPreference.value.country!).toList();

        if (matchingCountries.isNotEmpty) {
          onCountryPrefChanged(matchingCountries.first.name!, true);
        } else {
          debugPrint("No matching country found for ID: ${locationPreference.value.country}");
        }
      }

      locationPreference.refresh();
    });
    isLocationPreferenceLoading.value = false;
  }


  void saveLocationPreferenceDetails(context) async {
    isLocationPreferenceLoading.value = true;

    locationPreference.value.vId = user.value.userId;
    final result = await _membershipRepository.saveLocationPreference(locationPreference.toJson()).then((value) => value.data);
    if (result) {
      //educationPreference.value = await _membershipRepository.fetchEducationPreference({"v_id": user.value.userId}).then((value) => value.data);
    }

    isLocationPreferenceLoading.value = false;

    displayNextScreen();
    showSnackbar(result);
  }

  fetchEducationPreferenceDetails() async {
    isEducationPreferenceLoading.value = true;
    await _membershipRepository.fetchEducationPreference({"v_id": user.value.userId}).then((value) {
      educationPreference.value = value.data;
      educationPreference.refresh();
    });
    isEducationPreferenceLoading.value = false;
  }

  saveEducationPreferenceDetails(context) async {
    isEducationPreferenceLoading.value = true;

    educationPreference.value.vId = user.value.userId;
    final result = await _membershipRepository.saveEducationPreference(educationPreference.toJson()).then((value) => value.data);

    isEducationPreferenceLoading.value = false;
    if (result) {
      if (!(Get.arguments?["isLoggedIn"] ?? false)) {
        Get.showSnackbar(
          const GetSnackBar(
            duration: Duration(seconds: 3),
            message: "Setting Up App ..\nAnd Going to Home Screen",
          ),
        );

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(
            Routes.HOME,
            predicate: (route) => Get.currentRoute == "/home",
          );
          // paymentGateway(context).then((value) {});
        });
      } else {
        Get.back();
        Get.showSnackbar(GetSnackBar(
          backgroundColor: ColorPallete.primary,
          duration: const Duration(seconds: 2),
          message: "Details Submitted Successfully !!",
        ));
      }
    } else {
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: ColorPallete.red,
        duration: Duration(seconds: 2),
        message: "Error Occurred while Submitting Details !",
      ));
    }
  }

  void showSnackbar(result) {
    if (result) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: ColorPallete.primary,
        duration: const Duration(seconds: 2),
        message: "Details Submitted Successfully !!",
      ));
    } else {
      Get.showSnackbar(const GetSnackBar(
        backgroundColor: ColorPallete.red,
        duration: Duration(seconds: 2),
        message: "Error Occurred while Submitting Details !",
      ));
    }
  }

  displayNextScreen() {
    if (Get.arguments?["isLoggedIn"] ?? false) {
      Get.back();
    } else {
      int nextScreenIndex = screenOrder.indexOf(Get.currentRoute) + 1;
      String nextScreenRoute = screenOrder[nextScreenIndex];
      Get.toNamed(nextScreenRoute);
    }
  }

  List screenOrder = [
    Routes.BASIC_DETAILS_FORM,
    Routes.RELIGIOUS_DETAILS_FORM,
    Routes.EDUCATION_DETAILS_FORM,
    Routes.LIFESTYLE_DETAILS_FORM,
    Routes.LOCATION_DETAILS_FORM,
    Routes.FAMILY_DETAILS_FORM,
    Routes.UPLOAD_DOCS,
    Routes.BASIC_PREFERENCE_FORM,
    Routes.RELIGIOUS_PREFERENCE_FORM,
    Routes.LOCATION_PREFERENCE_FORM,
    Routes.EDUCATION_PREFERENCE_FORM
  ];
}
