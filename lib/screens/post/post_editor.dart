import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/controllers/post_write_controller.dart';
import 'package:surface/providers/config.dart';
import 'package:surface/providers/sn_network.dart';
import 'package:surface/types/post.dart';
import 'package:surface/widgets/account/account_image.dart';
import 'package:surface/widgets/loading_indicator.dart';
import 'package:surface/widgets/post/post_item.dart';
import 'package:surface/widgets/post/post_media_pending_list.dart';
import 'package:surface/widgets/post/post_meta_editor.dart';
import 'package:surface/widgets/dialog.dart';
import 'package:provider/provider.dart';

class PostEditorExtraProps {
  final String? text;
  final String? title;
  final String? description;
  final List<PostWriteMedia>? attachments;

  const PostEditorExtraProps({
    this.text,
    this.title,
    this.description,
    this.attachments,
  });
}

class PostEditorScreen extends StatefulWidget {
  final String mode;
  final int? postEditId;
  final int? postReplyId;
  final int? postRepostId;
  final PostEditorExtraProps? extraProps;

  const PostEditorScreen({
    super.key,
    required this.mode,
    required this.postEditId,
    required this.postReplyId,
    required this.postRepostId,
    this.extraProps,
  });

  @override
  State<PostEditorScreen> createState() => _PostEditorScreenState();
}

class _PostEditorScreenState extends State<PostEditorScreen> {
  final PostWriteController _writeController = PostWriteController();

  bool _isFetching = false;

  bool get _isLoading => _isFetching || _writeController.isLoading;

  List<SnPublisher>? _publishers;

  Future<void> _fetchPublishers() async {
    setState(() => _isFetching = true);

    try {
      final sn = context.read<SnNetworkProvider>();
      final config = context.read<ConfigProvider>();
      final resp = await sn.client.get('/cgi/co/publishers/me');
      _publishers = List<SnPublisher>.from(
        resp.data?.map((e) => SnPublisher.fromJson(e)) ?? [],
      );
      final beforeId = config.prefs.getInt('int_last_publisher_id');
      _writeController
          .setPublisher(_publishers?.where((ele) => ele.id == beforeId).firstOrNull ?? _publishers?.firstOrNull);
    } catch (err) {
      if (!mounted) return;
      context.showErrorDialog(err);
    } finally {
      setState(() => _isFetching = false);
    }
  }

  void _updateMeta() {
    showModalBottomSheet(
      context: context,
      builder: (context) => PostMetaEditor(controller: _writeController),
      useRootNavigator: true,
    );
  }

