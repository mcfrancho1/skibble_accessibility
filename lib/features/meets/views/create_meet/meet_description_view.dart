import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/validators.dart';
import '../../controllers/create_edit_meets_controller.dart';

class MeetDescriptionView extends StatefulWidget {
  const MeetDescriptionView({Key? key}) : super(key: key);

  @override
  State<MeetDescriptionView> createState() => _MeetDescriptionViewState();
}

class _MeetDescriptionViewState extends State<MeetDescriptionView> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = context.read<CreateEditMeetsController>().meetDescription;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Consumer<CreateEditMeetsController>(
        builder: (context, data, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'What is the meet about?',
                style: TextStyle(
                    color: kDarkSecondaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
              ),

              SizedBox(height: 15,),
              Text(
                'Provide a short description for this meet. For example, you can add some of the topics you want to talk about.',
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13
                ),


              ),

              SizedBox(height: 15,),

              Text(
                'Description',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14
                ),
              ),
              SizedBox(height: 6,),


              TextFormField(
                // initialValue: data.inviteTitle,
                keyboardType: TextInputType.text,
                controller: controller,
                onSaved: (newValue) => data.meetDescription = newValue ?? '',
                maxLength: 200,
                maxLines: 5,
                onChanged: (newValue) => data.meetDescription = newValue ?? '',
                validator: (value) => Validator().validateText(value, 'Please enter a meet description'),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: Colors.grey.shade200,
                        width: 0.5
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: kPrimaryColor,
                      width: 1,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  // If  you are using latest version of flutter then label text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  // suffixIcon: Icon(Iconsax.user),
                ),

              ),


              SizedBox(height: 10,),
            ],
          );
        }
      ),
    );
  }
}