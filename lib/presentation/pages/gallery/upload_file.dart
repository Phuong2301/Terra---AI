import 'package:flutter/material.dart';
import 'package:app_mobile/application/other/app_upload.dart';
import 'package:app_mobile/domain/core/theme/_app_colors.dart';
import 'package:app_mobile/domain/tools/image_picker_platform/models/info_file_model.dart';
import 'package:app_mobile/domain/tools/resize_image/index.dart';
import 'package:app_mobile/generated/l10n.dart' as l;
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:app_mobile/presentation/pages/gallery/models/gallery_model.dart';
import 'package:app_mobile/presentation/widgets/loading/overlay_loading.dart';

import '../../../domain/tools/image_picker_platform/image_picker_platform.dart';

class UploadFile extends StatefulWidget {
  const UploadFile({super.key});

  @override
  State<UploadFile> createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  MInfoFile? infoFile;

  Future<void> pickImage() async {
    Loading.show(context);
    final info = await ImagePickerPlatform.pickSingleFile();
    final item = await ResizeImagePlatform.resize(info?.data);
    if (info != null) {
      info.data = item;
    }
    Loading.hide();
    if (item == null) return;
    setState(() {
      infoFile = info;
    });
  }

  Future<void> upload() async {
    if (infoFile == null) return;
    Loading.show(context);
    final res = await AppUpload.uploadFile(infoFile!.fileName!, infoFile!.data);
    Loading.hide();
    if(!mounted) return;
    if (res != null) {
      Navigator.pop(context, MGalleryItem(id: 0, externalLink: res));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        alignment: Alignment.center,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///---------------- header section
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('upload', style: textTheme.titleMedium),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: AcnooAppColors.kError,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 0.1,
                color: theme.colorScheme.outline,
                height: 0,
              ),

              ///---------------- form fields section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 606,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          pickImage();
                        },
                        child: SizedBox(
                          height: 320,
                          width: 360,
                          child: infoFile == null
                              ? const Icon(Icons.photo, size: 60)
                              : Image.memory(
                                  infoFile!.data!,
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: _sizeInfo.innerSpacing),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _sizeInfo.innerSpacing),
                                  backgroundColor:
                                      theme.colorScheme.primaryContainer,
                                  textStyle: textTheme.bodySmall
                                      ?.copyWith(color: AcnooAppColors.kError),
                                  side: const BorderSide(
                                      color: AcnooAppColors.kError)),
                              onPressed: () => Navigator.pop(context),
                              label: Text(
                                lang.cancel,
                                style: textTheme.bodySmall
                                    ?.copyWith(color: AcnooAppColors.kError),
                              ),
                            ),
                            SizedBox(width: _sizeInfo.innerSpacing),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: _sizeInfo.innerSpacing),
                              ),
                              onPressed: () => upload(),
                              label: Text(lang.save),
                            )
                          ],
                        ),
                      ),
                    ],
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

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
