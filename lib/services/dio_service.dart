

import 'dart:convert';

import 'package:dio/dio.dart';

class DioService {



  static Future<dynamic> getRequest(String url) async{

    try {
      final dio = Dio();

      final response = await dio.get(url,);

      if(response.statusCode == 200) {

        String jsonData = response.data;
        var decodeJson = await jsonDecode(jsonData);

        return decodeJson;
      }

      else {
        return 'Failed';
      }
    }
    catch(exception) {
      return 'Failed';
    }

  }

  static Future<dynamic> getRequestWithAPIKey(String url, String apiKey, Map<String, dynamic> queryParameters) async{

    try {
      final dio = Dio();

      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': apiKey,
          },
        ),
        queryParameters: queryParameters
      );

      if(response.statusCode == 200) {

        return response.data;
      }

      else {
        return 'Failed';
      }
    }
    catch(exception) {
      print(exception);
      return 'Failed';
    }

  }

}