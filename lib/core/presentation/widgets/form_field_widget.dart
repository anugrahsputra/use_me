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
    this.fillColor,
    this.suffixIcon,
    this.borderRadius,
    this.autofocus = false,
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
  final Color? fillColor;

  // Ignored when isPassword is set. That slot holds the obscure toggle.
  final Widget? suffixIcon;
  final double? borderRadius;
  final bool autofocus;

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

  // Null hands the border back to the input theme. A pinned radius rebuilds
  // every state's border so they all share it.
  OutlineInputBorder? _border(Color color, {double width = 1}) {
    final radius = widget.borderRadius;
    if (radius == null) return null;
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextFormField(
      initialValue: widget.initialValue,
      autofocus: widget.autofocus,
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
        fillColor: widget.fillColor,
        border: _border(scheme.outline),
        enabledBorder: _border(scheme.outline),
        focusedBorder: _border(scheme.primary, width: 2),
        errorBorder: _border(scheme.error),
        focusedErrorBorder: _border(scheme.error, width: 2),
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_off : Icons.visibility,
                  size: 24,
                  color: scheme.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : widget.suffixIcon,
      ),
    );
  }
}
