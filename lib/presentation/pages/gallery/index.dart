// 🐦 Flutter imports:
import 'dart:ui';

import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:app_mobile/presentation/widgets/responsive_list_or_table/responsive_grid.dart';
// import 'package:app_mobile/domain/tools/image_picker_platform/models/info_file_model.dart';
import 'package:app_mobile/presentation/pages/gallery/models/gallery.dart';
import 'package:app_mobile/presentation/pages/gallery/upload_file.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import 'components/gallery_item_card.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView>
    with SingleTickerProviderStateMixin {
  // final _pickedImages = <MInfoFile>[];

  @override
  void initState() {
    super.initState();
    iniFetch();
  }

  iniFetch() async {
    await StoreGallery.instance.data.initFetch();
    setState(() {});
  }

  refresh() async {
    StoreGallery.instance.data.datas = null;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    await StoreGallery.instance.data.refresh();
    setState(() {});
  }

  fetchNextPage() async {
    await StoreGallery.instance.data.fetchNextPage();
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

    return Scaffold(
      body: ShadowContainer(
        margin: EdgeInsetsDirectional.all(_innerSpacing),
        // headerPadding: EdgeInsets.zero,
        customHeader: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAddButton(onAction: () => _showFormDialog(context)),
                const Spacer(),
                AppRefreshButton(onAction: () => refresh()),
              ],
            ),
          ),
        ),
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
                        .map((e) => GalleryImageCard(item: e))
                        .toList()),
      ),
    );
  }
}