class DemoSamples {
  DemoSamples._();

  static Map<String, dynamic> bestCaseAssessment() {
    final now = DateTime.now();
    return {
      'id': 'demo_${now.millisecondsSinceEpoch}',
      'createdAt': now.toIso8601String(),
      'fullName': 'Nguyen Van A (Demo)',
      'phone': '0900000000',
      'address': 'Mekong Delta',
      'province': 'Can Tho',
      'district': 'Ninh Kieu',
      'farmSizeHa': 3.5,
      'mainCrop': 'Rice',
      'monthlyIncome': 2200.0,
      'monthlyDebt': 300.0,
      'repaymentHistory': 'Excellent',
      'isFpoMember': true,
      'fpoName': 'Mekong FPO',
      'fpoRole': 'Member',
      'fpoTrackRecord': 'GOOD',
      'businessYears': 4,
      'seasonalIncome': 200.5,
      'status': 'submitted_demo',
    };
  }
}
