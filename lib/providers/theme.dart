import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:surface/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeSet? theme;

  ThemeProvider() {
    createAppThemeSet().then((value) {
      theme = value;
      notifyListeners();
    });
  }

  void reloadTheme({Color? seedColorOverride, bool? useMaterial3}) {
    createAppThemeSet(seedColorOverride: seedColorOverride, useMaterial3: useMaterial3).then((value) {
      theme = value;
      notifyListeners();
    });
  }
}
