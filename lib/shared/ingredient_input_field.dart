import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';



class IngredientInputField extends StatelessWidget {
  final String? hintText;
  final String? initialValue;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onFieldChanged;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextStyle? style;
  final Function(IngredientInputField)? onDelete;
  final Function? preDelete;
  int? indexInList;

  IngredientInputField({
    Key? key,
    this.hintText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.maxLength,
    this.maxLines,
    this.keyboardType,
    this.controller,
    this.initialValue,
    this.style,
    this.onFieldChanged,
    this.onDelete,
    this.indexInList,
    this.preDelete
  }) : super(key: key);

  bool _isObscureText = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //var formList = Provider.of<AppData>(context).ingredientsFormList;
    //var ingredientsList = Provider.of<AppData>(context).ingredientsList;

    return Container(
      margin: EdgeInsets.only(bottom: 8.0, left: 8, right: 8, top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 260,
            child: Form(
              key: _formKey,
              child: TextFormField(
                // initialValue: initialValue,
                controller: controller,
                onSaved: (value) {
                  //menuItemName = value;
                  //Provider.of<AppData>(context, listen: false).addToIngredientListWithIndex(indexInList, value);
                },
                validator: _validateValue,
                decoration: InputDecoration(
                  labelText: 'Ingredient ${indexInList! + 1}',
                  hintText: 'E.g Tomatoes',
                  //suffixIcon: Icon(Icons.delete_rounded)
                ),
              ),
            ),
          ),

          InkWell(
            onTap: () {
              onDelete!(this);
            },
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  //color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kPrimaryColor)
                ),
                child: Icon(Icons.delete_rounded, color: Colors.grey,)),
          )
        ],
      ),
    );
  }

  String? _validateValue(String? text) {
    if(text!.isEmpty) {
      return 'This field is empty.';
    }
    return null;
  }
}