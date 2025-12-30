import 'package:app_mobile/presentation/pages/assessment/controller/assessment_form_controller.dart';
import 'package:app_mobile/presentation/widgets/input_field/input_select.dart';
import 'package:app_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'assessment_form_rules.dart';

class AssessmentFormScreen extends StatelessWidget {
  const AssessmentFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssessmentFormController()..init(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const accent = Color(0xFF16A34A);

    return Consumer<AssessmentFormController>(
      builder: (context, c, _) {
        return Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: const Text('New Assessment'),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            actions: [
              if (c.savingDraft)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Center(
                    child: Text(
                      'Saving draft…',
                      style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12),
                    ),
                  ),
                ),
              IconButton(
                tooltip: 'Clear draft',
                onPressed: c.clearDraft,
                icon: const Icon(Icons.delete_outline),
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
                          16, 12, 16, 16 + MediaQuery.viewInsetsOf(context).bottom,
                        ),
                        children: [
                          _Section(title: 'Personal', child: Column(
                            children: [
                              InputText(
                                label: 'Farmer name',
                                controller: c.nameCtrl,
                                required: true,
                                rules: kRequiredTextRules,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'Phone (optional)',
                                controller: c.phoneCtrl,
                                keyboardType: TextInputType.phone,
                                rules: kPhoneRules,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'Address',
                                controller: c.addressCtrl,
                                required: true,
                                rules: kRequiredTextRules,
                              ),
                            ],
                          )),
                          const SizedBox(height: 16),

                          _Section(title: 'Farm', child: Column(
                            children: [
                              InputText(
                                label: 'Province',
                                controller: c.provinceCtrl,
                                required: true,
                                rules: kRequiredTextRules,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'District',
                                controller: c.districtCtrl,
                                required: true,
                                rules: kRequiredTextRules,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'Farm size (ha)',
                                controller: c.farmSizeCtrl,
                                keyboardType: TextInputType.number,
                                required: true,
                                rules: kFarmSizeRules,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'Main crop',
                                controller: c.cropCtrl,
                                required: true,
                                rules: kRequiredTextRules,
                              ),
                            ],
                          )),
                          const SizedBox(height: 16),

                          _Section(title: 'Financial', child: Column(
                            children: [
                              InputSelect(
                                label: 'Repayment history',
                                hintText: 'Select repayment history',
                                items: AssessmentFormController.repaymentItems,
                                index: c.repaymentIndex,        
                                required: true,
                                onChange: c.setRepaymentIndex,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'Monthly income',
                                controller: c.incomeCtrl,
                                keyboardType: TextInputType.number,
                                required: true,
                                rules: kMoneyRules,
                              ),
                              const SizedBox(height: 20),
                              InputText(
                                label: 'Monthly debt',
                                controller: c.debtCtrl,
                                keyboardType: TextInputType.number,
                                required: true,
                                rules: kMoneyRules,
                              ),
                            ],
                          )),
                          const SizedBox(height: 16),

                          _Section(title: 'FPO', child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('FPO member?'),
                                subtitle: const Text('Toggle Yes/No'),
                                value: c.isFpoMember,
                                onChanged: c.setIsFpoMember,
                              ),
                              if (c.isFpoMember) ...[
                                const SizedBox(height: 8),
                                InputText(
                                  label: 'FPO name',
                                  controller: c.fpoNameCtrl,
                                  required: true,
                                  rules: kRequiredTextRules,
                                ),
                                const SizedBox(height: 20),
                                InputText(
                                  label: 'Role in FPO (optional)',
                                  controller: c.fpoRoleCtrl,
                                ),
                              ],
                            ],
                          )),
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
                              child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w800)),
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
