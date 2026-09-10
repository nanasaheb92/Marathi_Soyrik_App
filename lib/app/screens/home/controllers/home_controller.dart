import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/api_response.dart';
import '../../../models/mathc_profile_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/matches_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../home_feeds/controllers/home_feeds_controller.dart';
import '../views/home_view.dart';

class HomeController extends GetxController {
  Rx<User> user = User().obs;
  // User(
  //         name: "Omkar Mhatre",
  //         coins: 1500,
  //         happiness: 25,
  //         email: "karomhatre@gmail.com",
  //         phoneNumber: "+919969383542")
  //     .obs;

  RxInt setTabIndex = 0.obs;
  RxBool isLiveAuction = true.obs;
  RxBool showMoreOptions = false.obs;
  RxString itemView = "LIST".obs;

  late var scaffoldKey = GlobalKey<ScaffoldState>();
  late UserRepository _userRepository;
  late MatchesRepository _matchesRepository;

  HomeController() {
    _userRepository = UserRepository();
    _matchesRepository = MatchesRepository();
  }

  RxBool searchedClicked = false.obs;
  RxBool isLoading = false.obs;

  @override
  Future<void> onInit() async {
    isLoading.value = false;

    user.value = Get.find<AuthService>().user.value;
    user.listen((updatedUser) {
      Get.find<AuthService>().user.value = updatedUser;
    });

    // if (Get.arguments != null) {
    //   setTabIndex.value = int.parse(Get.arguments["tabIndex"] as String);
    // }
    super.onInit();
    Get.put(HomeFeedsController());

    setTabIndex.listen((p0) {});

    homeRefresh();

    matchesScrollController.addListener(() {
      if (matchesScrollController.position.pixels ==
          matchesScrollController.position.maxScrollExtent &&
          !isLoading.value && page.value < totalPage.value) {
        page.value = page.value + 1;
        isLoading.value = true;

        Future.delayed(const Duration(milliseconds: 500), () {
          //matchesScrollController.jumpTo(matchesScrollController.position.maxScrollExtent);
          fetchMatchedProfiles(false);
        });
      }
    });
  }

  // TABS
  final List bottomTabs = [
    {
      "title": "Home",
      "icon": "assets/ui/home_icon.png",
      "pos": "0",
      "view": const HomeView()
    },
    // {
    //   "title": "Membership Card",
    //   "icon": "assets/ui/certificates.png",
    //   "pos": "1",
    //   "view": const SettingsScreen()
    // },
    // {
    //   "title": "Contact Us",
    //   "icon": "assets/ui/contact_us.png",
    //   "pos": "2",
    //   "view": const ContactUsView()
    // },
    // {
    //   "title": "Alerts",
    //   "icon": "assets/ui/bell_notification_icon.png",
    //   "pos": "3",
    //   "view": Container()
    // },
    // {
    //   "title": "Settings",
    //   "icon": "assets/ui/setting_icon.png",
    //   "pos": "4",
    //   "view": Container()
    // }
  ];

  getTabScreen(index) {
    return bottomTabs[index]["view"];
  }

  void updateUser() async {
    await _userRepository.fetchUserDetails().then((value) {
      if (value.status == Status.COMPLETED) {
        user = User().obs;
        user.value = value.data;
        Get.find<AuthService>().saveUser(user.value);
        // user.value.membershipId = u0.membershipId;
        // user.value.balance = u0.balance;
        user.refresh();
      } else {
        Get.find<AuthService>().removeCurrentUser();
        Get.toNamed(Routes.LOGIN);
      }
    });
  }

  void homeRefresh() async {
    updateUser();
    // fetchSliders();
    // fetchCategories();
    fetchMatchedProfiles(true);
    //fetchNearByProfiles();
    fetchshortlistedProfiles();
  }

  List<String> educations = ["SSC", "HSC", "B.E", "B.Sc", "B.D.S.", "B.A"];
  List<String> occupations = [
    "Looking For a Job",
    "Not Working",
    "Banking Proffesional",
    "Air Hostess",
    "BPO/ITeS",
    "Beautician"
  ];

  //MATCHES
  ScrollController matchesScrollController = ScrollController();
  RxInt page = 1.obs;
  RxInt totalPage = 1.obs;
  RxList<MatchProfile> macthes = <MatchProfile>[].obs;
  
  bool _isFetchingMatches = false;

  void fetchMatchedProfiles(bool reinit) async {
    if (_isFetchingMatches) return;
    
    List<MatchProfile> emptyList = [];
    //List<MatchProfile> nearbyList = [];
    if (reinit) {
      page.value = 1;
      totalPage.value = 1;
      macthes.value = [];
      macthes.refresh();
    }
    
    _isFetchingMatches = true;
    isLoading.value = true;
    
    await _matchesRepository.fetchMatchedProfiles(page.value).then((value) {
      isLoading.value = false;
      _isFetchingMatches = false;
      
      if (value.status == Status.COMPLETED) {
        totalPage.value = value.data["total_pages"];
        // ((value.data["count_total"] / value.data["count"]) as double).round();
        emptyList.addAll((value.data["matches"] as List)
            .map((e) => MatchProfile.fromJson(e))
            .toList());

        //nearbyList.addAll(emptyList.where((profile) => profile.location == "NA").toList());

        if (reinit) {
          macthes.value = emptyList;
          //nearbyProfiles.value = nearbyList;
        } else {
          for (var profile in emptyList) {
            if (!macthes.any((element) => element.profileId == profile.profileId)) {
              macthes.add(profile);
            }
          }
          //macthes.addAll(emptyList);
          //nearbyProfiles.addAll(nearbyList);
        }
        macthes.refresh();
        //nearbyProfiles.refresh();
      }
    }).catchError((err) {
      isLoading.value = false;
      _isFetchingMatches = false;
    });
  }

  // VIEWED MY PROFILE
  RxList<MatchProfile> viewedMyProfiles = <MatchProfile>[].obs;

  void fetchViewedMyProfiles() async {
    isLoading.value = true;
    await _matchesRepository.fetchViewedMyProfiles().then((value) {
      isLoading.value = false;
      if (value.status == Status.COMPLETED) {
        viewedMyProfiles.value = value.data;
        viewedMyProfiles.refresh();
      }
    });
  }

  // NEARBY PROFILES
  RxList<MatchProfile> nearbyProfiles = <MatchProfile>[].obs;

  void fetchNearByProfiles() async {

    List<MatchProfile> nearbyList = [];
    isLoading.value = true;

    await _matchesRepository.fetchMatchedProfiles(3).then((value) {
      isLoading.value = false;
      if (value.status == Status.COMPLETED) {
        nearbyList.addAll((value.data["matches"] as List)
            .map((e) => MatchProfile.fromJson(e))
            .toList());

        nearbyProfiles.value = nearbyList;
        nearbyProfiles.refresh();
      }
    });
  }

  //SHORTLIST
  RxList<MatchProfile> shortlistedProfiles = <MatchProfile>[].obs;
  void fetchshortlistedProfiles() async {
    isLoading.value = true;
    await _matchesRepository.fetchshortlistedProfiles().then((value) {
      isLoading.value = false;
      if (value.status == Status.COMPLETED) {
        shortlistedProfiles.value = value.data;
        shortlistedProfiles.refresh();
      }
    });
  }

  void onTabChanged(int value) {
    value == 0
        ? fetchMatchedProfiles(true)
        : value == 1
            //? fetchViewedMyProfiles()
            ? fetchNearByProfiles()
            : fetchshortlistedProfiles();
  }
}
