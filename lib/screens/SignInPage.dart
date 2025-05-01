import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../helpers/ui_helper.dart';
import '../viewmodels/auth_state.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/auth_widgets.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInViewModelProvider);
    final vm = ref.read(signInViewModelProvider.notifier);

    ref.listen<AuthState>(signInViewModelProvider, (prev, next) {
      if (next.status == AuthStatus.error) {
        UIHelper.showToast(next.errorMessage!, isError: true);
      } else if (next.status == AuthStatus.success) {
        UIHelper.showToast('Login successful', isError: false);
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader('Sign in to your Account'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
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
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter password';
                        if (v.length < 6) return 'Min 6 chars';
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          /* forgot logic */
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: 'Login',
                      loading: state.status == AuthStatus.loading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          vm.signIn(_emailCtrl.text.trim(), _passCtrl.text);
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const SeparatorWithText('Or login with'),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        SocialButton(
                          icon: Icons.g_mobiledata,
                          label: 'Google',
                          onPressed: () {
                            /* google login */
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    AuthFooterLink(
                      text: "Don’t have an account?",
                      actionText: 'Register',
                      onTap: () => context.push('/signup'),
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
