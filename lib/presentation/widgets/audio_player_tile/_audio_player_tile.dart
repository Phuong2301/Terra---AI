// 🎯 Dart imports:
import 'dart:async';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 🌎 Project imports:
import '../../../domain/core/theme/theme.dart';

class AudioPlayerTile extends StatefulWidget {
  const AudioPlayerTile({
    super.key,
    required this.playDuration,
  });

  /// Total Playing Duration in Seconds
  final int playDuration;

  @override
  State<AudioPlayerTile> createState() => _AudioPlayerTileState();
}

class _AudioPlayerTileState extends State<AudioPlayerTile>
    with TickerProviderStateMixin {
  late AnimationController playPauseAnimation;

  Timer? timer;
  double currentPosition = 0;
  bool isPlaying = false;
  void handleIsPlayingState() {
    setState(() {
      isPlaying = !isPlaying;
      if (isPlaying) {
        playPauseAnimation.forward();
        startTimer();
      } else {
        playPauseAnimation.reverse();
        stopTimer();
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (currentPosition < widget.playDuration) {
        setState(() => currentPosition += 1);
      } else {
        stopTimer();
        handleIsPlayingState();
      }
    });
  }

  void stopTimer() => timer?.cancel();

  bool isMute = false;
  void handleIsMuteState() {
    return setState(() => isMute = !isMute);
  }

  String _formatDuration(double seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = (seconds % 60).toStringAsFixed(0).padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  void initState() {
    super.initState();
    playPauseAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    playPauseAnimation.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _iconSize = responsiveValue<double>(
      context,
      xs: 16,
      md: 20,
    );

    return Container(
      padding: responsiveValue<EdgeInsetsGeometry?>(
        context,
        xs: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 5),
        md: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
      ),
      decoration: BoxDecoration(
        color: _theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        children: [
          // Play/Pause Button
          IconButton(
            onPressed: handleIsPlayingState,
            style: IconButton.styleFrom(
              padding: EdgeInsetsDirectional.zero,
              visualDensity: const VisualDensity(
                horizontal: -4,
                vertical: -4,
              ),
            ),
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: playPauseAnimation,
              size: _iconSize,
            ),
          ),

          // Progress Time Indicator
          Padding(
            padding: responsiveValue<EdgeInsetsGeometry>(
              context,
              xs: const EdgeInsetsDirectional.only(end: 6),
              md: const EdgeInsetsDirectional.only(end: 10),
            ),
            child: Text.rich(
              TextSpan(
                text: _formatDuration(currentPosition),
                children: [
                  TextSpan(
                    text:
                        ' / ${_formatDuration(widget.playDuration.toDouble())}',
                  ),
                ],
              ),
            ),
          ),

          // Progress Indicator
          Expanded(
            child: LinearProgressIndicator(
              value: widget.playDuration > 0
                  ? currentPosition / widget.playDuration
                  : 0.0,
              backgroundColor: _isDark
                  ? AcnooAppColors.kNeutral500
                  : AcnooAppColors.kNeutral400,
            ),
          ),
          const SizedBox(width: 10),

          // Trailing Action Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mute/Loud Button
              IconButton(
                onPressed: handleIsMuteState,
                style: IconButton.styleFrom(
                  padding: EdgeInsetsDirectional.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                iconSize: _iconSize,
                icon: Icon(
                  isMute ? FeatherIcons.volumeX : FeatherIcons.volume2,
                  color: _theme.colorScheme.onTertiary,
                ),
              ),

              // Download Button
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  padding: EdgeInsetsDirectional.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                iconSize: _iconSize,
                icon: Icon(
                  FeatherIcons.download,
                  color: _theme.colorScheme.onTertiary,
                ),
              ),

              // Delete Button
              IconButton(
                onPressed: () {},
                style: IconButton.styleFrom(
                  padding: EdgeInsetsDirectional.zero,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                iconSize: _iconSize,
                icon: Icon(
                  FeatherIcons.trash2,
                  color: _theme.colorScheme.onTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
