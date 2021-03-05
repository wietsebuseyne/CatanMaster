import 'package:catan_master/domain/players/player.dart';
import 'package:catan_master/presentation/core/widgets/catan_decorator.dart';
import 'package:catan_master/presentation/core/widgets/grid_color_picker.dart';
import 'package:catan_master/presentation/players/screens/add_edit_player_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AddEditPlayerPage extends StatelessWidget {

  final Player player;
  final GlobalKey<FormState> _formKey;
  final AddEditPlayerFormData formData;

  AddEditPlayerPage(this._formKey, {@required this.formData, this.player});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                initialValue: player?.name,
                decoration: InputDecoration(
                    labelText: "Name",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))
                    )
                ),
                onSaved: (newValue) => formData.name = newValue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value?.length ?? 0) < 2 ? "Not enough letters, mi lord!" : null,
              ),
              SizedBox(height: 16.0,),
              FormField<Gender>(
                initialValue: player?.gender ?? Gender.x,
                builder: (state) {
                  return CatanDecorator(
                    label: "Gender",
                    child: Row(
                      children: [
                        Radio(value: Gender.male, groupValue: state.value, onChanged: (g) => state.didChange(g)),
                        GestureDetector(child: Text("Male"), onTap: () => state.didChange(Gender.male),),
                        Radio(value: Gender.female, groupValue: state.value, onChanged: (g) => state.didChange(g)),
                        GestureDetector(child: Text("Female"), onTap: () => state.didChange(Gender.female),),
                        Radio(value: Gender.x, groupValue: state.value, onChanged: (g) => state.didChange(g)),
                        GestureDetector(child: Text("X"), onTap: () => state.didChange(Gender.x),),
                      ],
                    ),
                  );
                },
                onSaved: (gender) {
                  return formData.gender = gender;
                },
                validator: (gender) => gender == null ? "Please pick a gender" : null,
              ),
              SizedBox(height: 16.0,),
              FormField<Color>(
                initialValue: player?.color,
                builder: (state) {
                  return CatanDecorator(
                    label: "Color",
                    errorText: state.errorText,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: GridColorPicker(
                        onSelected: (Color color) => state.didChange(color),
                        selected: state.value,
                      ),
                    )
                  );
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