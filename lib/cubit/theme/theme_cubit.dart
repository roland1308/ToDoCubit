import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../sharedpreferences/shared_preferences_manager.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeLight(Icons.dark_mode));

  void toggleTheme() {
    if (state is ThemeDark) {
      SharedPreferencesManager().setThemeMode("light");
      emit(const ThemeLight(Icons.dark_mode));
    } else {
      SharedPreferencesManager().setThemeMode("dark");
      emit(const ThemeDark(Icons.light_mode));
    }
  }

  void setInitialTheme(String themeMode) {
    if (themeMode == "light") {
      emit(const ThemeLight(Icons.dark_mode));
    } else {
      emit(const ThemeDark(Icons.light_mode));
    }
  }
}
