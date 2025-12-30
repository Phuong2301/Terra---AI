import 'package:flutter/material.dart';
import 'package:app_mobile/domain/helpers/main_helpers.dart';
import 'package:app_mobile/presentation/pages/gallery/models/gallery_model.dart';

class GalleryImageCard extends StatefulWidget {
  const GalleryImageCard({
    super.key,
    required this.item,
    this.canSelect = false,
  });
  final MGalleryItem item;
  final bool canSelect;

  @override
  State<GalleryImageCard> createState() => GalleryImageCardState();
}

class GalleryImageCardState extends State<GalleryImageCard> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          if (widget.canSelect) {
            Navigator.pop(context, widget.item.externalLink);
          }
        },
        child: Material(
          color: _theme.colorScheme.primaryContainer,
          elevation: isHovering ? 4.75 : 0,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                  child: Image.network(
                checkImagePath(widget.item.externalLink),
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 60,
                  );
                },
              )),
              if (isHovering)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.225),
                      BlendMode.overlay,
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
