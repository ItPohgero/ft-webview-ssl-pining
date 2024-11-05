import 'dart:async';
import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigUtils {
  Future<Map<String, bool>> parseJsonConfig(String rawJson) async {
    final Map<String, dynamic> jsonMap = jsonDecode(rawJson);
    final Map<String, bool> visibilityMap =
    jsonMap.map((key, value) => MapEntry(key, value == true));
    print('Parsed visibility map: $visibilityMap');
    return visibilityMap;
  }

  static Future<void> initializeRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 12),
      ));

      bool activated = await remoteConfig.fetchAndActivate();
      print('Remote Config fetched and activated: $activated');

      remoteConfig.onConfigUpdated.listen((event) async {
        final Set<String> updatedKeys = event.updatedKeys;
        print('Config updated. Keys: $updatedKeys');

        for (var key in updatedKeys) {
          String updatedValue = remoteConfig.getString(key);
          print("Updated key: $key, Updated value: $updatedValue");
        }
      });
    } catch (e) {
      print('Error initializing remote config: $e');
    }
  }
}
