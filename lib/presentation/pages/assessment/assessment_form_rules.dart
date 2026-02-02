

import 'package:app_mobile/presentation/widgets/validators/validators.dart';

final kRequiredTextRules = <Rule<String?>>[
  V.required(),
];

final kPhoneRules = <Rule<String?>>[
  V.phoneE164Optional(),
];

final kFarmSizeRules = <Rule<String?>>[
  V.required(),
  V.number(),
  V.positive(),
  V.maxDecimalPlaces(2),
];

final kMoneyRules = <Rule<String?>>[
  V.required(),
  V.number(),
  V.nonNegative(),
  V.maxDecimalPlaces(2),
];

final kBusinessYearsRules = <Rule<String?>>[
  V.required(),
  V.number(), 
  V.nonNegative(),
];
