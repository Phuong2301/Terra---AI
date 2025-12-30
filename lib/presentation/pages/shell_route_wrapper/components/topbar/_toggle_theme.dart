part of '_topbar.dart';

class ThemeToggler extends StatelessWidget {
  const ThemeToggler({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  final bool isDarkMode;
  final void Function(bool value) onChanged;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onChanged.call(!isDarkMode),
      icon: Icon(
        isDarkMode
            ? Icons.nightlight_round_outlined
            : Icons.light_mode_outlined,
      ),
    );
  }
}
