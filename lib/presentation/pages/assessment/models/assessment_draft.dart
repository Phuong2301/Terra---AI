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
      );
}
