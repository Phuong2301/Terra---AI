import 'package:flutter/material.dart';
import 'package:app_mobile/presentation/widgets/input_field/input_text.dart';
import 'package:app_mobile/presentation/widgets/validators/validators.dart';
import '../../../../generated/l10n.dart' as l;

class OnboardingProfileStep extends StatefulWidget {
  const OnboardingProfileStep({
    super.key,
    required this.onSubmit,
    required this.onBack,
  });

  final Future<void> Function({required String name, required String phone})
      onSubmit;
  final VoidCallback onBack;

  @override
  State<OnboardingProfileStep> createState() => _OnboardingProfileStepState();
}

class _OnboardingProfileStepState extends State<OnboardingProfileStep> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _saving = true);
    await widget.onSubmit(
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const accent = Color(0xFF16A34A);
    final lang = l.S.of(context);

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: cs.onBackground,
        leading: IconButton(
          onPressed: _saving ? null : widget.onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(lang.quickProfile),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                accent.withOpacity(0.14),
                cs.background,
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    16 + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: accent.withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: cs.outlineVariant.withOpacity(0.35),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.badge_outlined,
                                    color: accent,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        lang.tellUsAboutYou,
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: cs.onBackground,
                                          height: 1.15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        lang.profileHint,
                                        style: TextStyle(
                                          color: cs.onSurfaceVariant,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: cs.surface,
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(
                                  color: cs.outlineVariant.withOpacity(0.35),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.06),
                                    blurRadius: 18,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    InputText(
                                      label: lang.whatsYourName,
                                      controller: _nameCtrl,
                                      required: true,
                                      rules: [
                                        V.minLength(2, message: lang.invalidName),
                                      ],
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 16),
                                    InputText(
                                      label: lang.phoneOptional,
                                      controller: _phoneCtrl,
                                      keyboardType: TextInputType.phone,
                                      hintText: lang.noVerification,
                                      rules: [
                                        V.phoneE164Optional(),
                                      ],
                                      textInputAction: TextInputAction.done,
                                    ),
                                    const SizedBox(height: 16),

                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: FilledButton(
                                        onPressed: _saving ? null : _continue,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: accent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                        child: AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 180),
                                          child: _saving
                                              ? const SizedBox(
                                                  key: ValueKey('loading'),
                                                  width: 18,
                                                  height: 18,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                )
                                              : Row(
                                                  key: ValueKey('text'),
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.arrow_forward_rounded, size: 18),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      lang.continuee,
                                                      style: TextStyle(fontWeight: FontWeight.w800),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    Text(
                                      lang.changeLaterHint,
                                      style: TextStyle(
                                        color: cs.onSurfaceVariant,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
