import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddPlayerPage extends StatelessWidget {

  final GlobalKey<FormBuilderState> _formKey;

  AddPlayerPage(this._formKey);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: { },
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              FormBuilderTextField(
                attribute: "name",
                decoration: InputDecoration(
                    labelText: "Name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                ),
                validators: [
                  FormBuilderValidators.required(errorText: "Please enter a name"),
                ],
              ),
              SizedBox(height: 16.0,),
              FormBuilderColorPicker(
                attribute: "color",
                colorPickerType: ColorPickerType.BlockPicker,
                decoration: InputDecoration(
                    labelText: "Color",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                ),
                validators: [
                  FormBuilderValidators.required(errorText: "Please pick a color"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}