import 'package:catan_master/domain/players/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddEditPlayerPage extends StatelessWidget {

  final Player player;
  final GlobalKey<FormBuilderState> _formKey;

  AddEditPlayerPage(this._formKey, {this.player});

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
                initialValue: player?.name,
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
              FormBuilderRadioGroup(
                attribute: "gender",
                initialValue: player?.gender ?? Gender.male,
                options: [
                  FormBuilderFieldOption(value: Gender.male, child: Text("Male"),),
                  FormBuilderFieldOption(value: Gender.female, child: Text("Female"),),
                  FormBuilderFieldOption(value: Gender.x, child: Text("X"),),
                ],
                decoration: InputDecoration(
                    labelText: "Gender",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                ),
                validators: [
                  FormBuilderValidators.required(errorText: "Please pick a gender"),
                ],
              ),
              SizedBox(height: 16.0,),
              FormBuilderColorPicker(
                attribute: "color",
                colorPickerType: ColorPickerType.BlockPicker,
                initialValue: player?.color,
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