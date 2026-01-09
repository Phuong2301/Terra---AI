import 'package:flutter/material.dart';
import '../services/onboarding_storage.dart';
import '../widgets/role_card.dart';
import '../../../../generated/l10n.dart' as l;

class OnboardingRoleStep extends StatelessWidget {
  const OnboardingRoleStep({
    super.key,
    required this.onSelectRole,
    required this.onBack,
  });

  final ValueChanged<UserRole> onSelectRole;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF2563EB);
    final cs = Theme.of(context).colorScheme;
    final lang = l.S.of(context);

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: cs.onBackground, // ✅ icon/title rõ ở cả dark/light
        leading: IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(lang.selectYourRole),
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
                cs.background, // ✅ theo theme, không hardcode trắng
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: cs.surface.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: cs.outlineVariant.withOpacity(0.45)),
                    ),
                    child: Text(
                      lang.whoAreYou,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView(
                      children: [
                        RoleCard(
                          title: lang.loanOfficer,
                          subtitle: lang.loanOfficerDesc,
                          icon: Icons.badge_outlined,
                          accent: const Color(0xFF2563EB),
                          onTap: () => onSelectRole(UserRole.loanOfficer),
                        ),
                        const SizedBox(height: 14),
                        RoleCard(
                          title: lang.farmer,
                          subtitle: lang.farmerDesc,
                          icon: Icons.agriculture_outlined,
                          accent: const Color(0xFF16A34A),
                          onTap: () => onSelectRole(UserRole.farmer),
                        ),
                        const SizedBox(height: 14),
                        RoleCard(
                          title: lang.fpoAdmin,
                          subtitle: lang.fpoAdminDesc,
                          icon: Icons.admin_panel_settings_outlined,
                          accent: const Color(0xFF7C3AED),
                          onTap: () => onSelectRole(UserRole.fpoAdmin),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
