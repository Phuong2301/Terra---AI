import 'package:flutter/foundation.dart';
import 'package:app_mobile/application/app_auth.dart';
import 'package:flutter/material.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:app_mobile/application/providers/_user_provider.dart';
import 'package:app_mobile/presentation/widgets/loading/overlay_loading.dart';
import '../../../generated/l10n.dart' as l;
import '../../../domain/helpers/fuctions/helper_functions.dart';
import '../../../domain/core/static/static.dart';
import '../../widgets/widgets.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  bool rememberMe = false;
  bool showPassword = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  initState() {
    AppAuth.logout();
    super.initState();
    if (kDebugMode) {
      emailController.text = 'pfs@gmail.com';
      passwordController.text = '12345678';
    }
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  onLogin() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (emailController.text.isEmpty || passwordController.text.isEmpty) return;
    Loading.show(context);
    final result =
        await AppAuth.login(emailController.text, passwordController.text);
    Loading.hide();
    if(!mounted) return;
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Incorrect login information!')),
      );
      return;
    }

    UserProvider.instance.justLogin = true;
    context.pushReplacement('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _screenWidth = MediaQuery.sizeOf(context).width;
    final _desktopView = _screenWidth >= 1200;

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
                      const CompanyHeaderWidget(),
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
                                    lang.signIn,
                                    style: _theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const SizedBox(height: 20),
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
                                  TextFieldLabelWrapper(
                                    labelText: lang.email,
                                    inputField: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        hintText: lang.enterYourEmailAddress,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  TextFieldLabelWrapper(
                                    labelText: lang.password,
                                    inputField: TextFormField(
                                      controller: passwordController,
                                      obscureText: !showPassword,
                                      decoration: InputDecoration(
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
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: double.maxFinite,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await onLogin();
                                      },
                                      child: Text(lang.signIn),
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
                  AcnooStaticImage.signInCover,
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

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.forgotPassword,
                  style: _theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lang.enterYourEmailWeWillSendYouALinkToResetYourPassword,
                  style: _theme.textTheme.bodyLarge?.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFieldLabelWrapper(
                  labelText: lang.email,
                  inputField: TextFormField(
                    decoration: InputDecoration(
                      hintText: lang.enterYourEmailAddress,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(lang.send),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
