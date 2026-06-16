import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/color_pallete.dart';
import '../../../components/ui/text_view.dart';
import '../controllers/search_profiles_controller.dart';
import 'advance_search_screen.dart';
import 'id_search_screen.dart';

class SearchTabsScreen extends GetView<SearchProfilesController> {
  const SearchTabsScreen({this.showAppBar = true, super.key});

  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        extendBody: true,
        backgroundColor: ColorPallete.primary,
        body: SafeArea(
          child: Scaffold(
            backgroundColor: ColorPallete.theme,
            appBar: AppBar(
              iconTheme: const IconThemeData(color: ColorPallete.theme),
              backgroundColor: ColorPallete.primary,
              title: showAppBar
              ? const TextView(
                text: "Search",
                color: ColorPallete.theme,
                fontSize: 18,
                weight: FontWeight.bold,
              )
              : null,
              centerTitle: true,
              bottom: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                // Set the color for unselected tab text
                unselectedLabelColor: Colors.white,
                // Set the color of the underline indicator
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Advance Search"),
                  Tab(text: "ID Search"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                AdvanceSearchScreen(),
                IDSearchScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
