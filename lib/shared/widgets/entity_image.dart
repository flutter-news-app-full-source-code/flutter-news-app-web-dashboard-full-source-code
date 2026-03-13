import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:verity_dashboard/shared/constants/app_constants.dart';

/// {@template entity_image}
/// A reusable widget for displaying entity images (e.g., headline thumbnails,
/// source logos) with proper error handling and a consistent placeholder.
/// {@endtemplate}
class EntityImage extends StatelessWidget {
  /// {@macro entity_image}
  const EntityImage({
    required this.imageUrl,
    required this.placeholderIcon,
    this.size = AppConstants.kTableRowImageSize,
    super.key,
  });

  /// The URL of the image to display. If null, the placeholder is shown.
  final String? imageUrl;

  /// The icon to display as a placeholder if the image is null or fails to load.
  final IconData placeholderIcon;

  /// The size (width and height) of the image.
  final double size;

  @override
  Widget build(BuildContext context) {
    final effectiveImageUrl = imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xs),
      child: (effectiveImageUrl != null)
          ? Image.network(
              effectiveImageUrl,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // On error (CORS, 404, etc.), display the placeholder.
                return _Placeholder(icon: placeholderIcon, size: size);
              },
            )
          : _Placeholder(icon: placeholderIcon, size: size),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: Icon(icon, size: size / 2),
    );
  }
}
