// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import '../../../presentation/widgets/widgets.dart';

Widget? getImageType(
  String? imagePath, {
  double? height = 40,
  double? width = 40,
  BoxFit fit = BoxFit.contain,
  Alignment alignment = Alignment.center,
  ColorFilter? colorFilter,
}) {
  if (imagePath == null || imagePath.isEmpty) return null;

  final _extension = imagePath.split('.').lastOrNull?.toLowerCase();
  if (_extension == null) return null;

  final isNetworkImage = imagePath.startsWith(RegExp(r'https?://'));
  assert(
    _extension == 'svg' || colorFilter == null,
    'ColorFilter can only be used with SVG images',
  );

  if (_extension == 'svg') {
    if (isNetworkImage) {
      return SvgPicture.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    } else {
      return SvgPicture.asset(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    }
  }

  if (isNetworkImage) {
    return Image.network(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  } else {
    return Image.asset(
      imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
}

class AnimageWidget extends StatelessWidget {
  const AnimageWidget({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.colorFilter,
  });

  final String? imagePath;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Alignment alignment;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    if (imagePath == null || (imagePath?.isEmpty == true)) {
      return ColoredBox(
        color: _theme.colorScheme.tertiaryContainer,
      );
    }

    final _imagePath = imagePath!;
    final _extension = _imagePath.split('.').last.toLowerCase();
    final _isNetworkImage = _imagePath.startsWith(RegExp(r'https?://'));
    assert(
      _extension == 'svg' || colorFilter == null,
      'ColorFilter can only be used with SVG images',
    );

    if (_extension == 'svg') {
      if (_isNetworkImage) {
        return SvgPicture.network(
          _imagePath,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        );
      } else {
        return SvgPicture.asset(
          _imagePath,
          height: height,
          width: width,
          fit: fit,
          alignment: alignment,
        );
      }
    }

    if (_isNetworkImage) {
      return Image.network(
        _imagePath,
        height: height,
        width: width,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (ctx, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingPlaceholder(context);
        },
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: _theme.colorScheme.errorContainer,
            child: SizedBox(
              height: height,
              width: width,
              child: const Icon(Icons.broken_image),
            ),
          );
        },
      );
    }

    return Image.asset(
      _imagePath,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment,
    );
  }
}

Widget _buildLoadingPlaceholder(BuildContext context) {
  final _theme = Theme.of(context);
  return ShimmerPlaceholder(
    decoration: BoxDecoration(
      color: _theme.colorScheme.surfaceContainer,
    ),
  );
}
