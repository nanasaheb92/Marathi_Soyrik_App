import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/package_model.dart';
import '../../../routes/app_routes.dart';
import '../controllers/settings_controller.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  final SettingsController controller = Get.find<SettingsController>();
  late final PageController _pageController;

  // Brand gradient (same purple -> pink as the website cards)
  static const _gradStart = Color(0xff6A0DCB);
  static const _gradMid = Color(0xffA21CAF);
  static const _gradEnd = Color(0xffF0457E);
  static const _gold = Color(0xffFFD54A);
  static const _silver = Color(0xffC9CED6);

  /// Opened directly after signup: there is no previous screen, so leaving
  /// this page must go to Home instead of popping.
  bool get _fromSignup => Get.arguments?["fromSignup"] ?? false;

  void _close() {
    if (_fromSignup) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    // First plan is selected by default
    controller.selectedPage.value = 0;
    _pageController = PageController(initialPage: 0, viewportFraction: 0.84);
    controller.fetchPackages();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _selectedIndex(int length) {
    if (length == 0) return 0;
    return controller.selectedPage.value.clamp(0, length - 1);
  }

  void _select(int index) {
    controller.selectedPage.value = index;
    if (_pageController.hasClients && _pageController.page?.round() != index) {
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    }
  }

  /// Most expensive plan gets the gold "premium" treatment.
  int _premiumIndex(List<Package> packages) {
    int best = 0;
    for (int i = 1; i < packages.length; i++) {
      if (_amount(packages[i]) > _amount(packages[best])) best = i;
    }
    return best;
  }

  double _amount(Package p) => double.tryParse(p.packAmmount ?? "") ?? 0;

  String _price(Package p) {
    final digits = _amount(p).round().toString();
    // Indian grouping: 1,00,000
    if (digits.length <= 3) return "₹$digits";
    final last3 = digits.substring(digits.length - 3);
    var rest = digits.substring(0, digits.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.insert(0, rest);
    return "₹${parts.join(",")},$last3";
  }

  String _validity(Package p) {
    final d = (p.duration ?? "").trim();
    if (d.isEmpty) return "";
    return int.tryParse(d) != null ? "$d Days" : d;
  }

  List<String> _features(Package p) => [
        "Free search & messaging",
        "Send interest: ${p.totalInterest ?? '-'}",
        "Chat requests: ${p.totalChat ?? '-'}",
        "Verified contacts: ${p.totalContact ?? '-'}",
        "Unlimited profile views",
        "WhatsApp group access",
        "Website & app access",
      ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_fromSignup,
      onPopInvoked: (didPop) {
        if (!didPop) _close();
      },
      child: Stack(
        children: [
          _buildBody(context),
          Obx(() => controller.isPaymentLoading.value
              ? Container(
                  color: Colors.black45,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xff0F0B1A) : const Color(0xffF6F3FB);

    return Scaffold(
      backgroundColor: bg,
      body: Obx(() {
        final packages = controller.packages.toList();
        final selected = _selectedIndex(packages.length);
        final premium = packages.isEmpty ? -1 : _premiumIndex(packages);

        return Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(context)),
                if (packages.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: _carousel(packages, selected, premium),
                  ),
                  SliverToBoxAdapter(child: _dots(packages.length, selected)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                      child: Text(
                        "Compare plans",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xff1E1530),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _tierCard(context, packages[i],
                          i == selected, i == premium, () => _select(i)),
                      childCount: packages.length,
                    ),
                  ),
                  // room for the sticky CTA
                  const SliverToBoxAdapter(child: SizedBox(height: 120)),
                ],
              ],
            ),
            if (packages.isNotEmpty)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _stickyCta(context, packages[selected]),
              ),
          ],
        );
      }),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gradStart, _gradMid, _gradEnd],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: EdgeInsets.fromLTRB(
          8, MediaQuery.of(context).padding.top + 4, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _close,
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              const Spacer(),
              if (_fromSignup)
                TextButton(
                  onPressed: _close,
                  child: const Text("Skip",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15)),
                ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose your plan",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3),
                ),
                SizedBox(height: 6),
                Text(
                  "Unlock more interests, chats and verified contacts",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _carousel(List<Package> packages, int selected, int premium) {
    return Transform.translate(
      offset: const Offset(0, -12),
      child: SizedBox(
        height: 200,
        child: PageView.builder(
          controller: _pageController,
          itemCount: packages.length,
          onPageChanged: (i) => controller.selectedPage.value = i,
          itemBuilder: (context, i) => AnimatedScale(
            scale: i == selected ? 1 : 0.92,
            duration: const Duration(milliseconds: 250),
            child: _featuredCard(packages[i], i == premium),
          ),
        ),
      ),
    );
  }

  Widget _featuredCard(Package p, bool isPremium) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gradStart, _gradMid, _gradEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: _gradMid.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // soft decorative circle
          Positioned(
            right: -40,
            bottom: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isPremium) _chip("MOST POPULAR"),
                        if (isPremium) const SizedBox(height: 8),
                        Text(
                          (p.packName ?? "").toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPremium ? _gold : _silver,
                      boxShadow: [
                        BoxShadow(
                          color: (isPremium ? _gold : _silver).withOpacity(0.6),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.star_rounded,
                        color: Colors.white, size: 30),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _price(p),
                    style: const TextStyle(
                        color: _gold,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        height: 1),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      "/ ${_validity(p)}",
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "${p.totalInterest ?? '-'} interests  •  ${p.totalContact ?? '-'} contacts",
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1)),
    );
  }

  Widget _dots(int count, int selected) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: i == selected ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: i == selected ? _gradMid : _gradMid.withOpacity(0.25),
          ),
        ),
      ),
    );
  }

  Widget _tierCard(BuildContext context, Package p, bool selected,
      bool isPremium, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xff1B1528) : Colors.white;
    final titleColor = isDark ? Colors.white : const Color(0xff1E1530);
    final bodyColor = isDark ? Colors.white70 : const Color(0xff5B5370);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.all(2), // gradient border width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: selected
              ? const LinearGradient(colors: [_gradStart, _gradEnd])
              : null,
          color: selected
              ? null
              : (isDark ? Colors.white12 : const Color(0xffE7E1F0)),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: _gradEnd.withOpacity(0.35),
                      blurRadius: 18,
                      spreadRadius: 1),
                ]
              : [],
        ),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                p.packName ?? "",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: titleColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            if (isPremium) ...[
                              const SizedBox(width: 6),
                              const Icon(Icons.workspace_premium_rounded,
                                  color: Color(0xffF5B400), size: 18),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text("Valid for ${_validity(p)}",
                            style: TextStyle(color: bodyColor, fontSize: 12)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShaderMask(
                        shaderCallback: (r) => const LinearGradient(
                                colors: [_gradStart, _gradEnd])
                            .createShader(r),
                        child: Text(
                          _price(p),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900),
                        ),
                      ),
                      Text("one-time",
                          style: TextStyle(color: bodyColor, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(width: 10),
                  _radio(selected, isDark),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                    height: 1,
                    color: isDark ? Colors.white12 : const Color(0xffEEE9F5)),
              ),
              ..._features(p).map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient:
                              LinearGradient(colors: [_gradStart, _gradEnd]),
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 14),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(f,
                            style: TextStyle(
                                color: titleColor.withOpacity(0.85),
                                fontSize: 14)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _radio(bool selected, bool isDark) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: selected
            ? const LinearGradient(colors: [_gradStart, _gradEnd])
            : null,
        border: selected
            ? null
            : Border.all(
                color: isDark ? Colors.white38 : const Color(0xffC9C1D8),
                width: 2),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
          : null,
    );
  }

  Widget _stickyCta(BuildContext context, Package p) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 14, 20, MediaQuery.of(context).padding.bottom + 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff15101F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.5 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.packName ?? "",
                style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xff5B5370),
                    fontSize: 12),
              ),
              Text(
                _price(p),
                style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xff1E1530),
                    fontSize: 22,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.makePayment(context, p),
              child: Container(
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                      colors: [Color(0xffFF8A00), Color(0xffF0457E)]),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffF0457E).withOpacity(0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Choose Plan",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
