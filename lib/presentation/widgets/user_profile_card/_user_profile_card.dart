// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';

// 🌎 Project imports:
import 'package:app_mobile/generated/l10n.dart' as l;
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import '../../../domain/helpers/fuctions/helper_functions.dart';
import '../../../domain/core/theme/theme.dart';

class UserProfileCardWidget extends StatefulWidget {
  const UserProfileCardWidget({
    super.key,
    this.imagePath,
    required this.name,
    this.subtitle,
    this.nameTextStyle,
    this.subtitleTextStyle,
    this.actionButtonStyle,
    this.onpressed,
    this.buttonColor,
    this.buttonTextColor,
  });
  final String? imagePath;

  final String name;
  final String? subtitle;
  final TextStyle? nameTextStyle;
  final TextStyle? subtitleTextStyle;
  final VoidCallback? onpressed;
  final ButtonStyle? actionButtonStyle;
  final Color? buttonColor;
  final Color? buttonTextColor;

  @override
  State<UserProfileCardWidget> createState() => _UserProfileCardWidgetState();
}

class _UserProfileCardWidgetState extends State<UserProfileCardWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    final titleSize = responsiveValue<double>(
      context,
      xs: 18,
      md: 20,
      lg: 20,
    );
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      child: Container(
        // constraints: const BoxConstraints.tightForFinite(
        //     // width: 340,
        //     ),
        padding: EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: _theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              height: 225,
              width: 225,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: Alignment.topCenter, // The center of the gradient is on the top center
                  radius: 0.8, // Adjust the radius to cover half of the circle
                  colors: [
                    const Color(0xffFF1CF7),
                    const Color(0xff00F0FF).withOpacity(0), // Fade out to transparent
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Container(
                  height: 220,
                  width: 220,
                  decoration: BoxDecoration(
                    color: _theme.colorScheme.surface,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: getImageType(widget.imagePath, fit: BoxFit.cover),
                ),
              ),
            ),

            const SizedBox(height: 16),
            Text(
              widget.name,
              maxLines: 1,
              style: widget.nameTextStyle ?? _theme.textTheme.bodyLarge?.copyWith(fontSize: titleSize, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
            ),

            Text(widget.subtitle ?? '', maxLines: 1, style: widget.subtitleTextStyle ?? _theme.textTheme.bodyLarge, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 16),
            SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: widget.onpressed,
                iconAlignment: IconAlignment.end,
                icon: Icon(
                  IconlyLight.chat,
                  color: isHovering ? AcnooAppColors.kWhiteColor : AcnooAppColors.kPrimary600,
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: isHovering ? AcnooAppColors.kPrimary600 : AcnooAppColors.kPrimary100,
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
                    elevation: isHovering ? 1 : 0),
                label: Text(
                  lang.startChat,
                 // 'Start Chat',
                  style: _theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHovering ? AcnooAppColors.kWhiteColor : AcnooAppColors.kPrimary600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
