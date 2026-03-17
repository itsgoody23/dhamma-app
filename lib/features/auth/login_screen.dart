import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/extensions/l10n_extension.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/providers/database_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSignUp = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (_isSignUp) {
        await authService.signUpWithEmail(email, password);
      } else {
        await authService.signInWithEmail(email, password);
      }

      await _claimLocalDataAndPop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      await _claimLocalDataAndPop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authServiceProvider).signInWithApple();
      await _claimLocalDataAndPop();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _claimLocalDataAndPop() async {
    final user = ref.read(authServiceProvider).currentUser;
    if (user != null && mounted) {
      final db = ref.read(appDatabaseProvider);
      await db.claimLocalData(user.id);
    }
    if (mounted) context.pop();
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = context.l10n.authEnterEmailFirst);
      return;
    }
    try {
      await ref.read(authServiceProvider).resetPassword(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.authPasswordResetSent)),
        );
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final showApple = Platform.isIOS || Platform.isMacOS;

    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? context.l10n.authCreateAccount : context.l10n.authSignIn)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Icon(Icons.account_circle_outlined,
                  size: 72, color: AppColors.green),
              const SizedBox(height: 16),
              Text(
                context.l10n.authSyncDescription,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),

              // ── Social sign-in buttons ────────────────────────────────
              OutlinedButton.icon(
                onPressed: _loading ? null : _signInWithGoogle,
                icon: const Icon(Icons.g_mobiledata, size: 24),
                label: Text(context.l10n.authContinueGoogle),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
              if (showApple) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _signInWithApple,
                  icon: const Icon(Icons.apple, size: 24),
                  label: Text(context.l10n.authContinueApple),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],

              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(context.l10n.authOr,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 24),

              // ── Email/password form ───────────────────────────────────
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.l10n.authEmail,
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                validator: (v) {
                  if (v == null || !v.contains('@')) {
                    return context.l10n.authEmailInvalid;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: context.l10n.authPassword,
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                validator: (v) {
                  if (v == null || v.length < 6) return context.l10n.authPasswordShort;
                  return null;
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.green,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isSignUp ? context.l10n.authCreateAccount : context.l10n.authSignIn),
              ),
              const SizedBox(height: 12),
              if (!_isSignUp)
                TextButton(
                  onPressed: _resetPassword,
                  child: Text(context.l10n.authForgotPassword),
                ),
              TextButton(
                onPressed: () => setState(() {
                  _isSignUp = !_isSignUp;
                  _error = null;
                }),
                child: Text(_isSignUp
                    ? context.l10n.authAlreadyHaveAccount
                    : context.l10n.authDontHaveAccount),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(context.l10n.authContinueWithout),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
