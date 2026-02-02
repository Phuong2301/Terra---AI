import 'package:app_mobile/presentation/controller/assessment_form_controller.dart';
import 'package:app_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:app_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'assessment_form_rules.dart';
import '../../../../generated/l10n.dart' as l;

class AssessmentFormScreen extends StatelessWidget {
  const AssessmentFormScreen({super.key, this.demo = false});

  final bool demo;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssessmentFormController()..init(demo: demo),
      child: _View(demo: demo),
    );
  }
}

class _View extends StatelessWidget {
  const _View({required this.demo});
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const accent = Color(0xFF16A34A);
    final t = l.S.of(context);

    return Consumer<AssessmentFormController>(
      builder: (context, c, _) {
        final repayLabels = <String>[
          t.excellent,
          t.good,
          t.fair,
          t.poor,
          t.none,
        ];
        final trackValues = AssessmentFormController.fpoTrackRecordItems;
        final trackLabels = <String>[
          t.excellent,
          t.good,
          t.fair,
          t.poor,
          t.none,
        ];
        final trackIndex = (() {
          final idx = trackValues.indexOf(c.fpoTrackRecord);
          return (idx >= 0 ? idx : 1).toString(); // default GOOD
        })();
        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: Text(demo ? t.newAssessmentDemo : t.newAssessment),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              if (c.savingDraft)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Text(
                      t.savingDraft,
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                    ),
                  ),
                ),
              IconButton(
                tooltip: demo ? t.resetDemoData : t.clearDraft,
                onPressed: c.clearDraft,
                icon: Icon(demo ? Icons.restart_alt_rounded : Icons.delete_outline),
              ),
            ],
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent.withOpacity(0.12), cs.background],
              ),
            ),
            child: SafeArea(
              top: false,
              child: c.loadingDraft
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: c.formKey,
                      child: ListView(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          16 + MediaQuery.viewInsetsOf(context).bottom,
                        ),
                        children: [
                          _Section(
                            title: t.sectionPersonal,
                            child: Column(
                              children: [
                                InputText(
                                  label: t.farmerName,
                                  controller: c.nameCtrl,
                                  required: true,
                                  rules: kRequiredTextRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.phoneOptional,
                                  controller: c.phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  rules: kPhoneRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.address,
                                  controller: c.addressCtrl,
                                  required: true,
                                  rules: kRequiredTextRules,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _Section(
                            title: t.sectionFarm,
                            child: Column(
                              children: [
                                InputText(
                                  label: t.province,
                                  controller: c.provinceCtrl,
                                  required: true,
                                  rules: kRequiredTextRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.district,
                                  controller: c.districtCtrl,
                                  required: true,
                                  rules: kRequiredTextRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.farmSizeHa,
                                  controller: c.farmSizeCtrl,
                                  keyboardType: TextInputType.number,
                                  required: true,
                                  rules: kFarmSizeRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.mainCrop,
                                  controller: c.cropCtrl,
                                  required: true,
                                  rules: kRequiredTextRules,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _Section(
                            title: t.sectionFinancial,
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.businessYears, 
                                  controller: c.businessYearsCtrl,
                                  keyboardType: TextInputType.number,
                                  rules: kBusinessYearsRules,
                                  required: true,
                                ),
                                InputSelect(
                                  label: t.repaymentHistory,
                                  hintText: t.selectRepaymentHistory,
                                  items: repayLabels, 
                                  index: c.repaymentIndex,
                                  required: true,
                                  onChange: c.setRepaymentIndex, 
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.seasonalIncome,
                                  controller: c.seasonalIncomeCtrl,
                                  keyboardType: TextInputType.number,
                                  rules: kMoneyRules,
                                  required: true,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.monthlyIncome,
                                  controller: c.incomeCtrl,
                                  keyboardType: TextInputType.number,
                                  required: true,
                                  rules: kMoneyRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: t.monthlyDebt,
                                  controller: c.debtCtrl,
                                  keyboardType: TextInputType.number,
                                  required: true,
                                  rules: kMoneyRules,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          _Section(
                            title: t.sectionFpo,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(t.fpoMemberQuestion),
                                  subtitle: Text(t.toggleYesNo),
                                  value: c.isFpoMember,
                                  onChanged: c.setIsFpoMember,
                                ),
                                if (c.isFpoMember) ...[
                                  const SizedBox(height: 8),
                                  InputText(
                                    label: t.fpoName,
                                    controller: c.fpoNameCtrl,
                                    required: true,
                                    rules: kRequiredTextRules,
                                  ),
                                  const SizedBox(height: 20),
                                  InputText(
                                    label: t.roleInFpoOptional,
                                    controller: c.fpoRoleCtrl,
                                  ),
                                  const SizedBox(height: 20),
                                  InputSelect(
                                    label: t.fpoTrackRecord,
                                    hintText: t.selectFpoTrackRecord,
                                    items: trackLabels, // HIỂN THỊ THEO NGÔN NGỮ
                                    index: trackIndex,
                                    required: true,
                                    onChange: (val) {
                                      final i = int.tryParse(val ?? '');
                                      if (i == null || i < 0 || i >= trackValues.length) return;
                                      c.setFpoTrackRecord(trackValues[i]); // vẫn lưu value enum
                                    },
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => c.submit(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                t.submit,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
