import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';

class TextFieldHelper {
  Function? fun;
  String? val;
  String? hint;
  TextEditingController? _controller;
  TextInputType? type;
  bool? updateAtEveryStrok;
  TextFieldHelper({
    Function? fun,
    String? val,
    TextInputType? type,
    String? hint,
    bool w = false,
  }) {
    this.fun = fun;
    this.val = val;
    this.type = type;
    this.hint = hint;
    this.updateAtEveryStrok = w;
    _controller = TextEditingController(text: this.val);
  }
  build() {
    return Fieldcover(
      child: FocusScope(
        onFocusChange: (value) {
          if (!value) {
            this.fun!(_controller!.value.text);
          }
        },
        child: TextFormField(
          onChanged: (val) {
            if (this.updateAtEveryStrok == true) {
              this.fun!(_controller!.value.text);
            }
          },
          onEditingComplete: () {
            this.fun!(_controller!.value.text);
          },
          keyboardType: this.type,
          validator: RequiredValidator(errorText: 'this field is required'),
          controller: _controller,
          decoration: InputDecoration(
            hintText: this.hint,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
