import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://store10hti.herokuapp.com/',
        receiveDataWhenStatusError: true,
        headers:
        {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> get(String url, ) async {
    return await dio.get(url);
  }

  static Future<Response> getData({
    required String url,
    String? token,
    Map<String, dynamic>? query,
  }) {
    if(token != null) {
      token = "Bearer $token" ;
    }
    return dio.get(
      url,
      options: Options(
        headers: {
          'lang':'en',
          'Content-Type':'application/json',
          'Authorization':token??'',
        },
      ),
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required Map<String, dynamic> data,
    required String url,
    String? token,
  }) {
    if(token != null) {
      token = "Bearer $token" ;
    }

    return dio.post(
      url,
      data: data,
      options: Options(
        headers: {
          'Content-Type':'application/json',
          'Authorization':token??'',
        },
      ),
    );
  }


  static Future<Response> patchData({
    required Map<String, dynamic> data,
    required String url,
    String? token,
  }) {
    if(token != null) {
      token = "Bearer $token" ;
    }

    return dio.patch(
      url,
      data: data,
      options: Options(
        headers: {
          'Content-Type':'application/json',
          'Authorization':token??'',
        },
      ),
    );
  }
  static Future<Response> deleteData({
    required String url,
    String? token,
  }) {
    if(token != null) {
      token = "Bearer $token" ;
    }

    return dio.delete(
      url,
      options: Options(
        headers: {
          'Content-Type':'application/json',
          'Authorization':token??'',
        },
      ),
    );
  }



}
