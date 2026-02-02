import 'package:app_mobile/presentation/pages/home/widgets/user_role_ui.dart';
import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart' as l;

import '../../onboarding/services/onboarding_storage.dart'; // chỉnh path

class UserProfileTile extends StatefulWidget {
  const UserProfileTile({super.key});

  @override
  State<UserProfileTile> createState() => _UserProfileTileState();
}

class _UserProfileTileState extends State<UserProfileTile> {
  UserRole? _role;
  String _name = '';
  String _phone = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final role = await OnboardingStorage.getRole();
      final name = (await OnboardingStorage.getName()).trim();
      final phone = (await OnboardingStorage.getPhone()).trim();

      if (!mounted) return;
      setState(() {
        _role = role;
        _name = name;
        _phone = phone;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _openEditSheet() async {
    final res = await showModalBottomSheet<_EditResult>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _EditProfileSheet(
        initialRole: _role,
        initialName: _name,
        initialPhone: _phone,
      ),
    );

    if (res == null) return;

    // Lưu
    if (res.role != null) {
      await OnboardingStorage.setRole(res.role!);
    }
    await OnboardingStorage.setProfile(
      name: res.name,
      phone: res.phone,
    );

    // Reload UI
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final cs = Theme.of(context).colorScheme;

    final roleText = _role == null
        ? lang.profileRoleNotSet
        : (_role!.label(lang)); // hoặc tự map string

    final nameText = _name.isEmpty ? lang.profileNameNotSet : _name;

    return Material(
      color: cs.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _loading ? null : _openEditSheet,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.person_outline_rounded, color: cs.onSurface),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _loading
                    ? Text(lang.loading, style: TextStyle(color: cs.onSurfaceVariant))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameText,
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _phone.isEmpty ? roleText : '$roleText • $_phone',
                            style: TextStyle(color: cs.onSurfaceVariant, fontSize: 12.5),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.edit_rounded, size: 18, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditResult {
  final UserRole? role;
  final String name;
  final String phone;

  const _EditResult({
    required this.role,
    required this.name,
    required this.phone,
  });
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.initialRole,
    required this.initialName,
    required this.initialPhone,
  });

  final UserRole? initialRole;
  final String initialName;
  final String initialPhone;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late UserRole? _role = widget.initialRole;
  late final _nameCtrl = TextEditingController(text: widget.initialName);
  late final _phoneCtrl = TextEditingController(text: widget.initialPhone);

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final cs = Theme.of(context).colorScheme;
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang.profileEditTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),

          Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<UserRole>(
                  value: _role,
                  items: UserRole.values
                      .map(
                        (r) => DropdownMenuItem(
                          value: r,
                          child: Text(r.label(lang)), // hoặc map string
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _role = v),
                  decoration: InputDecoration(
                    labelText: lang.profileRoleLabel,
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.35),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => v == null ? lang.profileRoleRequired : null,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _nameCtrl,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: lang.profileNameLabel,
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.35),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) {
                    final t = (v ?? '').trim();
                    if (t.isEmpty) return lang.profileNameRequired;
                    if (t.length < 2) return lang.profileNameTooShort;
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: lang.profilePhoneLabel,
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.35),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(lang.cancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    final ok = _formKey.currentState?.validate() ?? false;
                    if (!ok) return;

                    Navigator.pop(
                      context,
                      _EditResult(
                        role: _role,
                        name: _nameCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                      ),
                    );
                  },
                  child: Text(lang.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
