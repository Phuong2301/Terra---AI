// ignore_for_file: public_member_api_docs, sort_constructors_first
class MPreStage {
  final List<String> stageScreenType;
  final List<String> stageProductForm;
  final List<String> stageQCStatus;
  final List<String> stagePackageSize;
  MPreStage({
    required this.stageScreenType,
    required this.stageProductForm,
    required this.stageQCStatus,
    required this.stagePackageSize,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stage_screen_type': stageScreenType,
      'stage_product_form': stageProductForm,
      'stage_qc_status': stageQCStatus,
      'stage_package_size': stagePackageSize,
    };
  }

  factory MPreStage.fromMap(Map<String, dynamic> map) {
    return MPreStage(
      stageScreenType:
          List<String>.from(map['stage_screen_type'] ?? <String>[]),
      stageProductForm:
          List<String>.from(map['stage_product_form'] ?? <String>[]),
      stageQCStatus: List<String>.from(map['stage_qc_status'] ?? <String>[]),
      stagePackageSize:
          List<String>.from(map['stage_package_size'] ?? <String>[]),
    );
  }
}
