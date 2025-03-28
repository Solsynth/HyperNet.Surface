import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/channel.dart';
import 'package:surface/providers/config.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/providers/sn_realm.dart';
import 'package:surface/providers/userinfo.dart';
import 'package:surface/types/chat.dart';
import 'package:surface/types/realm.dart';
import 'package:surface/widgets/account/account_image.dart';
import 'package:surface/widgets/dialog.dart';
import 'package:surface/widgets/loading_indicator.dart';
import 'package:surface/widgets/navigation/app_scaffold.dart';
import 'package:surface/widgets/realm/realm_item.dart';

class RealmDiscoveryScreen extends StatefulWidget {
  const RealmDiscoveryScreen({super.key});

  @override
  State<RealmDiscoveryScreen> createState() => _RealmDiscoveryScreenState();
}

class _RealmDiscoveryScreenState extends State<RealmDiscoveryScreen> {
  List<SnRealm>? _realms;
  bool _isBusy = false;
  bool _isCompactView = false;

  Future<void> _fetchRealms() async {
    try {
      setState(() => _isBusy = true);
      final sn = context.read<SnNetworkProvider>();
      final resp = await sn.client.get('/cgi/id/realms');
      _realms = List<SnRealm>.from(
        resp.data?.map((e) => SnRealm.fromJson(e)) ?? [],
      );
    } catch (err) {
      if (mounted) context.showErrorDialog(err);
      rethrow;
    } finally {
      setState(() => _isBusy = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _isCompactView = context.read<ConfigProvider>().realmCompactView;
    _fetchRealms();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text('screenRealmDiscovery').tr(),
        actions: [
          IconButton(
            icon: _isCompactView
                ? const Icon(Symbols.view_list)
                : const Icon(Symbols.view_module),
            onPressed: () {
              setState(() => _isCompactView = !_isCompactView);
              context.read<ConfigProvider>().realmCompactView = _isCompactView;
            },
          ),
          const Gap(8),
        ],
      ),
      body: Column(
        children: [
          LoadingIndicator(isActive: _isBusy),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRealms,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _realms?.length ?? 0,
                itemBuilder: (context, idx) {
                  final realm = _realms![idx];
                  return RealmItemWidget(
                    item: realm,
                    isListView: _isCompactView,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _RealmJoinPopup(realm: realm),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RealmJoinPopup extends StatefulWidget {
  final SnRealm realm;

  const _RealmJoinPopup({required this.realm});

  @override
  State<_RealmJoinPopup> createState() => _RealmJoinPopupState();
}

class _RealmJoinPopupState extends State<_RealmJoinPopup> {
  final List<String> _planJoinChannels = List.empty(growable: true);

  List<SnChannel>? _channels;
  bool _isBusy = false;
  bool _isJoining = false;

  Future<void> _fetchPublicChannels() async {
    try {
      setState(() => _isBusy = true);
      final sn = context.read<SnNetworkProvider>();
      final resp =
          await sn.client.get('/cgi/im/channels/${widget.realm.alias}/public');
      final out = List<SnChannel>.from(
        resp.data.map((e) => SnChannel.fromJson(e)).cast<SnChannel>(),
      );
      setState(() => _channels = out);
    } catch (err) {
      if (!mounted) return;
      context.showErrorDialog(err);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _joinRealm() async {
    try {
      setState(() => _isJoining = true);
      final sn = context.read<SnNetworkProvider>();
      final ua = context.read<UserProvider>();
      final rel = context.read<SnRealmProvider>();
      await sn.client
          .post('/cgi/id/realms/${widget.realm.alias}/members', data: {
        'related': ua.user?.name,
      });
      await _joinSelectedChannels();
      rel.addAvailableRealm(widget.realm);
      if (!mounted) return;
      context.showSnackbar('realmJoined'.tr(args: [widget.realm.name]));
      Navigator.pop(context);
    } catch (err) {
      if (!mounted) return;
      context.showErrorDialog(err);
    } finally {
      setState(() => _isJoining = false);
    }
  }

  Future<void> _joinSelectedChannels() async {
    if (_planJoinChannels.isEmpty) return;
    for (final channel in _planJoinChannels) {
      try {
        final sn = context.read<SnNetworkProvider>();
        final ua = context.read<UserProvider>();
        await sn.client.post(
            '/cgi/im/channels/${widget.realm.alias}/$channel/members',
            data: {
              'related': ua.user?.name,
            });
      } catch (err) {
        if (!mounted) return;
        context.showErrorDialog(err);
      }
      final ct = context.read<ChatChannelProvider>();
      for (final channel
          in _channels!.where((ele) => _planJoinChannels.contains(ele.alias))) {
        ct.addAvailableChannel(channel);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPublicChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Symbols.group_add, size: 24),
            const Gap(16),
            Text('realmJoin', style: Theme.of(context).textTheme.titleLarge)
                .tr(),
          ],
        ).padding(horizontal: 20, top: 16, bottom: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.realm.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    widget.realm.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _isJoining ? null : () => _joinRealm(),
              child: Text('join'.tr()),
            ),
          ],
        ).padding(horizontal: 24, bottom: 12),
        const Divider(height: 1),
        LoadingIndicator(isActive: _isBusy),
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: Text('realmCommunityPublicChannelsHint'.tr(),
                  style: Theme.of(context).textTheme.bodyMedium)
              .padding(horizontal: 24, vertical: 8),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _channels?.length ?? 0,
            itemBuilder: (context, index) {
              final channel = _channels![index];
              return CheckboxListTile(
                value: _planJoinChannels.contains(channel.alias),
                title: Text(channel.name),
                subtitle: Text(
                  channel.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                secondary: AccountImage(
                  content: null,
                  fallbackWidget: const Icon(Symbols.chat, size: 20),
                ),
                onChanged: (value) {
                  value ??= false;
                  if (value) {
                    setState(() => _planJoinChannels.add(channel.alias));
                  } else {
                    setState(() => _planJoinChannels.remove(channel.alias));
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
