import 'package:get/get.dart';

import '../models/profile_model.dart';

class HomeFeedsController extends GetxController {

  RxBool isLoading = false.obs;
  RxList<Profile> allMatchesList = <Profile>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    fetchAllMatches();
  }

  void fetchAllMatches() {

    Profile p1 = Profile(
      id: "1",
      name: "Swati Jain",
      location: "Pune",
      gender: "Female",
      photo1: "p5.png",
      height: "5'3\"",
      weight: "55 kg",
      language: "Marathi",
    );

    Profile p2 = Profile(
      id: "2",
      name: "Swati Jain",
      location: "Pune",
      gender: "Female",
      photo1: "p1.png",
      height: "5'3\"",
      weight: "55 kg",
      language: "Marathi",
    );

    Profile p3 = Profile(
      id: "3",
      name: "Swati Jain",
      location: "Pune",
      gender: "Female",
      photo1: "p2.png",
      height: "5'3\"",
      weight: "55 kg",
      language: "Marathi",
    );

    Profile p4 = Profile(
      id: "4",
      name: "Swati Jain",
      location: "Pune",
      gender: "Female",
      photo1: "p3.png",
      height: "5'3\"",
      weight: "55 kg",
      language: "Marathi",
    );

    Profile p5 = Profile(
      id: "5",
      name: "Swati Jain",
      location: "Pune",
      gender: "Female",
      photo1: "p4.png",
      height: "5'3\"",
      weight: "55 kg",
      language: "Marathi",
    );

    allMatchesList.addAll([p1, p2, p3, p4, p5]);

  }
}
