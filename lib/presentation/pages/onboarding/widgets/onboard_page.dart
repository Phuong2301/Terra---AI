import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../model/onboard_page_data.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key, required this.data});

  final OnboardPageData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onBg = theme.colorScheme.onBackground;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.70),
                      Colors.white.withOpacity(0.38),
                      data.accent.withOpacity(0.12),
                    ],
                  ),
                  border: Border.all(
                    color: data.accent.withOpacity(0.22),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                      color: Colors.black.withOpacity(0.10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon badge
                    Container(
                      width: 74,
                      height: 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.65),
                        border: Border.all(
                          color: data.accent.withOpacity(0.25),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                            color: data.accent.withOpacity(0.18),
                          ),
                        ],
                      ),
                      child: Icon(
                        data.icon,
                        size: 38,
                        color: data.accent,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        color: onBg,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      data.subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: onBg.withOpacity(0.72),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
