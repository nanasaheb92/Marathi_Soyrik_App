import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens the PhonePe payment page the same way the website (buy_pack.php) does.
///
/// The server (apis/phonepe_initiate.php) signs the request (body + checksum)
/// so the salt key never ships inside the app. The app sends that signed
/// request to PhonePe, gets the payment page URL and opens it in a Chrome
/// Custom Tab (real browser, so the page and UPI apps work like the website).
/// When the user returns to the app, the caller verifies the result with the
/// server.
class PhonePePG {
  PhonePePG._();

  static const _payUrls = {
    "PRODUCTION": "https://api.phonepe.com/apis/hermes/pg/v1/pay",
    "SANDBOX": "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/pay",
  };

  /// Returns "FINISHED" when the user is back in the app,
  /// or "ERROR: ..." if the payment page could not be opened.
  static Future<String> startTransaction({
    required String env,
    required String body,
    required String checksum,
  }) async {
    final String payPageUrl;
    try {
      final res = await Dio().post(
        _payUrls[env] ?? _payUrls["PRODUCTION"]!,
        data: {"request": body},
        options: Options(headers: {
          "Content-Type": "application/json",
          "X-VERIFY": checksum,
        }),
      );
      if (kDebugMode) print("--- PhonePe pay response: ${res.data}");
      final url =
          res.data?["data"]?["instrumentResponse"]?["redirectInfo"]?["url"];
      if (res.data?["code"] != "PAYMENT_INITIATED" || url == null) {
        return "ERROR: ${res.data?["message"] ?? "Payment initiation failed"}";
      }
      payPageUrl = url.toString();
    } on DioException catch (e) {
      if (kDebugMode) print("--- PhonePe pay error: ${e.response?.data}");
      return "ERROR: ${e.response?.data?["message"] ?? "Payment initiation failed"}";
    }

    final returned = _waitForAppResume();
    final opened = await launchUrl(Uri.parse(payPageUrl),
        mode: LaunchMode.inAppBrowserView);
    if (!opened) return "ERROR: Could not open payment page";
    await returned;
    return "FINISHED";
  }

  /// Completes when the app comes back to the foreground
  /// (user closed the payment tab or came back from the UPI app).
  static Future<void> _waitForAppResume() {
    final completer = Completer<void>();
    var leftApp = false;
    late final AppLifecycleListener listener;
    listener = AppLifecycleListener(
      onHide: () => leftApp = true,
      onResume: () {
        if (leftApp && !completer.isCompleted) {
          listener.dispose();
          completer.complete();
        }
      },
    );
    return completer.future;
  }
}
