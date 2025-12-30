import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'services/onboarding_storage.dart';
import 'steps/onboarding_intro_step.dart';
import 'steps/onboarding_role_step.dart';
import 'steps/onboarding_profile_step.dart';

enum OnboardingStep { intro, role, profile }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.nextRoutePath,
  });

  final String nextRoutePath;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  OnboardingStep _step = OnboardingStep.intro;

  @override
  void initState() {
    super.initState();
    _restoreProgress();
  }

  Future<void> _restoreProgress() async {
    final done = await OnboardingStorage.isCompleted();
    if (done) {
      if (!mounted) return;
      context.go(widget.nextRoutePath);
      return;
    }

    // Nếu đã có role mà chưa có name -> vào profile
    try {
      final role = await OnboardingStorage.getRole();
      final name = await OnboardingStorage.getName();

      if (!mounted) return;

      if (role != null && name.trim().isEmpty) {
        setState(() => _step = OnboardingStep.profile);
      } else {
        setState(() => _step = OnboardingStep.intro);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _step = OnboardingStep.intro);
    }
  }

  Future<void> _goToRoleOrProfile() async {
    try {
      final role = await OnboardingStorage.getRole();
      if (!mounted) return;
      setState(() {
        _step = (role == null) ? OnboardingStep.role : OnboardingStep.profile;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _step = OnboardingStep.role);
    }
  }

  Future<void> _onRoleSelected(UserRole role) async {
    await OnboardingStorage.setRole(role);
    if (!mounted) return;
    setState(() => _step = OnboardingStep.profile);
  }

  Future<void> _onProfileSubmit({
    required String name,
    required String phone,
  }) async {
    await OnboardingStorage.setProfile(name: name, phone: phone);
    await OnboardingStorage.setCompleted(true);

    if (!mounted) return;
    context.go(widget.nextRoutePath);
  }

  void _backFromRole() {
    setState(() => _step = OnboardingStep.intro);
  }

  void _backFromProfile() {
    setState(() => _step = OnboardingStep.role);
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case OnboardingStep.intro:
        return OnboardingIntroStep(
          onSkip: _goToRoleOrProfile,
          onFinishIntro: _goToRoleOrProfile,
        );

      case OnboardingStep.role:
        return OnboardingRoleStep(
          onBack: _backFromRole,
          onSelectRole: _onRoleSelected,
        );

      case OnboardingStep.profile:
        return OnboardingProfileStep(
          onBack: _backFromProfile, 
          onSubmit: _onProfileSubmit,
        );
    }
  }
}
