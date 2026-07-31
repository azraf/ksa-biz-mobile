import 'package:flutter/material.dart';

enum FieldType { text, number, email, password, textarea, boolean, date, dropdown }

class FieldConfig {
  const FieldConfig({
    required this.key,
    required this.label,
    this.type = FieldType.text,
    this.required = false,
    this.options,
    this.readOnly = false,
  });

  final String key;
  final String label;
  final FieldType type;
  final bool required;
  final List<DropdownOption>? options;
  final bool readOnly;
}

class DropdownOption {
  const DropdownOption({required this.value, required this.label});

  final dynamic value;
  final String label;
}
