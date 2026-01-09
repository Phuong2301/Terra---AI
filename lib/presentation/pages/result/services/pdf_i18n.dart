import '../../../../generated/l10n.dart' as l;

/// Strings dùng riêng cho PDF (không phụ thuộc BuildContext trong service)
class PdfI18n {
  final String brandName;
  final String generatedAt;

  final String reportTitle;
  final String reportSubtitle;

  final String farmerInformation;
  final String riskScore;
  final String recommendedLoanTerms;
  final String aiReasoning;

  final String name;
  final String phone;
  final String address;
  final String provinceDistrict;
  final String mainCrop;
  final String farmSizeHa;

  final String score;
  final String base;
  final String ai;
  final String fpo;

  final String maxAmount;
  final String interest;
  final String tenure;
  final String repayment;

  final String note;

  const PdfI18n({
    required this.brandName,
    required this.generatedAt,
    required this.reportTitle,
    required this.reportSubtitle,
    required this.farmerInformation,
    required this.riskScore,
    required this.recommendedLoanTerms,
    required this.aiReasoning,
    required this.name,
    required this.phone,
    required this.address,
    required this.provinceDistrict,
    required this.mainCrop,
    required this.farmSizeHa,
    required this.score,
    required this.base,
    required this.ai,
    required this.fpo,
    required this.maxAmount,
    required this.interest,
    required this.tenure,
    required this.repayment,
    required this.note,
  });

  factory PdfI18n.fromS(l.S s) {
    return PdfI18n(
      brandName: s.pdfBrandName, // bạn sẽ thêm key arb
      generatedAt: s.pdfGeneratedAt,

      reportTitle: s.pdfReportTitle,
      reportSubtitle: s.pdfReportSubtitle,

      farmerInformation: s.pdfFarmerInformation,
      riskScore: s.pdfRiskScore,
      recommendedLoanTerms: s.pdfRecommendedLoanTerms,
      aiReasoning: s.pdfAiReasoning,

      name: s.pdfName,
      phone: s.pdfPhone,
      address: s.pdfAddress,
      provinceDistrict: s.pdfProvinceDistrict,
      mainCrop: s.pdfMainCrop,
      farmSizeHa: s.pdfFarmSizeHa,

      score: s.pdfScore,
      base: s.pdfBase,
      ai: s.pdfAi,
      fpo: s.pdfFpo,

      maxAmount: s.pdfMaxAmount,
      interest: s.pdfInterest,
      tenure: s.pdfTenure,
      repayment: s.pdfRepayment,

      note: s.pdfNote,
    );
  }
}
