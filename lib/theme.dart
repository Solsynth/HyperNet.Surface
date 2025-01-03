import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:surface/providers/config.dart';

const kMaterialYouToggleStoreKey = 'app_theme_material_you';

class ThemeSet {
  ThemeData light;
  ThemeData dark;

  ThemeSet({required this.light, required this.dark});
}

Future<ThemeSet> createAppThemeSet({Color? seedColorOverride, bool? useMaterial3}) async {
  return ThemeSet(
    light: await createAppTheme(Brightness.light, useMaterial3: useMaterial3),
    dark: await createAppTheme(Brightness.dark, useMaterial3: useMaterial3),
  );
}

Future<ThemeData> createAppTheme(
  Brightness brightness, {
    Color? seedColorOverride,
  bool? useMaterial3,
}) async {
  final prefs = await SharedPreferences.getInstance();

  final seedColorString = prefs.getInt(kAppColorSchemeStoreKey);
  final seedColor = seedColorString != null ? Color(seedColorString) : Colors.indigo;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: seedColorOverride ?? seedColor,
    brightness: brightness,
  );

  final hasAppBarBlurry = prefs.getBool(kAppbarTransparentStoreKey) ?? false;

  return ThemeData(
    useMaterial3: useMaterial3 ?? (prefs.getBool(kMaterialYouToggleStoreKey) ?? false),
    colorScheme: colorScheme,
    brightness: brightness,
    iconTheme: IconThemeData(
      fill: 0,
      weight: 400,
      opticalSize: 20,
      color: colorScheme.onSurface,
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: hasAppBarBlurry ? 0 : null,
      backgroundColor: hasAppBarBlurry ? colorScheme.surfaceContainer.withAlpha(200) : colorScheme.primary,
      foregroundColor: hasAppBarBlurry ? colorScheme.onSurface : colorScheme.onPrimary,
    ),
    scaffoldBackgroundColor: Colors.transparent,
  );
}
