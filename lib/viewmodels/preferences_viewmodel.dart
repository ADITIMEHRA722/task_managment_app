import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/preferences_service.dart';

final preferencesProvider = ChangeNotifierProvider<PreferencesViewModel>((ref) => PreferencesViewModel());

class PreferencesViewModel extends ChangeNotifier {
  final PreferencesService _preferencesService = PreferencesService();

  bool _isDarkMode;
  String _sortOrder;

  bool get isDarkMode => _isDarkMode;
  String get sortOrder => _sortOrder;

  PreferencesViewModel()
      : _isDarkMode = PreferencesService().isDarkMode,
        _sortOrder = PreferencesService().sortOrder;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _preferencesService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setSortOrder(String order) {
    _sortOrder = order;
    _preferencesService.setSortOrder(order);
    notifyListeners();
  }
}
