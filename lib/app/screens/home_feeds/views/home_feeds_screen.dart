import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../components/ui/rounded_container.dart';
import '../controllers/home_feeds_controller.dart';
import '../models/profile_model.dart';

class HomeFeedsScreen extends GetView<HomeFeedsController> {
  const HomeFeedsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => Container(
            //color: Colors.lightBlueAccent,
            color: Colors.white,
            //height: 120, // Adjust height as needed
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    margin: EdgeInsets.all(16.0),
                    shadowColor: Colors.blueGrey, // Shadow color
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0.0), // Rounded corners
                            child: Image.asset(
                              'assets/home/profile.png', // Path to your asset image
                              width: 50,
                              height: 50,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Vishal Shinde",
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                ),
                                SizedBox(height: 0),
                                Text(
                                  "Free Member",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    margin: EdgeInsets.all(0.0),
                    shadowColor: Colors.blueGrey, // Shadow color
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(0.0), // Rounded corners
                            child: Image.asset(
                              'assets/home/picture.png', // Path to your asset image
                              width: 30,
                              height: 30,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Add photo to get 10 times more response",
                                    style: TextStyle(color: Colors.black, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0), // Rounded corners
                    child: Image.asset(
                      'assets/home/home5.jpeg', // Path to your asset image
                      //width: 200,
                      //height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Centers children horizontally
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "All Matches (499)",
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              "See all >",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          "Members who match your partner preferences",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // Adjusts ListView height based on content
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.allMatchesList.length,
                      itemBuilder: (context, index) {
                        final profile = controller.allMatchesList[index];
                        return HomeProfileWidget(profile: profile);
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0), // Rounded corners
                    child: Image.asset(
                      'assets/home/home3.jpeg', // Path to your asset image
                      //width: 200,
                      //height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Centers children horizontally
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Your Daily Recommendations for 18th Sep",
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // Adjusts ListView height based on content
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.allMatchesList.length,
                      itemBuilder: (context, index) {
                        final profile = controller.allMatchesList[index];
                        return HomeProfileWidget(profile: profile);
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0), // Rounded corners
                    child: Image.asset(
                      'assets/home/home4.jpeg', // Path to your asset image
                      //width: 200,
                      //height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Centers children horizontally
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Nearby Matches (10)",
                                style: TextStyle(color: Colors.black, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 0),
                            Text(
                              "See all >",
                              textAlign: TextAlign.start,
                              style: TextStyle(color: Colors.orange, fontSize: 13, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Text(
                          "Matches from your location",
                          textAlign: TextAlign.start,
                          style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // Adjusts ListView height based on content
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.allMatchesList.length,
                      itemBuilder: (context, index) {
                        final profile = controller.allMatchesList[index];
                        return HomeProfileWidget(profile: profile);
                      },
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0), // Rounded corners
                    child: Image.asset(
                      'assets/home/home2.jpeg', // Path to your asset image
                      //width: 200,
                      //height: 100,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline, // Icon to display
                          color: Colors.green, // Color of the icon
                          size: 50.0, // Size of the icon
                        ),
                        SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "Need help? Reach out to \n us with your queries!",
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0.0), // Rounded corners
                    child: Image.asset(
                      'assets/home/home1.jpeg', // Path to your asset image
                      //width: 200,
                      //height: 100,
                      fit: BoxFit.fitWidth,
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

class HomeProfileWidget extends StatelessWidget {
  final Profile profile;

  const HomeProfileWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center, // Centers children vertically
          crossAxisAlignment: CrossAxisAlignment.start, // Centers children horizontally
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Rounded corners
                child: /*CachedNetworkImage(
                  imageUrl: (profile.photo1 ?? "") == ""
                      ? ""
                      : "${profile.photo1}",
                  placeholder: (context, url) {
                    return Image.asset(
                      "assets/ui/logo.jpeg",
                      //height: 200,
                    );
                  },
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return RoundedContainer(
                      radius: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/ui/logo.jpeg",
                          //height: 200,
                        ),
                      ),
                    );
                  },
                ),*/
                Image.asset(
                  'assets/home/profile/${profile.photo1}', // Path to your asset image
                  width: 125,
                  height: 125,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              profile.name!,
              style: TextStyle(color: Colors.black, fontSize: 13),
            ),
            SizedBox(height: 0),
            Text(
              "22 Yrs, 5'.3\"",
                textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
