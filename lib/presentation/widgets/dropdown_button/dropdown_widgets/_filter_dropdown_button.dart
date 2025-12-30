part of '../_dropdown_button.dart';

class FilterDropdownButton<T> extends StatefulWidget {
  const FilterDropdownButton({
    super.key,
    this.value,
    this.items,
    this.onChanged,
    this.buttonDecoration,
  });

  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T? value)? onChanged;
  final BoxDecoration? buttonDecoration;


  @override
  State<FilterDropdownButton<T>> createState() =>
      _FilterDropdownButtonState<T>();
}

class _FilterDropdownButtonState<T> extends State<FilterDropdownButton<T>> {
  List<DropdownMenuItem<T>> items = [];
  T? selectedItem;

  void getItems() {
    if (widget.items == null) {
      items = [
        l.S.current.monthly,
        l.S.current.yearly,
      ]
          .asMap()
          .entries
          .map((e) => DropdownMenuItem(value: e.key as T, child: Text(e.value)))
          .cast<DropdownMenuItem<T>>()
          .toList();
    } else {
      items = widget.items ?? [];
    }

    if (!items.any((item) => item.value == selectedItem)) {
      selectedItem = widget.value ?? items.firstOrNull?.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);

    getItems();

    final _selectedChild = items
        .firstWhereOrNull((element) => element.value == selectedItem)
        ?.child;

    return DropdownButton2<T>(
      underline: const SizedBox.shrink(),
      isDense: true,
      isExpanded: true,
      customButton: OutlinedDropdownButton(
        decoration: widget.buttonDecoration,
        child: _selectedChild,
      ),
      style: _theme.textTheme.bodyMedium,
      iconStyleData: _dropdownStyle.iconStyle,
      dropdownStyleData: _dropdownStyle.dropdownStyle,
      menuItemStyleData: _dropdownStyle.menuItemStyle,
      value: selectedItem,
      items: items,
      onChanged: (value) {
        setState(() => selectedItem = value);
        widget.onChanged?.call(value);
      },
    );
  }
}
