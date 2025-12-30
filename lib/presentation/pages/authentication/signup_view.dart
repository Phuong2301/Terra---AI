// 🐦 Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../../domain/helpers/fuctions/helper_functions.dart';
import '../../../domain/core/static/static.dart';
import '../../widgets/widgets.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _screenWidth = MediaQuery.sizeOf(context).width;

    final _desktopView = _screenWidth >= 1200;

    final _ssoButtonStyle = OutlinedButton.styleFrom(
      side: BorderSide(
        color: _theme.colorScheme.outline,
      ),
      foregroundColor: _theme.colorScheme.onTertiary,
      padding: rf.ResponsiveValue<EdgeInsetsGeometry?>(
        context,
        conditionalValues: [
          const rf.Condition.between(
            start: 0,
            end: 576,
            value: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ],
      ).value,
    );

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Row(
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: _desktopView ? (_screenWidth * 0.45) : _screenWidth,
                ),
                decoration: BoxDecoration(
                  color: _theme.colorScheme.primaryContainer,
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Header With Logo
                      const CompanyHeaderWidget(),

                      // Sign up form
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 375),
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    lang.signUp,
                                    //'Sign up',
                                    style: _theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  Text.rich(
                                    TextSpan(
                                      //text: 'Already have an account? ',
                                      text: lang.alreadyHaveAnAccount,
                                      children: [
                                        TextSpan(
                                         // text: 'Sign in',
                                          text: lang.signIn,
                                          style: _theme.textTheme.labelLarge
                                              ?.copyWith(
                                            color: _theme.colorScheme.primary,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              context.push(
                                                '/authentication/signin',
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                    style:
                                        _theme.textTheme.labelLarge?.copyWith(
                                      color: _theme.checkboxTheme.side?.color,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // SSO Login Buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                          //label: const Text('Use Google'),
                                          label:  Text(lang.useGoogle),
                                          icon: getImageType(
                                            AcnooStaticImage.googleIcon,
                                            height: 14,
                                            width: 14,
                                          ),
                                          style: _ssoButtonStyle,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: OutlinedButton.icon(
                                          onPressed: () {},
                                         // label: const Text('Use Apple'),
                                          label:  Text(lang.useApple),
                                          icon: getImageType(
                                            AcnooStaticImage.appleIcon,
                                            height: 14,
                                            width: 14,
                                          ),
                                          style: _ssoButtonStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // Divider
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          height: 1,
                                          color: _theme.colorScheme.outline,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        lang.or,
                                       // 'or',
                                        style: _theme.textTheme.bodyMedium
                                            ?.copyWith(),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Container(
                                          height: 1,
                                          color: _theme.colorScheme.outline,
                                        ),
                                      )
                                    ],
                                  ),

                                  // Full Name Field
                                  TextFieldLabelWrapper(
                                    //labelText: 'Full Name',
                                    labelText: lang.fullName,
                                    inputField: TextFormField(
                                      decoration:  InputDecoration(
                                       // hintText: 'Enter full name',
                                        hintText: lang.enterFullName,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Email Field
                                  TextFieldLabelWrapper(
                                   // labelText: 'Email',
                                    labelText: lang.email,
                                    inputField: TextFormField(
                                      decoration:  InputDecoration(
                                        //hintText: 'Enter email address',
                                        hintText: lang.enterEmailAddress,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Password Field
                                  TextFieldLabelWrapper(
                                    //labelText: 'Password',
                                    labelText: lang.password,
                                    inputField: TextFormField(
                                      obscureText: !showPassword,
                                      decoration: InputDecoration(
                                        //hintText: 'Enter your password',
                                        hintText: lang.enterYourPassword,
                                        suffixIcon: IconButton(
                                          onPressed: () => setState(
                                            () => showPassword = !showPassword,
                                          ),
                                          icon: Icon(
                                            showPassword
                                                ? FeatherIcons.eye
                                                : FeatherIcons.eyeOff,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Submit Button
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      //child: const Text('Sign Up'),
                                      child:  Text(lang.signUp),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Cover Image
            if (_desktopView)
              Container(
                constraints: BoxConstraints(
                  maxWidth: _screenWidth * 0.55,
                  maxHeight: double.maxFinite,
                ),
                decoration: BoxDecoration(
                  color: _theme.colorScheme.tertiaryContainer,
                ),
                child: getImageType(
                  AcnooStaticImage.signUpCover,
                  fit: BoxFit.contain,
                  height: double.maxFinite,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
