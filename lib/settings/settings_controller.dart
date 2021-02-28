import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SettingsController extends GetxController {
  var box = Hive.box('myBox');
  bool hasCredentials = false;

  Map<String, bool> relays = {};

  void addRelay(String url, [bool enabled = true]) {
    relays[url] = enabled;
    update();
  }
}
