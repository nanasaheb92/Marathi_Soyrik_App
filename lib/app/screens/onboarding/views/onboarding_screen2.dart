import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:matrimony/common/color_pallete.dart';

import '../../../routes/app_routes.dart';
import '../../settings/views/contact_us_screen.dart';

import 'package:flutter/material.dart';

class IconOverlayCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Overlay Icon Card")),
      body: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: 200,
                height: 200,
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    "Card Content",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.home, color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.orange,
                    child: Icon(Icons.notifications, color: Colors.white),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

