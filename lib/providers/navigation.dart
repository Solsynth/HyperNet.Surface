import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNavDestination {
  final String label;
  final String screen;
  final Widget icon;
  final bool isPinned;

  const AppNavDestination({
    required this.label,
    required this.screen,
    required this.icon,
    this.isPinned = false,
  });
}

class NavigationProvider extends ChangeNotifier {
  int? _currentIndex;

  int? get currentIndex => _currentIndex;

  static const List<String> kShowBottomNavScreen = [
    'home',
    'explore',
    'account',
    'album',
    'chat',
  ];

  static const List<AppNavDestination> kAllDestination = [
    AppNavDestination(
      icon: Icon(Symbols.home, weight: 400, opticalSize: 20),
      screen: 'home',
      label: 'screenHome',
    ),
    AppNavDestination(
      icon: Icon(Symbols.explore, weight: 400, opticalSize: 20),
      screen: 'explore',
      label: 'screenExplore',
    ),
    AppNavDestination(
      icon: Icon(Symbols.chat, weight: 400, opticalSize: 20),
      screen: 'chat',
      label: 'screenChat',
    ),
    AppNavDestination(
      icon: Icon(Symbols.account_circle, weight: 400, opticalSize: 20),
      screen: 'account',
      label: 'screenAccount',
    ),
    AppNavDestination(
      icon: Icon(Symbols.group, weight: 400, opticalSize: 20),
      screen: 'realm',
      label: 'screenRealm',
    ),
    AppNavDestination(
      icon: Icon(Symbols.newspaper, weight: 400, opticalSize: 20),
      screen: 'news',
      label: 'screenNews',
    ),
    AppNavDestination(
      icon: Icon(Symbols.emoji_emotions, weight: 400, opticalSize: 20),
      screen: 'stickers',
      label: 'screenStickers',
    ),
    AppNavDestination(
      icon: Icon(Symbols.photo_library, weight: 400, opticalSize: 20),
      screen: 'album',
      label: 'screenAlbum',
    ),
    AppNavDestination(
      icon: Icon(Symbols.diversity_4, weight: 400, opticalSize: 20),
      screen: 'friend',
      label: 'screenFriend',
    ),
    AppNavDestination(
      icon: Icon(Symbols.notifications, weight: 400, opticalSize: 20),
      screen: 'notification',
      label: 'screenNotification',
    ),
  ];
  static const List<String> kDefaultPinnedDestination = [
    'home',
    'explore',
    'chat',
    'account',
  ];

  List<AppNavDestination> destinations = [];

  int get pinnedDestinationCount =>
      destinations.where((ele) => ele.isPinned).length;

  NavigationProvider() {
    buildDestinations(kDefaultPinnedDestination);
    SharedPreferences.getInstance().then((prefs) {
      final pinned = prefs.getStringList("app_pinned_navigation");
      if (pinned != null) buildDestinations(pinned);
    });
  }

  void buildDestinations(List<String> pinned) {
    destinations = kAllDestination
        .map(
          (ele) => AppNavDestination(
            label: ele.label,
            screen: ele.screen,
            icon: ele.icon,
            isPinned: pinned.contains(ele.screen),
          ),
        )
        .toList();
    notifyListeners();
  }

  int getIndexInRange(int min, int max) {
    return math.max(min, math.min(_currentIndex ?? 0, max));
  }

  bool isIndexInRange(int min, int max) {
    return _currentIndex != null &&
        _currentIndex! >= min &&
        _currentIndex! < max;
  }

  void autoDetectIndex(GoRouter? state) {
    if (state == null) return;
    final idx = destinations.indexWhere(
      (ele) =>
          ele.screen ==
          state.routerDelegate.currentConfiguration.last.route.name,
    );
    _currentIndex = idx == -1 ? null : idx;
    notifyListeners();
  }

  void setIndex(int idx) {
    _currentIndex = idx;
    notifyListeners();
  }
}
