import 'dart:convert';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class Environment {
  late final String apiUrl;

  Environment._(this.apiUrl);

  static late Environment _current;

  static Environment get current => _current;

  static Future<void> initialize(String flavor) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      final apiUrlsJson = remoteConfig.getString('base_url_api');
      print('Fetched Remote Config JSON: $apiUrlsJson');

      if (apiUrlsJson.isEmpty) {
        throw const FormatException('The fetched JSON is empty.');
      }

      final apiUrls = jsonDecode(apiUrlsJson) as Map<String, dynamic>;
      print('Decoded API URLs: $apiUrls');

      // Extract URL for the specified flavor
      final apiUrl = (apiUrls['api_urls'] as Map<String, dynamic>)[flavor] as String?;
      print('API URL for $flavor: $apiUrl');

      _current = Environment._(apiUrl ?? '');
    } catch (e) {
      print('Error initializing environment: $e');
      _current = Environment._('');
    }
  }
}
