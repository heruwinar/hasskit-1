import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:hasskit/model/entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EntityType {
  lightSwitches,
  climateFans,
  cameras,
  mediaPlayers,
  others,
}

abstract class Settings {
  static void saveBool(String key, bool content) async {
    var _preferences = await SharedPreferences.getInstance();
    _preferences.setBool(key, content);
    print('saveBool: key $key content $content');
  }

  static Future<bool> getBool(String key) async {
    var _preferences = await SharedPreferences.getInstance();
    var value = _preferences.getBool(key) ?? false;
    return value;
  }

  static void saveString(String key, String content) async {
    var _preferences = await SharedPreferences.getInstance();
    _preferences.setString(key, content);
    print('saveString: key $key content $content');
  }

  static Future<String> getString(String key) async {
    var _preferences = await SharedPreferences.getInstance();
    var value = _preferences.getString(key) ?? '';
    return value;
  }

  static Color get randomColor {
    final Random random = Random();
    var color = Color.fromARGB(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    return color;
  }

  static int connectionIndex = 0;

  static List<String> urls = [
    'hasskitdemo.duckdns.org:8123',
  ];

  static List<bool> ssls = [
    false,
  ];

  static List<String> tokens = [
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJkMmQzYTQ4OTY3MzY0YTBkOTQzMjg3OWZhMGRlMzE2MiIsImlhdCI6MTU3MDA5Mjk3NCwiZXhwIjoxODg1NDUyOTc0fQ.n9ioMQYzZPkS93uGGJMbS9kv0Vc6-E0dOrMwE_bscnU',
  ];

  static Map<String, String> headers = {
    'Authorization': 'Bearer ${tokens[connectionIndex]}',
    'content-type': 'application/json',
  };

  static List<String> notSupportedDeviceType = [
    '.updater',
    'automation.',
    'device_tracker.',
    'group.',
    'person.',
    'script.',
    'sun.',
    'weather.',
    'zone.',
//  'timer.',
  ];

  static List<String> assetBackgroundImage = [
    'assets/background_images/DarkBlue-iOS-13-Home-app-wallpaper.jpg',
    'assets/background_images/DarkGreen-iOS-13-Home-app-wallpaper.jpg',
    'assets/background_images/LightBlue-iOS-13-Home-app-wallpaper.jpg',
    'assets/background_images/LightGreen-iOS-13-Home-app-wallpaper.jpg',
    'assets/background_images/Orange-iOS-13-Home-app-wallpaper.jpg',
    'assets/background_images/Red-iOS-13-Home-app-wallpaper.jpg',
  ];

  static String getRoomImage(int image) {
    var assetBackgroundImageTotal = assetBackgroundImage.length;
    var index = 0;
    int div = image ~/ assetBackgroundImageTotal;
    index = image - (div * assetBackgroundImageTotal);
    return assetBackgroundImage[index];
  }

  static List<Entity> entityTypeFilter(
      List<Entity> entities, EntityType entityType) {
    return entities.where((e) => e.entityType == entityType).toList();
  }
}
