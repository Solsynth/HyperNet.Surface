import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown/markdown.dart' as markdown;
import 'package:provider/provider.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/providers/sn_sticker.dart';
import 'package:surface/types/attachment.dart';
import 'package:surface/widgets/attachment/attachment_item.dart';
import 'package:surface/widgets/universal_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:uuid/uuid.dart';

import 'attachment/attachment_zoom.dart';

class MarkdownTextContent extends StatelessWidget {
  final String content;
  final bool isAutoWarp;
  final bool isEnlargeSticker;
  final TextScaler? textScaler;
  final Color? textColor;
  final List<SnAttachment?>? attachments;

  const MarkdownTextContent({
    super.key,
    required this.content,
    this.isAutoWarp = false,
    this.isEnlargeSticker = false,
    this.textScaler,
    this.textColor,
    this.attachments,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      data: content,
      padding: EdgeInsets.zero,
      styleSheet: MarkdownStyleSheet.fromTheme(
        Theme.of(context),
      ).copyWith(
        textScaler: textScaler,
        p: textColor != null ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor) : null,
        blockquote: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        blockquoteDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1.0,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        codeblockDecoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 0.3,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        ),
        code: GoogleFonts.robotoMono(height: 1),
      ),
      builders: {},
      softLineBreak: true,
      extensionSet: markdown.ExtensionSet(
        <markdown.BlockSyntax>[
          markdown.CodeBlockSyntax(),
          ...markdown.ExtensionSet.gitHubFlavored.blockSyntaxes,
        ],
        <markdown.InlineSyntax>[
          if (isAutoWarp) markdown.LineBreakSyntax(),
          _UserNameCardInlineSyntax(),
          _CustomEmoteInlineSyntax(context),
          markdown.AutolinkSyntax(),
          markdown.AutolinkExtensionSyntax(),
          markdown.CodeSyntax(),
          ...markdown.ExtensionSet.gitHubFlavored.inlineSyntaxes
        ],
      ),
      onTapLink: (text, href, title) async {
        if (href == null) return;
        if (href.startsWith('solink://')) {
          final uri = href.replaceFirst('solink://', '');
          final segments = uri.split('/');
          switch (segments[0]) {
            default:
              GoRouter.of(context).push('/$uri');
          }
          return;
        }

        await launchUrlString(
          href,
          mode: LaunchMode.externalApplication,
        );
      },
      imageBuilder: (uri, title, alt) {
        var url = uri.toString();
        double? width, height;
        BoxFit? fit;
        if (url.startsWith('solink://')) {
          final segments = url.replaceFirst('solink://', '').split('/');
          switch (segments[0]) {
            case 'stickers':
              final alias = segments[1];
              final st = context.read<SnStickerProvider>();
              final sn = context.read<SnNetworkProvider>();
              final double size = isEnlargeSticker ? 128 : 32;
              return Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: FutureBuilder<SnSticker?>(
                    future: st.lookupSticker(alias),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GestureDetector(
                            child: UniversalImage(
                              sn.getAttachmentUrl(snapshot.data!.attachment.rid),
                              fit: BoxFit.contain,
                              width: size,
                              height: size,
                              cacheHeight: size,
                              cacheWidth: size,
                            ),
                            onTap: () {
                              if (snapshot.data == null) return;
                              context.pushTransparentRoute(
                                AttachmentZoomView(
                                  data: [snapshot.data!.attachment],
                                  initialIndex: 0,
                                  heroTags: [const Uuid().v4()],
                                ),
                                backgroundColor: Colors.black.withOpacity(0.7),
                                rootNavigator: true,
                              );
                            });
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              );
            case 'attachments':
              final attachment = attachments?.firstWhere(
                (ele) => ele?.rid == segments[1],
                orElse: () => null,
              );
              if (attachment != null) {
                const uuid = Uuid();
                final heroTag = uuid.v4();
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: AspectRatio(
                        aspectRatio: attachment.metadata['ratio'] ??
                            switch (attachment.mimetype.split('/').firstOrNull) {
                              'audio' => 16 / 9,
                              'video' => 16 / 9,
                              _ => 1,
                            }
                                .toDouble(),
                        child: AttachmentItem(
                          data: attachment,
                          heroTag: heroTag,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    context.pushTransparentRoute(
                      AttachmentZoomView(
                        data: [attachment],
                        initialIndex: 0,
                        heroTags: [heroTag],
                      ),
                      backgroundColor: Colors.black.withOpacity(0.7),
                      rootNavigator: true,
                    );
                  },
                );
              }
              break;
          }
          return const SizedBox.shrink();
        }
        return UniversalImage(
          url,
          width: width,
          height: height,
          fit: fit,
        );
      },
    );
  }
}

class _UserNameCardInlineSyntax extends markdown.InlineSyntax {
  _UserNameCardInlineSyntax() : super(r'@[a-zA-Z0-9_]+');

  @override
  bool onMatch(markdown.InlineParser parser, Match match) {
    final alias = match[0]!;
    final anchor = markdown.Element.text('a', alias)
      ..attributes['href'] = Uri.encodeFull(
        'solink://account/${alias.substring(1)}',
      );
    parser.addNode(anchor);

    return true;
  }
}

class _CustomEmoteInlineSyntax extends markdown.InlineSyntax {
  final BuildContext context;

  _CustomEmoteInlineSyntax(this.context) : super(r':([-\w]+):');

  @override
  bool onMatch(markdown.InlineParser parser, Match match) {
    final SnStickerProvider st = context.read<SnStickerProvider>();
    final alias = match[1]!.toUpperCase();
    if (st.hasNotSticker(alias)) {
      parser.advanceBy(1);
      return false;
    }

    final element = markdown.Element.empty('img');
    element.attributes['src'] = 'solink://stickers/$alias';
    parser.addNode(element);

    return true;
  }
}
