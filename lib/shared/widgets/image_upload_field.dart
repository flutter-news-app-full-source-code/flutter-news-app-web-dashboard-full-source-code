import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:ui_kit/ui_kit.dart';

/// A widget for selecting and previewing an image for upload.
class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    required this.onChanged,
    this.initialImageBytes,
    super.key,
  });

  /// Callback function that is called when an image is selected or removed.
  final void Function(Uint8List? bytes, String? fileName) onChanged;

  /// The initial image bytes to display, for edit forms.
  final Uint8List? initialImageBytes;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  Uint8List? _imageBytes;
  String? _fileName;

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.initialImageBytes;
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _imageBytes = result.files.single.bytes;
          _fileName = result.files.single.name;
        });
        widget.onChanged(_imageBytes, _fileName);
      }
    } catch (e) {
      // Handle potential file picker errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.filePickingErrorMessage),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _imageBytes = null;
      _fileName = null;
    });
    widget.onChanged(null, null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizationsX(context).l10n;
    final theme = Theme.of(context);

    return _imageBytes == null
        ? _buildImagePicker(l10n, theme)
        : _buildImagePreview(theme);
  }

  Widget _buildImagePicker(AppLocalizations l10n, ThemeData theme) {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          strokeWidth: 1,
          dashPattern: const [6, 6],
        ),
        child: const SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: Colors.grey,
                ),
                SizedBox(height: AppSpacing.md),
                Text(l10n.clickToUploadImage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(ThemeData theme) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.memory(_imageBytes!, fit: BoxFit.contain),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: IconButton.filled(
              onPressed: _removeImage,
              icon: const Icon(Icons.close),
              tooltip: context.l10n.removeImage,
            ),
          ),
        ],
      ),
    );
  }
}
