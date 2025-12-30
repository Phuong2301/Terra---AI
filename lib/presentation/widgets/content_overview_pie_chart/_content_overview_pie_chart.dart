// 🎯 Dart imports:
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '_pie_indicator.dart';

class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.2
      ..strokeCap = StrokeCap.round;
    final colors = [
      const Color(0xff00BF71),
      const Color(0xff8424FF),
      const Color(0xffFF1EE8),
      const Color(0xff3190FF),
      const Color(0xffFFC700),
      const Color(0xffFE4F4F),
    ];

    final startAngles = [0.0, pi / 3, 2 * pi / 3, pi, 4 * pi / 3, 5 * pi / 3];
    const sweepAngle = pi / 3;

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2.5),
        startAngles[i],
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ContentOverViewChart extends StatefulWidget {
  const ContentOverViewChart({super.key});

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<ContentOverViewChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 4,
      sm: 4,
      md: 8,
      lg: 8,
    );
    final _isMobile = rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 575, value: true),
      ],
      defaultValue: false,
    ).value;
    final _isTab = rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 576, end: 992, value: true),
      ],
      defaultValue: false,
    ).value;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Center(
              child: CustomPaint(
                size: _isMobile
                    ? const Size(123, 123)
                    : _isTab
                        ? const Size(193, 193)
                        : const Size(205, 205),
                painter: PieChartPainter(),
              ),
            ),
          ),
          SizedBox(width: _padding),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 PieChartIndicator(
                  color: const Color(0xff0D9AFF),
                  text: '5000',
                 // heading: 'Articles',
                  heading: lang.articles,
                ),
                SizedBox(height: _padding),
                 PieChartIndicator(
                  color: const Color(0xff8424FF),
                  text: '3000',
                 // heading: 'Codes',
                  heading: lang.codes,
                ),
                SizedBox(height: _padding),
                 PieChartIndicator(
                  color: const Color(0xff00BF71),
                  text: '1000',
                 // heading: 'Images',
                  heading:lang.images,
                ),
                SizedBox(height: _padding),
                 PieChartIndicator(
                  color: Colors.red,
                  text: '500',
                  //heading: 'Chats',
                  heading: lang.chats,
                ),
                SizedBox(height: _padding),
                 PieChartIndicator(
                  color: const Color(0xffFFC700),
                  text: '2000',
                  //heading: 'Voiceover',
                  heading: lang.voiceover,
                ),
                SizedBox(height: _padding),
                 PieChartIndicator(
                  color: const Color(0xffFE4F4F),
                  text: '3000',
                  //heading: 'Speech to text',
                  heading: lang.speechToText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
