import 'package:flutter/material.dart';


import '../../../../../utils/constants.dart';
import '../../../../services/firebase/auth.dart';
import '../../controllers/auth_controller.dart';


class UpdateEmailAddressView extends StatefulWidget {
  const UpdateEmailAddressView({Key? key}) : super(key: key);

  @override
  State<UpdateEmailAddressView> createState() => _UpdateEmailAddressViewState();
}

class _UpdateEmailAddressViewState extends State<UpdateEmailAddressView> {

  TextEditingController emailController = TextEditingController();

  late final AuthService authService;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    authService = AuthService();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(
      //   title: 'Change Email Address',
      //   centerTitle: true,
      // ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // shrinkWrap: true,
                children: [

                  const Text(
                    'Change Email Address',
                    style: TextStyle(color: kDarkSecondaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                        // fontFamily: 'Brand Regular'
                    ),
                  ),

                  SizedBox(height: 10,),

                  const Text(
                    'Enter a new email address and we will resend you an email verification link.',
                    style: TextStyle(color: Colors.grey,
                        fontSize: 15,
                        // fontFamily: 'Brand Regular'
                    ),
                  ),
                  const SizedBox(height: 20,),

                  Form(
                    key: _formKey,
                    child: TextFormField(
                        onSaved: (value) {},
                        // validator: Validator().validateEmail,
                        //onFieldSubmitted: widget.onFieldSubmitted,
                        controller: emailController,
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                            fontFamily: 'Brand Regular',
                            fontWeight: FontWeight.w300
                        ),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 20),
                          hintText: 'e.g. hello@skibble.app',
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          labelStyle: const TextStyle(fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: kDarkSecondaryColor),
                          focusedBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                          ),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                          ),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Icon(Icons.email, ),
                          ),
                        )

                    ),
                  ),
                  const SizedBox(height: 20,),


                ],),
            ),

            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(

                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form!.validate()) {

                      var result = await AuthController().updateUserEmailAddress(emailController.text, context);

                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),

                    // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),

                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Resend link', style: TextStyle(
                          fontSize: 15,
                          color: kLightSecondaryColor
                      ),
                      ),
                      
                      Icon(Icons.chevron_right_rounded)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
