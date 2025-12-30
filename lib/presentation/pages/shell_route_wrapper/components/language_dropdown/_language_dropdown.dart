// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:collection/collection.dart';
import 'package:country_flags/country_flags.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// 🌎 Project imports:
import '../../../../../domain/helpers/field_styles/field_styles.dart';
import '../../../../widgets/widgets.dart';

class LanguageDropdownWidget extends StatelessWidget {
  const LanguageDropdownWidget({
    super.key,
    this.value,
    this.supportedLanguage = const {},
    this.onChanged,
  });
  final Locale? value;
  final Map<String, Locale> supportedLanguage;
  final void Function(Locale? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);

    final _dropdownStyle = AcnooDropdownStyle(context);

    final _item = supportedLanguage.entries
        .map((item) => DropdownMenuItem<Locale>(
              value: item.value,
              child: _buildDropdownTile(context, item: item),
            ))
        .toList();

    final _selectedChild =
        _item.firstWhereOrNull((e) => e.value == value)?.child;

    return Theme(
      data: _theme.copyWith(
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all<bool?>(false),
          trackVisibility: WidgetStateProperty.all<bool?>(false),
        ),
      ),
      child: DropdownButton2<Locale>(
        underline: const SizedBox.shrink(),
        isDense: true,
        isExpanded: true,
        customButton: OutlinedDropdownButton(child: _selectedChild),
        style: _theme.textTheme.bodyMedium,
        iconStyleData: _dropdownStyle.iconStyle,
        dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
          width: _mqSize.width > 480 ? 150 : null,
        ),
        menuItemStyleData: _dropdownStyle.menuItemStyle,
        value: value,
        items: _item,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDropdownTile(
    BuildContext context, {
    required MapEntry<String, Locale> item,
  }) {
    final _size = MediaQuery.sizeOf(context);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: CountryFlag.fromCountryCode(
            item.value.countryCode ?? 'us',
            height: 20,
            width: 26,
          ),
        ),
        if (_size.width >= 480) Text(item.key),
      ],
    );
  }
}
