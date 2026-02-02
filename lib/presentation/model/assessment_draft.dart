class AssessmentDraft {
  String fullName;
  String phone;
  String address;
  String province;
  String district;
  double? farmSizeHa;
  String mainCrop;
  String repaymentHistory;
  double? monthlyIncome;
  double? monthlyDebt;
  bool isFpoMember;
  String fpoName;
  String fpoRole;
  String fpoTrackRecord;
  int? businessYears;
  double? seasonalIncome;
  

  AssessmentDraft({
    this.fullName = '',
    this.phone = '',
    this.address = '',
    this.province = '',
    this.district = '',
    this.farmSizeHa,
    this.mainCrop = '',
    this.repaymentHistory = 'None',
    this.monthlyIncome,
    this.monthlyDebt,
    this.isFpoMember = false,
    this.fpoName = '',
    this.fpoRole = '',
    this.fpoTrackRecord = 'GOOD',
    this.businessYears,
    this.seasonalIncome,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'address': address,
        'province': province,
        'district': district,
        'farmSizeHa': farmSizeHa,
        'mainCrop': mainCrop,
        'repaymentHistory': repaymentHistory,
        'monthlyIncome': monthlyIncome,
        'monthlyDebt': monthlyDebt,
        'isFpoMember': isFpoMember,
        'fpoName': fpoName,
        'fpoRole': fpoRole,
        'fpoTrackRecord': fpoTrackRecord,
        'businessYears': businessYears,
        'seasonalIncome': seasonalIncome,
      };

  static AssessmentDraft fromJson(Map<String, dynamic> j) => AssessmentDraft(
        fullName: (j['fullName'] ?? '') as String,
        phone: (j['phone'] ?? '') as String,
        address: (j['address'] ?? '') as String,
        province: (j['province'] ?? '') as String,
        district: (j['district'] ?? '') as String,
        farmSizeHa: (j['farmSizeHa'] as num?)?.toDouble(),
        mainCrop: (j['mainCrop'] ?? '') as String,
        repaymentHistory: (j['repaymentHistory'] ?? 'None') as String,
        monthlyIncome: (j['monthlyIncome'] as num?)?.toDouble(),
        monthlyDebt: (j['monthlyDebt'] as num?)?.toDouble(),
        isFpoMember: (j['isFpoMember'] ?? false) as bool,
        fpoName: (j['fpoName'] ?? '') as String,
        fpoRole: (j['fpoRole'] ?? '') as String,
        fpoTrackRecord: (j['fpoTrackRecord'] ?? 'GOOD').toString(),
        businessYears: (j['businessYears'] as num?)?.toInt(),
        seasonalIncome: (j['seasonalIncome'] as num?)?.toDouble(),
      );
}
