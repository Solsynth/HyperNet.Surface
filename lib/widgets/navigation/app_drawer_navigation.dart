import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/navigation.dart';
import 'package:surface/widgets/version_label.dart';

class AppNavigationDrawer extends StatefulWidget {
  final double? elevation;

  const AppNavigationDrawer({super.key, this.elevation});

  @override
  State<AppNavigationDrawer> createState() => _AppNavigationDrawerState();
}

class _AppNavigationDrawerState extends State<AppNavigationDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NavigationProvider>().autoDetectIndex(GoRouter.maybeOf(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationProvider>();

    final backgroundColor = ResponsiveBreakpoints.of(context).largerThan(TABLET) ? Colors.transparent : null;

    return ListenableBuilder(
      listenable: nav,
      builder: (context, _) {
        final destinations = [
          ...nav.destinations.where((ele) => ele.isPinned),
          ...nav.destinations.where((ele) => !ele.isPinned),
        ];

        return NavigationDrawer(
          elevation: widget.elevation,
          backgroundColor: backgroundColor,
          selectedIndex: nav.currentIndex,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Solar Network').bold(),
                AppVersionLabel(),
              ],
            ).padding(
              horizontal: 32,
              vertical: 12,
            ),
            ...destinations.where((ele) => ele.isPinned).map((ele) {
              return NavigationDrawerDestination(
                icon: ele.icon,
                label: Text(ele.label).tr(),
              );
            }),
            const Divider(),
            ...destinations.where((ele) => !ele.isPinned).map((ele) {
              return NavigationDrawerDestination(
                icon: ele.icon,
                label: Text(ele.label).tr(),
              );
            }),
          ],
          onDestinationSelected: (idx) {
            nav.setIndex(idx);
            GoRouter.of(context).goNamed(destinations[idx].screen);
            Scaffold.of(context).closeDrawer();
          },
        );
      },
    );
  }
}
