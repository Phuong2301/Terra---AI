import 'package:app_mobile/application/providers/_app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageMenuButton extends StatelessWidget {
  const LanguageMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<AppProvider>().currentLocale;

    bool isSelected(Locale l) =>
        l.languageCode == currentLocale.languageCode &&
        (l.countryCode ?? '') == (currentLocale.countryCode ?? '');

    return PopupMenuButton<Locale>(
      icon: const Icon(Icons.language),
      tooltip: 'Change language',
      onSelected: (locale) =>
          context.read<AppProvider>().changeLocale(locale),
      itemBuilder: (_) => [
        PopupMenuItem<Locale>(
          value: const Locale('vi', 'VN'),
          child: _LanguageItem(
            flag: '🇻🇳',
            label: 'Tiếng Việt',
            selected: isSelected(const Locale('vi', 'VN')),
          ),
        ),
        PopupMenuItem<Locale>(
          value: const Locale('en', 'US'),
          child: _LanguageItem(
            flag: '🇺🇸',
            label: 'English',
            selected: isSelected(const Locale('en', 'US')),
          ),
        ),
      ],
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;

  const _LanguageItem({
    required this.flag,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
        if (selected)
          const Icon(
            Icons.check,
            size: 18,
            color: Colors.green,
          ),
      ],
    );
  }
}
