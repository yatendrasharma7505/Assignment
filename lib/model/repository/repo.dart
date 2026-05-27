import 'package:assignment/model/response/reels_response.dart';
import 'package:assignment/services/api_client.dart';

class Repo {
  final ApiClient _apiClient = ApiClient();

  Future<ReelsResponse> fetchReels() async {
    final response = await _apiClient.client.get(
      "Reels",
      queryParameters: {
        "key": "AIzaSyCHMfURxMKCnQykenc1kTy11q2ojM2xxGY",
      },
    );

    if (response.statusCode == 200) {
      return ReelsResponse.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception("Failed to load reels");
    }
  }
}
