import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/config.dart';
import 'package:surface/providers/navigation.dart';
import 'package:surface/widgets/connection_indicator.dart';
import 'package:surface/widgets/dialog.dart';
import 'package:surface/widgets/navigation/app_background.dart';
import 'package:surface/widgets/navigation/app_bottom_navigation.dart';
import 'package:surface/widgets/navigation/app_drawer_navigation.dart';
import 'package:surface/widgets/navigation/app_rail_navigation.dart';
import 'package:surface/widgets/notify_indicator.dart';

final globalRootScaffoldKey = GlobalKey<ScaffoldState>();

class AppScaffold extends StatelessWidget {
  final Widget? body;
  final PreferredSizeWidget? bottomNavigationBar;
  final PreferredSizeWidget? bottomSheet;
  final Drawer? drawer;
  final Widget? endDrawer;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final AppBar? appBar;
  final DrawerCallback? onDrawerChanged;
  final DrawerCallback? onEndDrawerChanged;

  const AppScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.drawer,
    this.endDrawer,
    this.onDrawerChanged,
    this.onEndDrawerChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appBarHeight = appBar?.preferredSize.height ?? 0;
    final safeTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: AppBackground(
          child: Column(
            children: [
              IgnorePointer(child: SizedBox(height: appBar != null ? appBarHeight + safeTop : 0)),
              if (body != null) Expanded(child: body!),
            ],
          ),
        ),
      ),
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      floatingActionButtonLocation: floatingActionButtonLocation,
      onDrawerChanged: onDrawerChanged,
      onEndDrawerChanged: onEndDrawerChanged,
    );
  }
}

class PageBackButton extends StatelessWidget {
  const PageBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        GoRouter.of(context).pop();
      },
    );
  }
}

class AppPageScaffold extends StatelessWidget {
  final String? title;
  final Widget? body;
  final bool showAppBar;

  const AppPageScaffold({
    super.key,
    this.title,
    this.body,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final state = GoRouter.maybeOf(context);
    final routeName = state?.routerDelegate.currentConfiguration.last.route.name;

    final autoTitle = state != null ? 'screen${routeName?.capitalize()}' : 'screen';

    return AppScaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(title ?? autoTitle.tr()),
            )
          : null,
      body: body,
    );
  }
}

class AppRootScaffold extends StatelessWidget {
  final Widget body;

  const AppRootScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final cfg = context.watch<ConfigProvider>();
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    final isCollapseDrawer = cfg.drawerIsCollapsed;
    final isExpandedDrawer = cfg.drawerIsExpanded;

    final routeName = GoRouter.of(context).routerDelegate.currentConfiguration.last.route.name;
    final isShowBottomNavigation = NavigationProvider.kShowBottomNavScreen.contains(routeName)
        ? ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
        : false;
    final isPopable = !NavigationProvider.kAllDestination.map((ele) => ele.screen).contains(routeName);

    final innerWidget = isCollapseDrawer
        ? body
        : Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1 / devicePixelRatio,
                    ),
                  ),
                ),
                child: isExpandedDrawer ? AppNavigationDrawer(elevation: 0) : AppRailNavigation(),
              ),
              Expanded(child: body),
            ],
          );

    final windowButtonColor = WindowButtonColors(
      iconNormal: Theme.of(context).colorScheme.primary,
      mouseOver: Theme.of(context).colorScheme.primaryContainer,
      mouseDown: Theme.of(context).colorScheme.onPrimaryContainer,
      iconMouseOver: Theme.of(context).colorScheme.primary,
      iconMouseDown: Theme.of(context).colorScheme.primary,
    );

    final safeTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: globalRootScaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          Column(
            children: [
              if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS))
                WindowTitleBarBox(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1 / devicePixelRatio,
                        ),
                      ),
                    ),
                    child: MoveWindow(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: Platform.isMacOS ? MainAxisAlignment.center : MainAxisAlignment.start,
                        children: [
                          Text(
                            'Solar Network',
                            style: GoogleFonts.spaceGrotesk(),
                          ).padding(horizontal: 12, vertical: 5),
                          if (!Platform.isMacOS)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: MoveWindow()),
                                Row(
                                  children: [
                                    MinimizeWindowButton(colors: windowButtonColor),
                                    MaximizeWindowButton(colors: windowButtonColor),
                                    CloseWindowButton(colors: windowButtonColor),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(child: innerWidget),
            ],
          ),
          Positioned(top: safeTop > 0 ? safeTop : 16, right: 8, child: NotifyIndicator()),
          Positioned(top: safeTop > 0 ? safeTop : 16, left: 8, child: ConnectionIndicator()),
        ],
      ),
      drawer: !isExpandedDrawer ? AppNavigationDrawer() : null,
      drawerEdgeDragWidth: isPopable ? 0 : null,
      bottomNavigationBar: isShowBottomNavigation ? AppBottomNavigationBar() : null,
    );
  }
}
