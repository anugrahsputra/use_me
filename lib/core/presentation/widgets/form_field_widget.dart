import 'package:flutter/material.dart';

class FormFieldWidget extends StatefulWidget {
  const FormFieldWidget({
    super.key,
    this.controller,
    this.inputAction = TextInputAction.done,
    this.initialValue,
    this.errorText,
    this.hintText,
    this.isPassword = false,
    this.prefixIcon,
    this.keyboardType,
    this.obscureInitially = true,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.onSubmit,
  });

  final TextEditingController? controller;
  final TextInputAction inputAction;
  final String? initialValue;
  final String? errorText;
  final String? hintText;
  final bool isPassword;
  final bool obscureInitially;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final void Function(String value)? onSubmit;

  @override
  State<FormFieldWidget> createState() => _DefaultFormFieldState();
}

class _DefaultFormFieldState extends State<FormFieldWidget> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureInitially;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      maxLines: widget.isPassword ? 1 : widget.maxLines,
      keyboardType: widget.keyboardType,
      textInputAction: widget.inputAction,
      obscureText: widget.isPassword ? _isObscure : false,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: (value) => widget.onSubmit?.call(value),
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
