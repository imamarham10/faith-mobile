import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/gap.dart';
import '../controllers/auth_controller.dart';

/// Account creation. Auto-signs the user in once the server confirms.
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _submitting = false;
  bool _obscure = true;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      HapticFeedback.heavyImpact();
      return;
    }
    setState(() {
      _submitting = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            phone: _phoneController.text.trim(),
          );
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      // Router redirect handles navigation post-auth.
    } on ApiException catch (e) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() => _errorMessage = e.message);
    } catch (_) {
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      setState(() => _errorMessage = 'Something went off track. Try again.');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _validateName(String? raw) {
    final v = raw?.trim() ?? '';
    if (v.isEmpty) return 'Required.';
    return null;
  }

  String? _validateEmail(String? raw) {
    final v = raw?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email.';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
    if (!ok) return 'That doesn\'t look like an email.';
    return null;
  }

  String? _validatePhone(String? raw) {
    final v = raw?.trim() ?? '';
    if (v.isEmpty) return 'Enter your phone.';
    final ok = RegExp(r'^\+?[1-9]\d{6,14}$').hasMatch(v);
    if (!ok) return 'Use international format, e.g. +14155551234.';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Choose a password.';
    if (v.length < 8) return 'At least 8 characters.';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Include an uppercase letter.';
    if (!RegExp(r'\d').hasMatch(v)) return 'Include a number.';
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) {
      return 'Include a special character.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenEdge,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Gap(8),
                Center(
                  child: Image.asset(
                    'assets/brand/siraat_logo.png',
                    width: 64,
                    height: 64,
                  ),
                ),
                const Gap(20),
                Text('Create account', style: theme.textTheme.displaySmall),
                const Gap(8),
                Text(
                  'A few quiet details to begin.',
                  style: theme.textTheme.bodyMedium,
                ),
                const Gap(28),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        focusNode: _firstNameFocus,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.givenName],
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'First name'),
                        validator: _validateName,
                        onFieldSubmitted: (_) =>
                            _lastNameFocus.requestFocus(),
                      ),
                    ),
                    const Gap.h(12),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        focusNode: _lastNameFocus,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.familyName],
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Last name'),
                        validator: _validateName,
                        onFieldSubmitted: (_) => _emailFocus.requestFocus(),
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                  ),
                  validator: _validateEmail,
                  onFieldSubmitted: (_) => _phoneFocus.requestFocus(),
                ),
                const Gap(16),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocus,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    hintText: '+14155551234',
                  ),
                  validator: _validatePhone,
                  onFieldSubmitted: (_) => _passwordFocus.requestFocus(),
                ),
                const Gap(16),
                TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: _obscure,
                  textInputAction: TextInputAction.go,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    helperText:
                        'Min 8 chars · uppercase · number · special character',
                    helperMaxLines: 2,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: _validatePassword,
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (_errorMessage != null) ...[
                  const Gap(16),
                  _ErrorBanner(message: _errorMessage!),
                ],
                const Gap(28),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('Create account'),
                ),
                const Gap(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 18, color: theme.colorScheme.error),
          const Gap.h(10),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
