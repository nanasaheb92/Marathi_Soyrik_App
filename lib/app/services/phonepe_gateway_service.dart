import 'package:flutter/foundation.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

/// Opens the PhonePe payment page using the native SDK.
///
/// The request body and checksum are generated on the server
/// (apis/phonepe_initiate.php) so the salt key never ships inside the app.
class PhonePePG {
  static final PhonePePG _instance = PhonePePG._();
  static PhonePePG get getInstance => _instance;
  PhonePePG._();

  bool enableLogging = kDebugMode;
  String? _initialisedFor;

  Future<bool> _init(String env, String merchantId) async {
    final key = "$env|$merchantId";
    if (_initialisedFor == key) return true;
    try {
      final ok = await PhonePePaymentSdk.init(env, "", merchantId, enableLogging);
      if (ok) _initialisedFor = key;
      return ok;
    } catch (_) {
      return false;
    }
  }

  /// Returns the SDK status: SUCCESS, FAILURE, INTERRUPTED or an error text.
  /// SUCCESS here only means the flow finished - always confirm with the
  /// server status API before activating the package.
  Future<String> startTransaction({
    required String env,
    required String merchantId,
    required String body,
    required String checksum,
    required String callbackUrl,
  }) async {
    if (!await _init(env, merchantId)) {
      return "INIT_FAILED";
    }
    try {
      final val = await PhonePePaymentSdk.startTransaction(
          body, callbackUrl, checksum, "");
      if (kDebugMode) print("--- PhonePe SDK result: $val");
      if (val == null) return "INCOMPLETE";
      return val["status"].toString();
    } catch (e) {
      return "ERROR: $e";
    }
  }
}
