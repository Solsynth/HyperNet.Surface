import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:relative_time/relative_time.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/experience.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/screens/account/profile_page.dart';
import 'package:surface/types/account.dart';
import 'package:surface/widgets/account/account_image.dart';
import 'package:surface/widgets/universal_image.dart';

class AccountPopoverCard extends StatelessWidget {
  final SnAccount data;

  const AccountPopoverCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final sn = context.read<SnNetworkProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (data.banner.isNotEmpty)
          Container(
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: AspectRatio(
              aspectRatio: 16 / 7,
              child: AutoResizeUniversalImage(
                sn.getAttachmentUrl(data.banner),
                fit: BoxFit.cover,
              ),
            ),
          ),
        // Top padding
        Gap(16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AccountImage(
              content: data.avatar,
              radius: 20,
            ),
            Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(data.nick).bold(),
                  Text('@${data.name}').fontSize(13).opacity(0.75),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                GoRouter.of(context).pushNamed(
                  'accountProfilePage',
                  pathParameters: {'name': data.name},
                );
              },
              icon: const Icon(Symbols.chevron_right),
              padding: EdgeInsets.zero,
              visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            ),
            const Gap(8)
          ],
        ).padding(horizontal: 16),
        const Gap(16),
        Wrap(
          children: data.badges
              .map(
                (ele) => Tooltip(
              richMessage: TextSpan(
                children: [
                  TextSpan(text: kBadgesMeta[ele.type]?.$1.tr() ?? 'unknown'.tr()),
                  if (ele.metadata['title'] != null)
                    TextSpan(
                      text: '\n${ele.metadata['title']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  TextSpan(text: '\n'),
                  TextSpan(
                    text: DateFormat.yMEd().format(ele.createdAt),
                  ),
                ],
              ),
              child: Icon(
                kBadgesMeta[ele.type]?.$2 ?? Symbols.question_mark,
                color: kBadgesMeta[ele.type]?.$3,
                fill: 1,
              ),
            ),
          )
              .toList(),
        ).padding(horizontal: 24),
        const Gap(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Symbols.star),
            const Gap(8),
            Text('Lv${getLevelFromExp(data.profile?.experience ?? 0)}'),
            const Gap(8),
            Text(calcLevelUpProgressLevel(data.profile?.experience ?? 0)).fontSize(11).opacity(0.5),
            const Gap(8),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 160),
              child: LinearProgressIndicator(
                value: calcLevelUpProgress(data.profile?.experience ?? 0),
                borderRadius: BorderRadius.circular(8),
                backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
              ).alignment(Alignment.centerLeft),
            ),
          ],
        ).padding(horizontal: 24),
        FutureBuilder(
          future: sn.client.get('/cgi/id/users/${data.name}/status'),
          builder: (context, snapshot) {
            final SnAccountStatusInfo? status =
                snapshot.hasData ? SnAccountStatusInfo.fromJson(snapshot.data!.data) : null;
            return Row(
                children: [
                  Icon(
                    Symbols.circle,
                    fill: 1,
                    size: 16,
                    color: (status?.isOnline ?? false) ? Colors.green : Colors.grey,
                  ).padding(all: 4),
                  const Gap(8),
                  Text(
                    status != null
                        ? status.isOnline
                            ? 'accountStatusOnline'.tr()
                            : 'accountStatusOffline'.tr()
                        : 'loading'.tr(),
                  ),
                  if (status != null && !status.isOnline && status.lastSeenAt != null)
                    Text(
                      'accountStatusLastSeen'.tr(args: [
                        status.lastSeenAt != null
                            ? RelativeTime(context).format(
                                status.lastSeenAt!.toLocal(),
                              )
                            : 'unknown',
                      ]),
                    ).padding(left: 6).opacity(0.75),
                ],
              ).padding(horizontal: 24);
          },
        ),
        // Bottom padding
        const Gap(16),
      ],
    );
  }
}