  @override
  void dispose() {
    _writeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (!PostWriteController.kTitleMap.keys.contains(widget.mode)) {
      context.showErrorDialog('Unknown post type');
      Navigator.pop(context);
    } else {
      _writeController.setMode(widget.mode);
    }
    _fetchPublishers();
    _writeController.fetchRelatedPost(
      context,
      editing: widget.postEditId,
      replying: widget.postReplyId,
      reposting: widget.postRepostId,
    );
    if (widget.extraProps != null) {
      _writeController.contentController.text = widget.extraProps!.text ?? '';
      _writeController.titleController.text = widget.extraProps!.title ?? '';
      _writeController.descriptionController.text = widget.extraProps!.description ?? '';
      _writeController.addAttachments(widget.extraProps!.attachments ?? []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _writeController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                  text: _writeController.title.isNotEmpty ? _writeController.title : 'untitled'.tr(),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).appBarTheme.foregroundColor!,
                      ),
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: PostWriteController.kTitleMap[widget.mode]!.tr(),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Theme.of(context).appBarTheme.foregroundColor!,
                      ),
                ),
              ]),
            ),
            actions: [
              IconButton(
                icon: const Icon(Symbols.tune),
                onPressed: _writeController.isBusy ? null : _updateMeta,
              ),
              const Gap(8),
            ],
          ),
          body: Column(
            children: [
              DropdownButtonHideUnderline(
                child: DropdownButton2<SnPublisher>(
                  isExpanded: true,
                  hint: Text(
                    'fieldPostPublisher',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).hintColor,
                    ),
                  ).tr(),
                  items: <DropdownMenuItem<SnPublisher>>[
                    ...(_publishers?.map(
                          (item) => DropdownMenuItem<SnPublisher>(
                            enabled: _writeController.editingPost == null,
                            value: item,
                            child: Row(
                              children: [
                                AccountImage(content: item.avatar, radius: 16),
                                const Gap(8),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.nick).textStyle(Theme.of(context).textTheme.bodyMedium!),
                                      Text('@${item.name}')
                                          .textStyle(Theme.of(context).textTheme.bodySmall!)
                                          .fontSize(12),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ) ??
                        []),
                    DropdownMenuItem<SnPublisher>(
                      value: null,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.transparent,
                            foregroundColor: Theme.of(context).colorScheme.onSurface,
                            child: const Icon(Symbols.add),
                          ),
                          const Gap(8),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('publishersNew').tr().textStyle(Theme.of(context).textTheme.bodyMedium!),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  value: _writeController.publisher,
                  onChanged: (SnPublisher? value) {
                    if (value == null) {
                      GoRouter.of(context).pushNamed('accountPublisherNew').then((value) {
                        if (value == true) {
                          _publishers = null;
                          _fetchPublishers();
                        }
                      });
                    } else {
                      _writeController.setPublisher(value);
                      final config = context.read<ConfigProvider>();
                      config.prefs.setInt('int_last_publisher_id', value.id);
                    }
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.only(right: 16),
                    height: 48,
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 48,
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: [
                      // Replying Notice
                      if (_writeController.replyingPost != null)
                        Column(
                          children: [
                            ExpansionTile(
                              minTileHeight: 48,
                              leading: const Icon(Symbols.reply).padding(left: 4),
                              title: Text('postReplyingNotice')
                                  .fontSize(15)
                                  .tr(args: ['@${_writeController.replyingPost!.publisher.name}']),
                              children: <Widget>[PostItem(data: _writeController.replyingPost!)],
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      // Reposting Notice
                      if (_writeController.repostingPost != null)
                        Column(
                          children: [
                            ExpansionTile(
                              minTileHeight: 48,
                              leading: const Icon(Symbols.forward).padding(left: 4),
                              title: Text('postRepostingNotice')
                                  .fontSize(15)
                                  .tr(args: ['@${_writeController.repostingPost!.publisher.name}']),
                              children: <Widget>[
                                PostItem(
                                  data: _writeController.repostingPost!,
                                )
                              ],
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      // Editing Notice
                      if (_writeController.editingPost != null)
                        Column(
                          children: [
                            ExpansionTile(
                              minTileHeight: 48,
                              leading: const Icon(Symbols.edit_note).padding(left: 4),
                              title: Text('postEditingNotice')
                                  .fontSize(15)
                                  .tr(args: ['@${_writeController.editingPost!.publisher.name}']),
                              children: <Widget>[PostItem(data: _writeController.editingPost!)],
                            ),
                            const Divider(height: 1),
                          ],
                        ),
                      // Content Input Area
                      TextField(
                        controller: _writeController.contentController,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'fieldPostContent'.tr(),
                          hintStyle: TextStyle(fontSize: 14),
                          isCollapsed: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          border: InputBorder.none,
                        ),
                        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
                      ),
                    ]
                        .expandIndexed(
                          (idx, ele) => [
                            if (idx != 0 || _writeController.isRelatedNull) const Gap(8),
                            ele,
                          ],
                        )
                        .toList(),
                  ),
                ),
              ),
              if (_writeController.attachments.isNotEmpty || _writeController.thumbnail != null)
                PostMediaPendingList(
                  thumbnail: _writeController.thumbnail,
                  attachments: _writeController.attachments,
                  isBusy: _writeController.isBusy,
                  onUpload: (int idx) async {
                    await _writeController.uploadSingleAttachment(context, idx);
                  },
                  onPostSetThumbnail: (int? idx) {
                    _writeController.setThumbnail(idx);
                  },
                  onInsertLink: (int idx) async {
                    _writeController.contentController.text +=
                        '\n![](solink://attachments/${_writeController.attachments[idx].attachment!.rid})';
                  },
                  onUpdate: (int idx, PostWriteMedia updatedMedia) async {
                    _writeController.setIsBusy(true);
                    try {
                      _writeController.setAttachmentAt(idx, updatedMedia);
                    } finally {
                      _writeController.setIsBusy(false);
                    }
                  },
                  onRemove: (int idx) async {
                    _writeController.setIsBusy(true);
                    try {
                      _writeController.removeAttachmentAt(idx);
                    } finally {
                      _writeController.setIsBusy(false);
                    }
                  },
                  onUpdateBusy: (state) => _writeController.setIsBusy(state),
                ).padding(bottom: 8),
              Material(
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: _writeController.temporaryRestored
                          ? Container(
                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 28, right: 22),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                    width: 1 / MediaQuery.of(context).devicePixelRatio,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.restore, size: 20),
                                  const Gap(8),
                                  Expanded(child: Text('postLocalDraftRestored').tr()),
                                  InkWell(
                                    child: Text('dialogDismiss').tr(),
                                    onTap: () {
                                      _writeController.reset();
                                    },
                                  ),
                                ],
                              ))
                          : const SizedBox.shrink(),
                    )
                        .height(_writeController.temporaryRestored ? 32 : 0, animate: true)
                        .animate(const Duration(milliseconds: 300), Curves.fastLinearToSlowEaseIn),
                    LoadingIndicator(isActive: _isLoading),
                    if (_writeController.isBusy && _writeController.progress != null)
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: _writeController.progress),
                        duration: Duration(milliseconds: 300),
                        builder: (context, value, _) => LinearProgressIndicator(value: value, minHeight: 2),
                      )
                    else if (_writeController.isBusy)
                      const LinearProgressIndicator(value: null, minHeight: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ScrollConfiguration(
                            behavior: _PostEditorActionScrollBehavior(),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Row(
                                children: [
                                  AddPostMediaButton(
                                    onAdd: (items) {
                                      setState(() {
                                        _writeController.addAttachments(items);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: (_writeController.isBusy || _writeController.publisher == null)
                              ? null
                              : () {
                                  _writeController.sendPost(context).then((_) {
                                    if (!context.mounted) return;
                                    Navigator.pop(context, true);
                                  });
                                },
                          icon: const Icon(Symbols.send),
                          label: Text('postPublish').tr(),
                        ),
                      ],
                    ).padding(horizontal: 16),
                  ],
                ).padding(
                  bottom: MediaQuery.of(context).padding.bottom + 8,
                  top: 4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PostEditorActionScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
