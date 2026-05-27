import 'package:dio/dio.dart';

class ApiClient {

  final Dio _dio = Dio(

    BaseOptions(

      baseUrl:
      "https://firestore.googleapis.com/v1/projects/assignment-1832b/databases/(default)/documents/",

      connectTimeout:
      const Duration(seconds: 30),

      receiveTimeout:
      const Duration(seconds: 30),

      headers: {
        "Content-Type":
        "application/json",
      },
    ),
  );

  Dio get client => _dio;
}