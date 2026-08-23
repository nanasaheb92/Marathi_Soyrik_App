import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import '../models/api_response.dart';
import '../providers/api_client.dart';

import '../services/auth_service.dart';
import 'api_endpoints.dart';

class ApiProvider extends GetxService with ApiClient {
  late dio.Dio _httpClient;
  late AuthService authService;

  ApiProvider() {
    authService = Get.find<AuthService>();
    this.baseUrl = Urls.baseUrl;
    _httpClient = new dio.Dio();
  }

  Future<ApiProvider> init() async {
    _httpClient.options.baseUrl = this.baseUrl!;
    _httpClient.options.connectTimeout = Duration(seconds: 60);
    return this;
  }

  void forceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {}
  }

  void unForceRefresh({Duration duration = const Duration(minutes: 10)}) {
    if (!foundation.kDebugMode) {
      // _optionsCache = buildCacheOptions(duration, forceRefresh: false);
    }
  }

  Map<String, dynamic> get getHeaders {
    return _httpClient.options.headers;
  }

  Future<String> uploadFile(File file) async {
    dio.FormData data = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(file.path, filename: file.path)
    });

    return await Get.find<ApiProvider>()
        .makeAPICall("POST", "upload", data)
        .then((value) {
      return value.data["filename"];
    });
  }

  Future<ApiResponse> getOTPLessUser(String waID) async {
    String client_id = "5f02sso2";
    String client_secret = "giekc535x6ghzkrh";

    dio.Dio client = dio.Dio();
    client.options.baseUrl = "https://innovizia.authlink.me";
    client.options.headers.addAll({
      "clientId": client_id,
      "clientSecret": client_secret,
      "Content-Type": "application/json",
    });
    var result = await client.post("", data: {"waId": waID});

    var response = jsonDecode(result.data);
    if (response["statusCode"] == 200) {
      return ApiResponse.completed(response["user"]);
    } else {
      return ApiResponse.error(response["error"], Error.DATA_FETCH_ERROR);
    }
  }

  Future<ApiResponse> makeAPICall(method, endpoint, data) async {
    var url = Uri.parse(Urls.getApiUrl(endpoint));

    if (kDebugMode) {
      print("--- API Request Log ---");
      print("Method: $method");
      print("URL: $url");
      print("Headers: ${_httpClient.options.headers}");
      if (data is dio.FormData) {
        print("Body (FormData): ${data.fields.map((e) => "${e.key}: ${e.value}").toList()}");
      } else {
        print("Body: $data");
      }
      print("-----------------------");
    }

    try {
      var result;
      switch (method) {
        case "GET":
          result = await _httpClient.get(url.path, queryParameters: data);
          break;
        case "POST":
          result = await _httpClient.post(url.path, data: data);
          break;
        case "PUT":
          result = await _httpClient.put(url.path, data: data);
          break;
        case "DELETE":
          result = await _httpClient.delete(url.path, data: data);
          break;
        default:
          return ApiResponse.error("Invalid Request", Error.INVALID_REQUEST);
      }
      if (result != null) {
        var response = result.data;
        if (kDebugMode) {
          print("--- API Response Log ---");
          print("Endpoint: $endpoint");
          print("Response: $response");
          print("------------------------");
        }
        if (response["status"]) {
          return ApiResponse.completed(result.data);
        } else {
          return ApiResponse.error(response["message"], Error.DATA_FETCH_ERROR);
        }
      } else {
        return ApiResponse.error("Page Not Found", Error.INVALID_ROUTE);
      }
    } on dio.DioException catch (ex) {
      if (ex.type == dio.DioExceptionType.connectionTimeout) {
        return ApiResponse.error("Connection Timeout", Error.TIME_OUT_ERROR);
      }
      if (ex.response != null) {
        switch (ex.response!.statusCode) {
          case 404:
            return ApiResponse.error(
                ex.response!.data["message"], Error.DATA_FETCH_ERROR);
          case 403:
            return ApiResponse.error(
                ex.response!.data["message"], Error.DATA_FETCH_ERROR);
          default:
            return ApiResponse.error(
                "An Error occured ", Error.DATA_FETCH_ERROR);
        }
      } else {
        return ApiResponse.error("An Error occured ", Error.DATA_FETCH_ERROR);
      }
    }
  }
}
