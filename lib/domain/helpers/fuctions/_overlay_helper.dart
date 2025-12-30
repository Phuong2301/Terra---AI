import 'package:flutter/material.dart';

class OverlayHelper {
  OverlayHelper(this.context);

  final BuildContext context;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void showOverlay({
    required Widget child,
    Offset offset = const Offset(0, 0),
  }) {
    if (_overlayEntry != null) return;
    _overlayEntry = _createOverlayEntry(child: child, offset: offset);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry({
    required Widget child,
    Offset offset = const Offset(0, 0),
  }) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height) + offset,
          child: child,
        ),
      ),
    );
  }

  LayerLink get layerLink => _layerLink;
  OverlayEntry? get overlayEntry => _overlayEntry;
}
