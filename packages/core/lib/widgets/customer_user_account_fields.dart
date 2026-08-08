import 'package:flutter/material.dart';

import 'password_text_field.dart';

class CustomerUserAccountFields extends StatefulWidget {
  const CustomerUserAccountFields({
    super.key,
    required this.createUser,
    required this.onCreateUserChanged,
    this.emailController,
    this.phoneController,
    this.passwordController,
    this.confirmPasswordController,
    this.contactPhone,
    this.contactEmail,
    this.phoneFromContact,
  });

  final bool createUser;
  final ValueChanged<bool> onCreateUserChanged;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? passwordController;
  final TextEditingController? confirmPasswordController;
  /// Live contact phone/mobile from the parent form (shop phone, van mobile, etc.).
  final String? contactPhone;
  /// Live contact email from the parent form (van/importer email).
  final String? contactEmail;
  final String? phoneFromContact;

  @override
  State<CustomerUserAccountFields> createState() => CustomerUserAccountFieldsState();
}

class CustomerUserAccountFieldsState extends State<CustomerUserAccountFields> {
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  late final bool _ownsControllers;

  String? get _effectiveContactPhone {
    final fromProp = widget.contactPhone ?? widget.phoneFromContact;
    final trimmed = fromProp?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  String? get _effectiveContactEmail {
    final trimmed = widget.contactEmail?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  bool get _hideLoginPhone => _effectiveContactPhone != null;

  bool get _hideLoginEmail => _effectiveContactEmail != null;

  bool get _reusesContactDetails => _hideLoginPhone || _hideLoginEmail;

  String? resolvedLoginPhone() {
    if (!widget.createUser) return null;
    if (!_hideLoginPhone) {
      final explicit = _phoneController.text.trim();
      if (explicit.isNotEmpty) return explicit;
    }
    return _effectiveContactPhone;
  }

  String? resolvedLoginEmail() {
    if (!widget.createUser) return null;
    if (!_hideLoginEmail) {
      final explicit = _emailController.text.trim();
      if (explicit.isNotEmpty) return explicit;
    }
    return _effectiveContactEmail;
  }

  @override
  void initState() {
    super.initState();
    _ownsControllers = widget.emailController == null;
    _emailController = widget.emailController ?? TextEditingController();
    _phoneController = widget.phoneController ?? TextEditingController();
    _passwordController = widget.passwordController ?? TextEditingController();
    _confirmController = widget.confirmPasswordController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsControllers) {
      _emailController.dispose();
      _phoneController.dispose();
      _passwordController.dispose();
      _confirmController.dispose();
    }
    super.dispose();
  }

  String? validate() {
    if (!widget.createUser) return null;
    final email = resolvedLoginEmail();
    final phone = resolvedLoginPhone();
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    if ((email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
      return 'Phone or email is required for login account';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (password != confirm) {
      return 'Passwords do not match';
    }
    return null;
  }

  Map<String, String?> accountValues() => {
        'email': resolvedLoginEmail(),
        'phone': resolvedLoginPhone(),
        'password': _passwordController.text,
        'password_confirmation': _confirmController.text,
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Create login account'),
          subtitle: Text(
            _reusesContactDetails && widget.createUser
                ? 'Uses contact details above for login'
                : 'Customer can sign in with email or phone',
          ),
          value: widget.createUser,
          onChanged: widget.onCreateUserChanged,
        ),
        if (widget.createUser) ...[
          if (!_hideLoginEmail)
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Login email (optional)'),
              keyboardType: TextInputType.emailAddress,
            ),
          if (!_hideLoginPhone)
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Login phone (optional)'),
              keyboardType: TextInputType.phone,
            ),
          PasswordTextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          PasswordTextField(
            controller: _confirmController,
            decoration: const InputDecoration(labelText: 'Confirm password'),
          ),
        ],
      ],
    );
  }
}

Future<void> showCreateCustomerUserSheet({
  required BuildContext context,
  required Future<void> Function({
    String? email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) onSubmit,
  String title = 'Create login account',
  String submitLabel = 'Create account',
  bool passwordOnly = false,
  String? contactPhone,
  String? contactEmail,
}) {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  var saving = false;

  final normalizedContactPhone = contactPhone?.trim();
  final normalizedContactEmail = contactEmail?.trim();
  final hideLoginPhone = normalizedContactPhone != null && normalizedContactPhone.isNotEmpty;
  final hideLoginEmail = normalizedContactEmail != null && normalizedContactEmail.isNotEmpty;

  String? resolvedEmail() {
    if (hideLoginEmail) return normalizedContactEmail;
    final explicit = emailController.text.trim();
    return explicit.isEmpty ? null : explicit;
  }

  String? resolvedPhone() {
    if (hideLoginPhone) return normalizedContactPhone;
    final explicit = phoneController.text.trim();
    return explicit.isEmpty ? null : explicit;
  }

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          Future<void> submit() async {
            final email = resolvedEmail();
            final phone = resolvedPhone();
            final password = passwordController.text;
            final confirm = confirmController.text;
            if (!passwordOnly && (email == null || email.isEmpty) && (phone == null || phone.isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email or phone is required')),
              );
              return;
            }
            if (password.length < 8 || password != confirm) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Check password (min 8 chars, must match)')),
              );
              return;
            }
            setState(() => saving = true);
            try {
              await onSubmit(
                email: email,
                phone: phone,
                password: password,
                passwordConfirmation: confirm,
              );
              if (context.mounted) Navigator.pop(context);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
              }
            } finally {
              if (context.mounted) setState(() => saving = false);
            }
          }

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                if (!passwordOnly) ...[
                  if (hideLoginPhone || hideLoginEmail)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Uses the customer contact details for login',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  if (!hideLoginEmail)
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Login email (optional)'),
                    ),
                  if (!hideLoginPhone)
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Login phone (optional)'),
                    ),
                ],
                PasswordTextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                PasswordTextField(
                  controller: confirmController,
                  decoration: const InputDecoration(labelText: 'Confirm password'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: saving ? null : submit,
                  child: saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(submitLabel),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
