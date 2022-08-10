import 'package:dio/dio.dart';
import "../models/app_config.dart";
import 'package:get_it/get_it.dart';

class HTTPService {
  final Dio dio = Dio();

  AppConfig? _appConfig;
  String? _baseURL;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _baseURL = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String path) async {
    try {
      String url = "$_baseURL$path";

      //testing query parameters in dio http request
      // dio.get("path",
      //  queryParameters: {
      //    "id": 1,
      //    "value": 2,
      //  },
      //  options: {
      //    headers: {
      //      "API_KEY": APIKEY,
      //    }
      //  },
      // )

      Response response = await dio.get(url);
      return response;
    } catch (error) {
      print("HTTPService error - $error");
    }
    return null;
  }
}
