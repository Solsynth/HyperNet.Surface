import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:livekit_client/livekit_client.dart' as livekit;
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/chat_call.dart';
import 'package:surface/widgets/chat/call/call_controls.dart';
import 'package:surface/widgets/chat/call/call_participant.dart';

class CallRoomScreen extends StatefulWidget {
  final String scope;
  final String alias;
  const CallRoomScreen({super.key, required this.scope, required this.alias});

  @override
  State<CallRoomScreen> createState() => _CallRoomScreenState();
}

class _CallRoomScreenState extends State<CallRoomScreen> {
  int _layoutMode = 0;

  void _switchLayout() {
    if (_layoutMode < 1) {
      setState(() => _layoutMode++);
    } else {
      setState(() => _layoutMode = 0);
    }
  }

  Widget _buildListLayout() {
    final call = context.read<ChatCallProvider>();
    return Stack(
      children: [
        Container(
          color:
              Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.75),
          child: call.focusTrack != null
              ? InteractiveParticipantWidget(
                  isFixedAvatar: false,
                  participant: call.focusTrack!,
                  onTap: () {},
                )
              : const SizedBox.shrink(),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: SizedBox(
            height: 128,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: math.max(0, call.participantTracks.length),
              itemBuilder: (BuildContext context, int index) {
                final track = call.participantTracks[index];
                if (track.participant.sid == call.focusTrack?.participant.sid) {
                  return Container();
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 8, left: 8),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: InteractiveParticipantWidget(
                      isFixedAvatar: true,
                      width: 120,
                      height: 120,
                      color: Theme.of(context).cardColor,
                      participant: track,
                      onTap: () {
                        if (track.participant.sid !=
                            call.focusTrack?.participant.sid) {
                          call.setFocusTrack(track);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridLayout() {
    final call = context.read<ChatCallProvider>();

    return LayoutBuilder(builder: (context, constraints) {
      double screenWidth = constraints.maxWidth;
      double screenHeight = constraints.maxHeight;

      int columns = (math.sqrt(call.participantTracks.length)).ceil();
      int rows = (call.participantTracks.length / columns).ceil();

      double tileWidth = screenWidth / columns;
      double tileHeight = screenHeight / rows;

      return StyledWidget(GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: tileWidth / tileHeight,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: math.max(0, call.participantTracks.length),
        itemBuilder: (BuildContext context, int index) {
          final track = call.participantTracks[index];
          return Card(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              child: InteractiveParticipantWidget(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHigh
                    .withOpacity(0.75),
                participant: track,
                onTap: () {
                  if (track.participant.sid !=
                      call.focusTrack?.participant.sid) {
                    call.setFocusTrack(track);
                  }
                },
              ),
            ),
          );
        },
      )).padding(all: 8);
    });
  }

  @override
  void initState() {
    super.initState();
    final call = context.read<ChatCallProvider>();

    Future.delayed(Duration.zero, () {
      call
        ..setupRoom()
        ..enableDurationUpdater();
    });
  }

  @override
  Widget build(BuildContext context) {
    final call = context.read<ChatCallProvider>();

    return ListenableBuilder(
        listenable: call,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'call'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Colors.white),
                  ),
                  const TextSpan(text: '\n'),
                  TextSpan(
                    text: call.lastDuration.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                ]),
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 64,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Builder(builder: (context) {
                            final call = context.read<ChatCallProvider>();
                            final connectionQuality =
                                call.room.localParticipant?.connectionQuality ??
                                    livekit.ConnectionQuality.unknown;
                            return Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        call.channel?.name ?? 'unknown'.tr(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(6),
                                      Text(call.lastDuration.toString())
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        {
                                          livekit.ConnectionState.disconnected:
                                              'callStatusDisconnected'.tr(),
                                          livekit.ConnectionState.connected:
                                              'callStatusConnected'.tr(),
                                          livekit.ConnectionState.connecting:
                                              'callStatusConnecting'.tr(),
                                          livekit.ConnectionState.reconnecting:
                                              'callStatusReconnecting'.tr(),
                                        }[call.room.connectionState]!,
                                      ),
                                      const Gap(6),
                                      if (connectionQuality !=
                                          livekit.ConnectionQuality.unknown)
                                        Icon(
                                          {
                                            livekit.ConnectionQuality.excellent:
                                                Icons.signal_cellular_alt,
                                            livekit.ConnectionQuality.good:
                                                Icons.signal_cellular_alt_2_bar,
                                            livekit.ConnectionQuality.poor:
                                                Icons.signal_cellular_alt_1_bar,
                                          }[connectionQuality],
                                          color: {
                                            livekit.ConnectionQuality.excellent:
                                                Colors.green,
                                            livekit.ConnectionQuality.good:
                                                Colors.orange,
                                            livekit.ConnectionQuality.poor:
                                                Colors.red,
                                          }[connectionQuality],
                                          size: 16,
                                        )
                                      else
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ).padding(all: 3),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          Row(
                            children: [
                              IconButton(
                                icon: _layoutMode == 0
                                    ? const Icon(Icons.view_list)
                                    : const Icon(Icons.grid_view),
                                onPressed: () {
                                  _switchLayout();
                                },
                              ),
                            ],
                          ),
                        ],
                      ).padding(left: 20, right: 16),
                    ),
                    Expanded(
                      child: Material(
                        color:
                            Theme.of(context).colorScheme.surfaceContainerLow,
                        child: Builder(
                          builder: (context) {
                            switch (_layoutMode) {
                              case 1:
                                return _buildGridLayout();
                              default:
                                return _buildListLayout();
                            }
                          },
                        ),
                      ),
                    ),
                    if (call.room.localParticipant != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ControlsWidget(
                          call.room,
                          call.room.localParticipant!,
                        ),
                      ),
                  ],
                ),
                onTap: () {},
              ),
            ),
          );
        });
  }

  @override
  void deactivate() {
    final call = context.read<ChatCallProvider>();
    call.disableDurationUpdater();
    super.deactivate();
  }

  @override
  void activate() {
    final call = context.read<ChatCallProvider>();
    call.enableDurationUpdater();
    super.activate();
  }
}