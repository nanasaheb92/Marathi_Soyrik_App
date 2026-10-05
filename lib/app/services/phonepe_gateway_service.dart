import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

/// Opens the PhonePe payment page using the native SDK (Standard Checkout v2).
///
/// The order (orderId + token) is created on the server
/// (apis/phonepe_initiate.php) so the client secret never ships inside the app.
class PhonePePG {
  static final PhonePePG _instance = PhonePePG._();
  static PhonePePG get getInstance => _instance;
  PhonePePG._();

  bool enableLogging = kDebugMode;
  String? _initialisedFor;

  Future<bool> _init(String env, String merchantId, String flowId) async {
    final key = "$env|$merchantId|$flowId";
    if (_initialisedFor == key) return true;
    try {
      final ok =
          await PhonePePaymentSdk.init(env, merchantId, flowId, enableLogging);
      if (ok) _initialisedFor = key;
      return ok;
    } catch (e) {
      if (kDebugMode) print("--- PhonePe SDK init error: $e");
      return false;
    }
  }

  /// Returns the SDK status: SUCCESS, FAILURE, INTERRUPTED or an error text.
  /// SUCCESS here only means the flow finished - always confirm with the
  /// server status API before activating the package.
  Future<String> startTransaction({
    required String env,
    required String merchantId,
    required String flowId,
    required String orderId,
    required String token,
  }) async {
    if (!await _init(env, merchantId, flowId)) {
      return "INIT_FAILED";
    }
    try {
      final request = jsonEncode({
        "orderId": orderId,
        "merchantId": merchantId,
        "token": token,
        "paymentMode": {"type": "PAY_PAGE"},
      });
      final val = await PhonePePaymentSdk.startTransaction(request, "");
      if (kDebugMode) print("--- PhonePe SDK result: $val");
      if (val == null) return "INCOMPLETE";
      return val["status"].toString();
    } catch (e) {
      return "ERROR: $e";
    }
  }
}
