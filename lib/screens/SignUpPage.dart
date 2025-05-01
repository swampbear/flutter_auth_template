/*
  File: lib/pages/sign_up_page.dart
*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../helpers/ui_helper.dart';
import '../viewmodels/auth_state.dart';
import '../viewmodels/signup_viewmodel.dart';
import '../widgets/auth_widgets.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signUpViewModelProvider);
    final vm = ref.read(signUpViewModelProvider.notifier);

    ref.listen<AuthState>(signUpViewModelProvider, (prev, next) {
      if (next.status == AuthStatus.error) {
        UIHelper.showToast(next.errorMessage!, isError: true);
      } else if (next.status == AuthStatus.success) {
        UIHelper.showToast('Sign-up successful!', isError: false);
        context.push('/signin');
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader('Create your Account'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputField(
                      controller: _emailCtrl,
                      hint: 'Email',
                      icon: Icons.email,
                      validator:
                          (v) =>
                              (v == null || v.isEmpty) ? 'Enter email' : null,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      controller: _passCtrl,
                      hint: 'Password',
                      icon: Icons.lock,
                      obscure: _obscurePass,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed:
                            () => setState(() => _obscurePass = !_obscurePass),
                      ),
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? 'Enter password'
                                  : null,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      controller: _confirmCtrl,
                      hint: 'Confirm Password',
                      icon: Icons.lock,
                      obscure: _obscureConfirm,
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed:
                            () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Confirm password';
                        if (v != _passCtrl.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: 'Register',
                      loading: state.status == AuthStatus.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          vm.signUp(_emailCtrl.text.trim(), _passCtrl.text);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const SeparatorWithText('Or sign up with'),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        SocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onPressed: () {
                            /* google signup */
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AuthFooterLink(
                      text: 'Already have an account?',
                      actionText: 'Sign In',
                      onTap: () => context.push('/signin'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
