part of '../_multi_select_field.dart';

class AcnooMultiSelectTextField extends StatefulWidget {
  const AcnooMultiSelectTextField({
    super.key,
    this.decoration,
    this.showButtonAction = true,
  });

  final InputDecoration? decoration;
  final bool showButtonAction;

  @override
  State<AcnooMultiSelectTextField> createState() =>
      _AcnooMultiSelectTextFieldState();
}

class _AcnooMultiSelectTextFieldState extends State<AcnooMultiSelectTextField> {
  List<String> enteredValues = [];
  late final textEditingController = TextEditingController();

  final _parentFocusNode = FocusNode();
  bool isParentFocused = false;
  final _textFieldFocusNode = FocusNode();
  final _keyboarFocusNode = FocusNode();

  void handleOnComplete() {
    final _value = textEditingController.text;
    if (_value.isEmpty) return;

    setState(() => enteredValues.add(_value));
    textEditingController.clear();
  }

  void handleParentFocusListener() {
    isParentFocused = _parentFocusNode.hasFocus;
    if (isParentFocused) {
      _textFieldFocusNode.requestFocus();
    }
    setState(() {});
  }

  @override
  void initState() {
    _parentFocusNode.addListener(handleParentFocusListener);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _parentFocusNode.dispose();
    _keyboarFocusNode.dispose();
    _textFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _parentFocusNode,
      child: GestureDetector(
        onTap: () => _parentFocusNode.requestFocus(),
        child: InputDecorator(
          isFocused: isParentFocused,
          decoration: widget.decoration ?? const InputDecoration(),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...List.generate(
                enteredValues.length,
                (i) {
                  final _item = enteredValues[i];
                  return SelectedItemButton(
                    labelText: _item,
                    onTap: !widget.showButtonAction
                        ? null
                        : () => setState(() => enteredValues.remove(_item)),
                    showCloseButton: widget.showButtonAction,
                  );
                },
              ),

              // Text Field
              IntrinsicWidth(
                child: KeyboardListener(
                  focusNode: _keyboarFocusNode,
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent) {
                      final _key = event.logicalKey;
                      if (_key == LogicalKeyboardKey.delete ||
                          _key == LogicalKeyboardKey.backspace) {
                        if (textEditingController.text.isEmpty &&
                            enteredValues.isNotEmpty) {
                          enteredValues.removeAt(enteredValues.length - 1);
                          setState(() {});
                        }
                      }
                    }
                  },
                  child: TextField(
                    focusNode: _textFieldFocusNode,
                    controller: textEditingController,
                    onEditingComplete: handleOnComplete,
                    decoration: InputDecoration(
                      hintText: widget.decoration?.hintText,
                      contentPadding: const EdgeInsets.symmetric(vertical: 1.5),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
