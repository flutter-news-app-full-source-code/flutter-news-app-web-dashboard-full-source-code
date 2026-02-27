import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/app_localizations.dart';
import 'package:flutter_news_app_web_dashboard_full_source_code/l10n/l10n.dart';
import 'package:core_ui/core_ui.dart';

/// A widget for selecting and previewing an image for upload.
class ImageUploadField extends StatefulWidget {
  /// {@macro image_upload_field}
  const ImageUploadField({
    required this.onChanged,
    this.initialImageUrl,
    this.isProcessing = false,
    super.key,
  });

  /// Callback function that is called when an image is selected or removed.
  final void Function(Uint8List? bytes, String? fileName) onChanged;

  /// The URL of an existing image to display initially.
  final String? initialImageUrl;

  /// Whether the image is currently being processed by the backend.
  final bool isProcessing;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  Uint8List? _imageBytes;
  String? _fileName;

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
            content: Text(
              AppLocalizationsX(context).l10n.filePickingErrorMessage,
            ),
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

    // Priority 1: A new image just picked in this session.
    if (_imageBytes != null) {
      return _buildImagePreview(context, theme, _imageBytes);
    }

    // Priority 2: Backend is processing the image.
    if (widget.isProcessing) {
      return _buildProcessingState(context, theme);
    }

    // Priority 3: An existing image URL from the database.
    if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      return _buildUrlImagePreview(context, theme, widget.initialImageUrl!);
    }

    // Fallback: Show the picker.
    return _buildImagePicker(l10n, theme);
  }

  Widget _buildImagePicker(AppLocalizations l10n, ThemeData theme) {
    return InkWell(
      onTap: _pickImage,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(AppSpacing.md),
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          strokeWidth: 1,
          dashPattern: const [6, 6],
        ),
        child: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  size: 48,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(l10n.clickToUploadImage),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(
    BuildContext context,
    ThemeData theme,
    Uint8List? displayBytes,
  ) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (displayBytes != null)
            Image.memory(displayBytes, fit: BoxFit.contain),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: IconButton.filled(
              onPressed: _removeImage,
              icon: const Icon(Icons.close),
              tooltip: AppLocalizationsX(context).l10n.removeImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrlImagePreview(
    BuildContext context,
    ThemeData theme,
    String imageUrl,
  ) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
          ),
          Positioned(
            top: AppSpacing.sm,
            right: AppSpacing.sm,
            child: IconButton.filled(
              onPressed: _removeImage,
              icon: const Icon(Icons.close),
              tooltip: AppLocalizationsX(context).l10n.removeImage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingState(BuildContext context, ThemeData theme) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppLocalizationsX(context).l10n.processingImage,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text(
              AppLocalizationsX(context).l10n.processingImageDescription,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
