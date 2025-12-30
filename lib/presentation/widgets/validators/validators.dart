import 'package:app_mobile/generated/l10n.dart' as l;

typedef Rule<T> = String? Function(T value);
String req(String label) => '$label *';

class V {
  static Rule<String?> required([String? message]) => (v) {
        final msg = message ?? l.S.current.field_required; 
        return (v == null || v.trim().isEmpty) ? msg : null;
      };

  static Rule<String?> number([String? message]) => (v) {
        final msg = message ?? l.S.current.enter_valid_number;
        return (v == null || num.tryParse(v.replaceAll(',', '.')) == null) ? msg : null;
      };

  static Rule<String?> integer([String? message]) => (v) {
        final msg = message ?? l.S.current.enter_valid_integer;
        return (v == null || int.tryParse(v) == null) ? msg : null;
      };

  static Rule<String?> positive([String? message]) => (v) {
        final msg = message ?? l.S.current.enter_valid_positive;
        if (v == null) return msg;
        final n = num.tryParse(v.replaceAll(',', '.'));
        return (n == null || n <= 0) ? msg : null;
      };

  static Rule<String?> nonNegative([String? message]) => (v) {
        final msg = message ?? l.S.current.enter_valid_non_negative;
        if (v == null) return msg;
        final n = num.tryParse(v.replaceAll(',', '.'));
        return (n == null || n < 0) ? msg : null;
      };

  static Rule<String?> minNum(num min, {String? message}) => (v) {
        final n = (v == null) ? null : num.tryParse(v.replaceAll(',', '.'));
        final msg = message ?? l.S.current.err_min_number(min); 
        return (n == null || n < min) ? msg : null;
      };

  static Rule<String?> maxNum(num max, {String? message}) => (v) {
        final n = (v == null) ? null : num.tryParse(v.replaceAll(',', '.'));
        final msg = message ?? l.S.current.err_max_number(max); 
        return (n == null || n > max) ? msg : null;
      };

  static Rule<String?> minLength(int n, {String? message}) => (v) {
        final msg = message ?? l.S.current.err_min_length(n); 
        return (v == null || v.trim().length < n) ? msg : null;
      };

  static Rule<String?> maxLength(int n, {String? message}) => (v) {
        final msg = message ?? l.S.current.err_max_length(n); 
        return (v != null && v.trim().length > n) ? msg : null;
      };

  static Rule<String?> pattern(RegExp re, {String? message}) => (v) {
        final msg = message ?? l.S.current.invalid_format;
        return (v == null || !re.hasMatch(v)) ? msg : null;
      };

  static Rule<String?> phoneE164({String? message}) => (v) {
        final msg = message ?? l.S.current.invalid_phone_e164;
        return (v == null || !RegExp(r'^\+?\d{9,15}$').hasMatch(v.replaceAll(' ', ''))) ? msg : null;
      };

  static Rule<String?> phoneE164Optional({String? message}) => (v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return null;
    final msg = message ?? l.S.current.invalid_phone_e164;
    return RegExp(r'^\+?\d{9,15}$').hasMatch(s.replaceAll(' ', '')) ? null : msg;
  };

  static Rule<String?> selectRequired([String? message]) => (idx) {
        final msg = message ?? l.S.current.please_select;
        return (idx == null || idx.isEmpty) ? msg : null;
      };

  static Rule<String?> indexInRange(int length, {String? message}) => (idxStr) {
        final i = int.tryParse(idxStr ?? '');
        final msg = message ?? l.S.current.index_out_of_range;
        return (i == null || i < 0 || i >= length) ? msg : null;
      };

  static Rule<String?> maxDecimalPlaces(int places, {String? message}) => (v) {
        if (v == null || v.isEmpty) return null;
        final re = RegExp('^\\d+(?:[.,]\\d{0,$places})?\$');
        final msg = message ?? l.S.current.max_decimal_places(places);
        return re.hasMatch(v) ? null : msg;
      };

  static String? firstError<T>(T value, List<Rule<T>> rules) {
    for (final r in rules) {
      final err = r(value);
      if (err != null) return err;
    }
    return null;
  }
}
final kMoistureRules = <Rule<String?>>[
  V.required(),
  V.number(),
  V.nonNegative(),
  V.maxNum(100),
  V.maxDecimalPlaces(2),
];

final kQtyRules = <Rule<String?>>[
  V.required(),
  V.number(),
  V.nonNegative(),
];
