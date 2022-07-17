import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();
}