import 'package:flutter/material.dart';
import 'package:campus_mart/Screens/Login/components/text_field_container.dart';
import 'package:campus_mart/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool obscure;
  final Function showPass;
  final String hint;
  final FormFieldValidator<String> validatePass;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.obscure,
    this.showPass,
    this.validatePass, this.hint = 'Password',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
        child: TextFormField(
      validator: validatePass,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: kPrimaryColor,
        ),
        labelText: hint,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(20.0),
          borderSide: new BorderSide(),
        ),
        suffixIcon: InkWell(
          onTap: () {
            showPass();
          },
          child: obscure
              ? Icon(
                  Icons.visibility,
                  color: kPrimaryColor,
                )
              : Icon(
                  Icons.visibility_off,
                  color: kPrimaryColor,
                ),
        ),
      ),
    ));
  }
}
