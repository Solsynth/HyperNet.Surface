import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/providers/userinfo.dart';
import 'package:surface/types/realm.dart';
import 'package:surface/widgets/account/account_image.dart';
import 'package:surface/widgets/app_bar_leading.dart';
import 'package:surface/widgets/dialog.dart';
import 'package:surface/widgets/loading_indicator.dart';
import 'package:surface/widgets/navigation/app_scaffold.dart';
import 'package:surface/widgets/unauthorized_hint.dart';
import 'package:surface/widgets/universal_image.dart';

class RealmScreen extends StatefulWidget {
  const RealmScreen({super.key});

  @override
  State<RealmScreen> createState() => _RealmScreenState();
}

class _RealmScreenState extends State<RealmScreen> {
  bool _isBusy = false;
  bool _isCompactView = false;

  List<SnRealm>? _realms;

  Future<void> _fetchRealms() async {
    final ua = context.read<UserProvider>();
    if (!ua.isAuthorized) return;

    setState(() => _isBusy = true);
    try {
      final sn = context.read<SnNetworkProvider>();
      final resp = await sn.client.get('/cgi/id/realms/me/available');
      _realms = List<SnRealm>.from(
        resp.data?.map((e) => SnRealm.fromJson(e)) ?? [],
      );
    } catch (err) {
      if (mounted) context.showErrorDialog(err);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  Future<void> _deleteRealm(SnRealm realm) async {
    final confirm = await context.showConfirmDialog(
      'realmDelete'.tr(args: ['#${realm.alias}']),
      'realmDeleteDescription'.tr(),
    );
    if (!confirm) return;

    if (!mounted) return;
    final sn = context.read<SnNetworkProvider>();

    setState(() => _isBusy = true);

    try {
      await sn.client.delete('/cgi/id/realms/${realm.alias}');
      if (!mounted) return;
      context.showSnackbar('realmDeleted'.tr(args: ['#${realm.alias}']));
      _fetchRealms();
    } catch (err) {
      if (!mounted) return;
      context.showErrorDialog(err);
    } finally {
      setState(() => _isBusy = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRealms();
  }

  @override
  Widget build(BuildContext context) {
    final sn = context.read<SnNetworkProvider>();
    final ua = context.read<UserProvider>();

    if (!ua.isAuthorized) {
      return AppScaffold(
        appBar: AppBar(
          leading: AutoAppBarLeading(),
          title: Text('screenRealm').tr(),
        ),
        body: Center(
          child: UnauthorizedHint(),
        ),
      );
    }

    return AppScaffold(
      appBar: AppBar(
        leading: AutoAppBarLeading(),
        title: Text('screenRealm').tr(),
        actions: [
          IconButton(
            icon: !_isCompactView ? const Icon(Symbols.view_list) : const Icon(Symbols.view_module),
            onPressed: () {
              setState(() => _isCompactView = !_isCompactView);
            },
          ),
          const Gap(8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Symbols.group_add),
        onPressed: () {
          GoRouter.of(context).pushNamed('realmManage');
        },
      ),
      body: Column(
        children: [
          LoadingIndicator(isActive: _isBusy),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchRealms,
              child: ListView.builder(
                itemCount: _realms?.length ?? 0,
                itemBuilder: (context, idx) {
                  final realm = _realms![idx];
                  if (_isCompactView) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      leading: AccountImage(
                        content: realm.avatar,
                        fallbackWidget: const Icon(Symbols.group, size: 20),
                      ),
                      title: Text(realm.name),
                      subtitle: Text(
                        realm.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Symbols.edit),
                                const Gap(16),
                                Text('edit').tr(),
                              ],
                            ),
                            onTap: () {
                              GoRouter.of(context).pushNamed(
                                'realmManage',
                                queryParameters: {'editing': realm.alias},
                              ).then((value) {
                                if (value != null) {
                                  _fetchRealms();
                                }
                              });
                            },
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Symbols.delete),
                                const Gap(16),
                                Text('delete').tr(),
                              ],
                            ),
                            onTap: () {
                              _deleteRealm(realm);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        GoRouter.of(context).pushNamed(
                          'realmDetail',
                          pathParameters: {'alias': realm.alias},
                        );
                      },
                    );
                  }

                  return Container(
                    constraints: BoxConstraints(maxWidth: 640),
                    child: Card(
                      margin: const EdgeInsets.all(12),
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 7,
                              child: Stack(
                                clipBehavior: Clip.none,
                                fit: StackFit.expand,
                                children: [
                                  Container(
                                    color: Theme.of(context).colorScheme.surfaceContainer,
                                    child: (realm.banner?.isEmpty ?? true)
                                        ? const SizedBox.shrink()
                                        : AutoResizeUniversalImage(
                                            sn.getAttachmentUrl(realm.banner!),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                  Positioned(
                                    bottom: -30,
                                    left: 18,
                                    child: AccountImage(
                                      content: realm.avatar,
                                      radius: 24,
                                      fallbackWidget: const Icon(Symbols.group, size: 24),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(20 + 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(realm.name).textStyle(Theme.of(context).textTheme.titleMedium!),
                                Text(realm.description).textStyle(Theme.of(context).textTheme.bodySmall!),
                              ],
                            ).padding(horizontal: 24, bottom: 14),
                          ],
                        ),
                        onTap: () {
                          GoRouter.of(context).pushNamed(
                            'realmDetail',
                            pathParameters: {'alias': realm.alias},
                          );
                        },
                      ),
                    ),
                  ).center();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
