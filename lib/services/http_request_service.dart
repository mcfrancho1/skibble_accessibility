import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

///This class handles http requests
class RequestService {

  ///Method to make a http request to get a json formatted String
  ///@param String url the url to make the request
  static Future<dynamic> getRequest(String url) async{

    try {
      http.Response response = await http.get(Uri.parse(url));
      if(response.statusCode == 200) {

        String jsonData = response.body;
        var decodeJson = await jsonDecode(jsonData);

        return decodeJson;
      }

      else {
        print(response.body);
        return 'Failed';
      }
    }
    catch(exception) {
      print(exception);
      return 'Failed';
    }

  }

  Future<String> downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<String> base64encodedImage(String url) async {

    final http.Response response = await http.get(Uri.parse(url));
    final String base64Data = base64Encode(response.bodyBytes);
    return base64Data;

  }

  Future<Uint8List> getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }


}