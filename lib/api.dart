import 'package:dio/dio.dart';
import 'package:funnumbers/config.dart';

class API {
  static Dio _instance;
  static Dio get instance {
    if (_instance == null) {
      _instance = new Dio(
          BaseOptions(baseUrl: baseURL, responseType: ResponseType.plain));

      _instance.interceptors.add(InterceptorsWrapper(onError: (err) {
        print("""dio Error:${err.error}""");
      }, onRequest: (req) {
        print('''dio Request:${req.path} ${req.queryParameters} ${req.data}''');
      }, onResponse: (res) {
        print(
            '''dio Response: ${res.statusCode} ${res.request.path} ${res.statusMessage} ''');
      }));
    }
    return _instance;
  }
}
