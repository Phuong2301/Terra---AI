// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 🌎 Project imports:
import 'package:app_mobile/domain/core/theme/theme.dart';
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';

class AvatarsView extends StatelessWidget {
  const AvatarsView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    final List<double> _avatarSizes = [120, 96, 72, 44, 32, 24];

    return Scaffold(
      body: SingleChildScrollView(
        padding: _sizeInfo.padding / 2.5,
        child: ResponsiveGridRow(
          children: [
            // Basic
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              sm: 12,
              xs: 12,
              child: Padding(
                padding: _sizeInfo.padding / 2.5,
                child: ShadowContainer(
                  // headerText: 'Basic',
                  headerText: lang.basic,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: _avatarSizes
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: AvatarWidget(
                              size: Size.square(e),
                              avatarShape: AvatarShape.circle,
                              imagePath: _imagePaths.firstOrNull,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Shapes Styles
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              sm: 12,
              xs: 12,
              child: Padding(
                padding: _sizeInfo.padding / 2.5,
                child: ShadowContainer(
                  //headerText: 'Shapes Styles',
                  headerText: lang.shapesStyles,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AvatarShape.circle,
                      AvatarShape.roundedRectangle,
                      AvatarShape.roundedRectangleTilted,
                      AvatarShape.circle,
                      AvatarShape.roundedRectangle,
                      AvatarShape.circle,
                    ]
                        .asMap()
                        .entries
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: AvatarWidget(
                              size: Size.square(_avatarSizes[e.key]),
                              avatarShape: e.value,
                              imagePath: _imagePaths.firstOrNull,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Indicators
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              sm: 12,
              xs: 12,
              child: Padding(
                padding: _sizeInfo.padding / 2.5,
                child: ShadowContainer(
                  //headerText: 'Indicators',
                  headerText: lang.indicators,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: _avatarSizes
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: AvatarWidget(
                              size: Size.square(e),
                              avatarShape: AvatarShape.circle,
                              imagePath: _imagePaths.firstOrNull,
                              isActive: true,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Avatar With Content
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              sm: 12,
              xs: 12,
              child: Padding(
                padding: _sizeInfo.padding / 2.5,
                child: ShadowContainer(
                  //headerText: 'Avatar With Content',
                  headerText: lang.avatarWithContent,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: {
                      "X L": const Color(0xff7500FD),
                      "L G": const Color(0xff00B243),
                      "M D": const Color(0xff1D4ED8),
                      "S M": const Color(0xffE40F0F),
                      "X S": const Color(0xffFD7F0B),
                      "X XS": const Color(0xff7500FD),
                    }
                        .entries
                        .toList()
                        .asMap()
                        .entries
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.all(16),
                            child: AvatarWidget(
                              size: Size.square(_avatarSizes[e.key]),
                              avatarShape: AvatarShape.circle,
                              fullName: e.value.key,
                              initialsOnly: true,
                              backgroundColor: e.value.value.withOpacity(0.20),
                              foregroundColor: e.value.value,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            // Avatar Group
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              sm: 12,
              xs: 12,
              child: Padding(
                padding: _sizeInfo.padding / 2.5,
                child: ShadowContainer(
                  // headerText: 'Avatar Group',
                  headerText: lang.avatarGroup,
                  child: Container(
                    height: 64,
                    width: double.maxFinite,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: List.generate(
                        6,
                        (index) {
                          final _image = _imagePaths[index];
                          final _initialOnly = index == 5;
                          return Positioned(
                            left: (index * 50).toDouble(),
                            child: AvatarWidget(
                              size: const Size.square(64),
                              avatarShape: AvatarShape.circle,
                              imagePath: _initialOnly ? null : _image,
                              fullName: _initialOnly ? _image : null,
                              initialsOnly: _initialOnly,
                              backgroundColor: _initialOnly
                                  ? Theme.of(context).primaryColor
                                  : null,
                              foregroundColor: _initialOnly
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Type
            ResponsiveGridCol(
              lg: 6,
              md: 12,
              sm: 12,
              xs: 12,
              child: Padding(
                padding: _sizeInfo.padding / 2.5,
                child: ShadowContainer(
                  // headerText: 'Type',
                  headerText: lang.type,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: AcnooAppColors.kSuccess20Op,
                        foregroundColor: AcnooAppColors.kSuccess,
                        radius: 32,
                        child: const Icon(
                          IconlyLight.profile,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      AvatarWidget(
                        size: const Size.square(64),
                        imagePath: _imagePaths.firstOrNull,
                      ),
                      const SizedBox(width: 16),
                      AvatarWidget(
                        size: const Size.square(64),
                        //fullName: 'S M',
                        fullName: lang.sM,
                        initialsOnly: true,
                        backgroundColor: AcnooAppColors.kWarning20Op,
                        foregroundColor: AcnooAppColors.kWarning,
                      )
                    ],
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

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

final List<String?> _imagePaths = [
  'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_01.png',
  'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_02.jpeg',
  'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_03.png',
  'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_04.png',
  'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_05.png',
  'S I'
];
