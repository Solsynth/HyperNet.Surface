import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:surface/providers/sn_attachment.dart';
import 'package:surface/widgets/dialog.dart';

class AttachmentInputDialog extends StatefulWidget {
  final String? title;

  const AttachmentInputDialog({super.key, required this.title});

  @override
  State<AttachmentInputDialog> createState() => _AttachmentInputDialogState();
}

class _AttachmentInputDialogState extends State<AttachmentInputDialog> {
  final _randomIdController = TextEditingController();

  XFile? _thumbnailFile;

  void _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result == null) return;
    setState(() => _thumbnailFile = result);
  }

  bool _isBusy = false;

  void _finishUp() async {
    if (_isBusy) return;
    setState(() => _isBusy = true);

    final attach = context.read<SnAttachmentProvider>();

    if (_randomIdController.text.isNotEmpty) {
      try {
        final attachment = await attach.getOne(_randomIdController.text);
        if (!mounted) return;
        Navigator.pop(context, attachment);
      } catch (err) {
        if (!mounted) return;
        context.showErrorDialog(err);
      }
    } else if (_thumbnailFile != null) {
      try {
        final attachment = await attach.directUploadOne(
          (await _thumbnailFile!.readAsBytes()).buffer.asUint8List(),
          _thumbnailFile!.path,
          'interactive',
          null,
        );
        if (!mounted) return;
        Navigator.pop(context, attachment);
      } catch (err) {
        if (!mounted) return;
        context.showErrorDialog(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title ?? 'attachmentInputDialog').tr(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('attachmentInputUseRandomId').tr().fontSize(14),
          const Gap(8),
          TextField(
            controller: _randomIdController,
            decoration: InputDecoration(
              labelText: 'fieldAttachmentRandomId'.tr(),
              border: const OutlineInputBorder(),
            ),
            onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          ),
          const Gap(24),
          Text('attachmentInputNew').tr().fontSize(14),
          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: const Icon(Symbols.add_photo_alternate),
              trailing: const Icon(Symbols.chevron_right),
              title: Text('addAttachmentFromAlbum').tr(),
              subtitle: _thumbnailFile == null ? Text('unset').tr() : Text('waitingForUpload').tr(),
              onTap: () {
                _pickImage();
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isBusy ? null : () {
            Navigator.pop(context);
          },
          child: Text('dialogDismiss').tr(),
        ),
        TextButton(
          onPressed: _isBusy ? null : () => _finishUp(),
          child: Text('dialogConfirm').tr(),
        ),
      ],
    );
  }
}