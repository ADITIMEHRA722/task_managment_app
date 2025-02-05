import 'package:hive/hive.dart';

class PreferencesService {
  static final _box = Hive.box('preferences');

  // Get the theme mode (default is light)
  bool get isDarkMode => _box.get('isDarkMode', defaultValue: false);

  // Set the theme mode
  Future<void> setDarkMode(bool value) async {
    await _box.put('isDarkMode', value);
  }

  // Get the sorting order (default is by date)
  String get sortOrder => _box.get('sortOrder', defaultValue: 'date');

  // Set the sorting order
  Future<void> setSortOrder(String value) async {
    await _box.put('sortOrder', value);
  }
}
