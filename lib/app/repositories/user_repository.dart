import 'dart:convert';

import 'package:get/get.dart';

import '../models/api_response.dart';
import '../models/user_model.dart';
import '../providers/api_endpoints.dart';
import '../providers/api_provider.dart';
import 'package:dio/dio.dart' as dio;

import '../services/auth_service.dart';

class UserRepository {
  late ApiProvider apiProvider;

  UserRepository() {
    apiProvider = Get.find<ApiProvider>();
  }

  // MOBILE OTP - send-otp.php / verify-otp.php live at the site root (not /apis/)
  final dio.Dio _otpClient = dio.Dio(dio.BaseOptions(
    baseUrl: Urls.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    responseType: dio.ResponseType.plain,
  ));

  Future<ApiResponse> sendMobileOtp(String mobile) =>
      _otpCall("send-otp.php", {"mobile": mobile});

  Future<ApiResponse> verifyMobileOtp(String mobile, String otp) =>
      _otpCall("verify-otp.php", {"mobile": mobile, "otp": otp});

  /// Accepts JSON {"status": true/false, "message": "..."}.
  /// Falls back to the current plain-text/HTML output of the PHP files.
  Future<ApiResponse> _otpCall(String path, Map<String, dynamic> query) async {
    try {
      final res = await _otpClient.get(path, queryParameters: query);
      final body = res.data.toString().trim();
      try {
        final json = jsonDecode(body);
        if (json is Map && json["status"] == true) {
          return ApiResponse.completed(json);
        }
        if (json is Map) {
          return ApiResponse.error(
              json["message"]?.toString() ?? "Something went wrong",
              Error.DATA_FETCH_ERROR);
        }
      } catch (_) {}
      final text = body.replaceAll(RegExp(r"<[^>]*>"), " ").toLowerCase();
      if (text.contains("invalid") ||
          text.contains("fail") ||
          text.contains("error") ||
          text.contains("expired")) {
        return ApiResponse.error(
            text.contains("invalid otp") ? "Invalid OTP" : "Something went wrong",
            Error.DATA_FETCH_ERROR);
      }
      return ApiResponse.completed({"status": true, "message": body});
    } on dio.DioException {
      return ApiResponse.error(
          "Network error, please try again", Error.DATA_FETCH_ERROR);
    }
  }

  // Future<ApiResponse> signUp(String phoneNo) async {
  //   return await apiProvider
  //       .makeAPICall("POST", "api/signup", {"phone": phoneNo}).then((value) {
  //     if (value.status == Status.COMPLETED) {
  //       // User user = User.fromJson(value.data["user"]);
  //       // user.token = value.data["token"];
  //       // value.data = user;
  //     }
  //     return value;
  //   });
  // }

  // Future<ApiResponse> verifyOtp(creds) async {
  //   return await apiProvider
  //       .makeAPICall("POST", "api/verify-otp", creds)
  //       .then((value) {
  //     if (value.status == Status.COMPLETED) {
  //       User user = User.fromJson(value.data["user"]);
  //       user.token = value.data["token"];
  //       value.data = user;
  //     }
  //     return value;
  //   });
  // }

  // Future<ApiResponse> setVpin(String vpin) async {
  //   return await apiProvider
  //       .makeAPICall("POST", "api/set-vpin", {"vpin": vpin}).then((value) {
  //     if (value.status == Status.COMPLETED) {
  //       // User user = User.fromJson(value.data["user"]);
  //       // user.token = value.data["token"];
  //       // value.data = user;
  //     }
  //     return value;
  //   });
  // }

  // Future<ApiResponse> setPassword(String password) async {
  //   return await apiProvider.makeAPICall(
  //       "POST", "api/set-password", {"password": password}).then((value) {
  //     if (value.status == Status.COMPLETED) {
  //       // User user = User.fromJson(value.data["user"]);
  //       // user.token = value.data["token"];
  //       // value.data = user;
  //     }
  //     return value;
  //   });
  // }

  Future<ApiResponse> login(creds) async {
    var data = dio.FormData.fromMap(creds);
    return await apiProvider
        .makeAPICall("POST", "login.php", data)
        .then((value) {
      if (value.status == Status.COMPLETED) {
        User user = User.fromJson(value.data["user"] ?? {});
        user.userId = value.data["user_id"];
        value.data = user;
      }
      return value;
    });
  }

  Future<ApiResponse> forgotPassword(String email) async {
    return await apiProvider
        .makeAPICall("POST", "forgot-password.php",
            dio.FormData.fromMap({"email": email}))
        .then((value) {
      if (value.status == Status.COMPLETED) {
        // User user = User.fromJson(value.data["user"]);
        // user.token = value.data["token"];
        // value.data = user;
      }
      return value;
    });
  }

  Future<ApiResponse> fetchUserDetails() async {
    var body = dio.FormData.fromMap({"id": Get.find<AuthService>().token!});
    return await apiProvider
        .makeAPICall("POST", "profile-details.php", body)
        .then((value) {
      if (value.status == Status.COMPLETED) {
        User user = User.fromJson(value.data["user"]);
        value.data = user;
      }
      return value;
    });
  }

  Future<ApiResponse> logout() async {
    return await apiProvider.makeAPICall("GET", "logout", {}).then((value) {
      if (value.status == Status.COMPLETED) {
        User user = User.fromJson(value.data);
        value.data = user;
      }
      return value;
    });
  }

  Future<ApiResponse> register(creds) async {
    var data = dio.FormData.fromMap(creds);
    return await apiProvider
        .makeAPICall("POST", "register.php", data)
        .then((value) {
      if (value.status == Status.COMPLETED) {
        // User user = User.fromJson(value.data);
        // user.token = value.data["token"];
        // value.data = user;
      }
      return value;
    });
  }
}
