import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';
import 'package:app_mobile/generated/l10n.dart' as l;
import 'package:app_mobile/presentation/widgets/custom_button/custom_app_button.dart';
import 'components/gallery_item_card.dart';
import 'models/gallery.dart';
import 'upload_file.dart';

class SelectFile extends StatefulWidget {
  const SelectFile({super.key});

  @override
  State<SelectFile> createState() => _SelectFileState();
}

class _SelectFileState extends State<SelectFile> {
  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StoreGallery.instance.data.initFetch();
    setState(() {});
  }

  void _showFormDialog(BuildContext context) async {
    final res = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const UploadFile(),
        );
      },
    );
    if (res == null) return;
    setState(() {
      StoreGallery.instance.data.datas!.insert(0, res);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _innerSpacing = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppAddButton(onAction: () => _showFormDialog(context)),
                  const Spacer(),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: AcnooAppColors.kError,
                      ))
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                width: 606,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StoreGallery.instance.data.datas == null
                      ? const Center(child: CircularProgressIndicator())
                      : StoreGallery.instance.data.datas!.isEmpty
                          ? Center(child: Text(lang.noDataFound))
                          : GridView.count(
                              crossAxisCount: responsiveValue<int>(
                                context,
                                xs: 2,
                                sm: 2,
                                md: 3,
                                lg: 4,
                              ),
                              childAspectRatio: 360 / 320,
                              mainAxisSpacing: _innerSpacing,
                              crossAxisSpacing: _innerSpacing,
                              children: StoreGallery.instance.data.datas!
                                  .map((e) => GalleryImageCard(
                                        item: e,
                                        canSelect: true,
                                      ))
                                  .toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
