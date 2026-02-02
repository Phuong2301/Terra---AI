import 'package:app_mobile/presentation/pages/onboarding/services/onboarding_storage.dart';

import '../../../../generated/l10n.dart' as l;

extension UserRoleUiX on UserRole {
  String label(l.S lang) => switch (this) {
        UserRole.loanOfficer => lang.roleLoanOfficer, // bạn thêm key i18n
        UserRole.farmer => lang.roleFarmer,
        UserRole.fpoAdmin => lang.roleFpoAdmin,
      };
}
