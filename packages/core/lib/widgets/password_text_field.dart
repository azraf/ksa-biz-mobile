import 'package:flutter/material.dart';

/// Password field with a show/hide visibility toggle.
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.decoration,
    this.readOnly = false,
    this.validator,
    this.onSaved,
    this.autofillHints,
    this.textInputAction,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final InputDecoration? decoration;
  final bool readOnly;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  late final TextEditingController _controller;
  late final bool _ownsController;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      obscureText: _obscure,
      readOnly: widget.readOnly,
      validator: widget.validator,
      onSaved: widget.onSaved,
      autofillHints: widget.autofillHints ?? const [AutofillHints.password],
      textInputAction: widget.textInputAction,
      decoration: (widget.decoration ?? const InputDecoration()).copyWith(
        suffixIcon: IconButton(
          tooltip: _obscure ? 'Show password' : 'Hide password',
          onPressed: widget.readOnly
              ? null
              : () => setState(() => _obscure = !_obscure),
          icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        ),
      ),
    );
  }
}
