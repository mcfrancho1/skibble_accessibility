import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/create_edit_meets_controller.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/validators.dart';

class MeetTitleView extends StatefulWidget {
  const MeetTitleView({Key? key}) : super(key: key);

  @override
  State<MeetTitleView> createState() => _MeetTitleViewState();
}

class _MeetTitleViewState extends State<MeetTitleView> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = context.read<CreateEditMeetsController>().meetTitle;
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Consumer<CreateEditMeetsController>(
        builder: (context, data, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Give your meet a name.',
                style: TextStyle(
                    color: kDarkSecondaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),
              ),

              const SizedBox(height: 15,),

              Text(
                'You are the one in charge! Give this awesome meet a yummy name. You can also let us suggest a name for you by clicking the icon on the right.',
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13
                ),
              ),

              const SizedBox(height: 15,),

              Text(
                'Meet Name',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14
                ),
              ),
              const SizedBox(height: 6,),


              SizedBox(
                height: 62,
                child: TextFormField(
                  // initialValue: data.inviteTi
                  keyboardType: TextInputType.text,
                  controller: controller,
                  onChanged: (newValue) => data.meetTitle = newValue ?? '',
                  onSaved: (newValue) => data.meetTitle = newValue ?? '',
                  maxLength: 50,
                  validator: (value) => Validator().validateText(value, 'Please enter a meet title'),
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
                      borderSide: const BorderSide(
                        color: kPrimaryColor,
                        width: 1,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        controller.text = data.generateRandomTitle();
                        context.read<CreateEditMeetsController>().meetTitle = controller.text;
                      },
                      child: const Icon(
                        Icons.rotate_right_rounded,

                        color: Colors.grey,
                      )
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    hintText: "${currentUser.fullName!.split(' ').first}'s Friends\' Hangout",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    // If  you are using latest version of flutter then label text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    // suffixIcon: Icon(Iconsax.user),
                  ),

                ),
              ),


              const SizedBox(height: 10,),
            ],
          );
        }
      ),
    );
  }
}