import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/widgets/catan_input_decorator.dart';
import 'package:catan_master/presentation/core/widgets/grid_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AddEditPlayerPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final PlayerFormData formData;
  final VoidCallback? onFormChanged;

  const AddEditPlayerPage(
    this._formKey, {
    required this.formData,
    this.onFormChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: onFormChanged,
          child: Column(
            children: [
              TextFormField(
                initialValue: formData.name ?? "",
                decoration: const InputDecoration(
                  labelText: "Name",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                ),
                onSaved: (newValue) => formData.name = newValue,
                validator: (value) => (value?.length ?? 0) < 2 ? "Not enough letters, mi lord!" : null,
              ),
              const SizedBox(
                height: 16.0,
              ),
              FormField<Gender>(
                initialValue: formData.gender ?? Gender.x,
                builder: (state) {
                  return Theme(
                    //Hide InkWell ripple
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: CatanInputDecorator(
                      label: "Gender",
                      child: Row(
                        children: [
                          Radio(
                              value: Gender.male,
                              groupValue: state.value,
                              onChanged: (dynamic g) => state.didChange(g)),
                          InkWell(
                            child: const SizedBox(height: 48.0, child: Center(child: Text("Male"))),
                            onTap: () => state.didChange(Gender.male),
                          ),
                          Radio(
                              value: Gender.female,
                              groupValue: state.value,
                              onChanged: (dynamic g) => state.didChange(g)),
                          InkWell(
                            child: const SizedBox(height: 48.0, child: Center(child: Text("Female"))),
                            onTap: () => state.didChange(Gender.female),
                          ),
                          Radio(value: Gender.x, groupValue: state.value, onChanged: (dynamic g) => state.didChange(g)),
                          InkWell(
                            child: const SizedBox(
                                height: 48.0,
                                width: 24,
                                child: Align(alignment: Alignment.centerLeft, child: Text("X"))),
                            onTap: () => state.didChange(Gender.x),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                onSaved: (gender) {
                  formData.gender = gender;
                },
                validator: (gender) => gender == null ? "Please pick a gender" : null,
              ),
              const SizedBox(
                height: 16.0,
              ),
              FormField<Color>(
                initialValue: formData.color,
                builder: (state) {
                  return CatanInputDecorator(
                      label: "Color",
                      errorText: state.errorText,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: GridColorPicker(
                          onSelected: (Color color) => state.didChange(color),
                          selected: state.value,
                        ),
                      ));
                },
                onSaved: (color) => formData.color = color,
                validator: (color) => color == null ? "Please pick a color" : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerFormData {
  String? name;
  Gender? gender;
  Color? color;

  PlayerFormData({this.name, this.gender, this.color});
}
