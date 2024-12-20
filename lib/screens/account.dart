import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/providers/userinfo.dart';
import 'package:surface/providers/websocket.dart';
import 'package:surface/widgets/account/account_image.dart';
import 'package:surface/widgets/app_bar_leading.dart';
import 'package:surface/widgets/dialog.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ua = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        leading: AutoAppBarLeading(),
        title: Text("screenAccount").tr(),
        actions: [
          IconButton(
            icon: const Icon(Symbols.settings, fill: 1),
            onPressed: () {
              GoRouter.of(context).pushNamed('settings');
            },
          ),
          const Gap(8),
        ],
      ),
      body: SingleChildScrollView(
        child: ua.isAuthorized ? _AuthorizedAccountScreen() : _UnauthorizedAccountScreen(),
      ),
    );
  }
}

class _AuthorizedAccountScreen extends StatelessWidget {
  const _AuthorizedAccountScreen();

  @override
  Widget build(BuildContext context) {
    final ua = context.watch<UserProvider>();

    return Column(
      children: [
        Card(
          child: Builder(builder: (context) {
            if (ua.user == null) {
              return SizedBox(
                width: double.infinity,
                height: 120,
                child: CircularProgressIndicator().center(),
              );
            }

            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AccountImage(content: ua.user!.avatar, radius: 28),
                  const Gap(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(ua.user!.nick).textStyle(Theme.of(context).textTheme.titleLarge!),
                      const Gap(4),
                      Text('@${ua.user!.name}').textStyle(Theme.of(context).textTheme.bodySmall!),
                    ],
                  ),
                  Text(ua.user!.description).textStyle(Theme.of(context).textTheme.bodyMedium!),
                ],
              ),
            );
          }).padding(all: 20),
        ).padding(horizontal: 8, top: 16, bottom: 4),
        ListTile(
          title: Text('accountProfileEdit').tr(),
          subtitle: Text('accountProfileEditSubtitle').tr(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.contact_page),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () {
            GoRouter.of(context).pushNamed('accountProfileEdit');
          },
        ),
        ListTile(
          title: Text('accountPublishers').tr(),
          subtitle: Text('accountPublishersSubtitle').tr(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.face),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () {
            GoRouter.of(context).pushNamed('accountPublishers');
          },
        ),
        ListTile(
          title: Text('abuseReport').tr(),
          subtitle: Text('abuseReportActionDescription').tr(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.flag),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () {
            GoRouter.of(context).pushNamed('abuseReport');
          },
        ),
        ListTile(
          title: Text('accountLogout').tr(),
          subtitle: Text('accountLogoutSubtitle').tr(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.logout),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () async {
            final confirm = await context.showConfirmDialog(
              'accountLogoutConfirmTitle'.tr(),
              'accountLogoutConfirm'.tr(),
            );

            if (!confirm) return;
            if (!context.mounted) return;
            ua.logoutUser();
            final ws = context.read<WebSocketProvider>();
            ws.disconnect();
            await Hive.deleteFromDisk();
            await Hive.initFlutter();
          },
        ),
        ListTile(
          title: Text('accountDeletion'.tr()),
          subtitle: Text('accountDeletionActionDescription'.tr()),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.person_cancel),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () {
            context
                .showConfirmDialog(
              'accountDeletion'.tr(),
              'accountDeletionDescription'.tr(),
            )
                .then((value) {
              if (!value || !context.mounted) return;
              final sn = context.read<SnNetworkProvider>();
              sn.client.post('/cgi/id/users/me/deletion').then((value) {
                if (context.mounted) {
                  context.showSnackbar('accountDeletionSubmitted'.tr());
                }
              }).catchError((err) {
                if (context.mounted) {
                  context.showErrorDialog(err);
                }
              });
            });
          },
        ),
      ],
    );
  }
}

class _UnauthorizedAccountScreen extends StatelessWidget {
  const _UnauthorizedAccountScreen();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  child: Icon(Symbols.waving_hand, size: 28),
                ),
                const Gap(8),
                Text('accountIntroTitle').tr().textStyle(Theme.of(context).textTheme.titleLarge!),
                Text('accountIntroSubtitle').tr(),
              ],
            ).padding(all: 20),
          ),
        ).padding(horizontal: 8, top: 16, bottom: 4),
        ListTile(
          title: Text('screenAuthLogin').tr(),
          subtitle: Text('screenAuthLoginSubtitle').tr(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.login),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () {
            GoRouter.of(context).pushNamed('authLogin').then((value) {
              if (value == true && context.mounted) {
                final ua = context.read<UserProvider>();
                context.showSnackbar('loginSuccess'.tr(args: [
                  '@${ua.user?.name} (${ua.user?.nick})',
                ]));
              }
            });
          },
        ),
        ListTile(
          title: Text('screenAuthRegister').tr(),
          subtitle: Text('screenAuthRegisterSubtitle').tr(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
          leading: const Icon(Symbols.person_add),
          trailing: const Icon(Symbols.chevron_right),
          onTap: () {
            GoRouter.of(context).pushNamed('authRegister');
          },
        ),
      ],
    );
  }
}
