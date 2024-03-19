
import 'package:flutter/material.dart';

import '../../../../../services/firebase/auth.dart';
import '../../../../../shared/custom_app_bar.dart';
import '../../../../../shared/dialogs.dart';
import '../../../../../utils/constants.dart';



class ForgotPasswordView extends StatefulWidget {
  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  TextEditingController emailController = TextEditingController();

  late final AuthService authService;

  @override
  void initState() {
    authService = AuthService();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Reset Password',
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text('Change your password', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 10,),
            const Text(
              'Enter the email address associated with your account and we will send you an email with instructions on how to reset your password.',
              style: TextStyle(color: Colors.grey,
                  fontSize: 16,
                  fontFamily: 'Brand Regular'),
            ),
            const SizedBox(height: 20,),
            const Text('Email',
                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)
            ),
            const SizedBox(height: 5),

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
                    labelStyle: const TextStyle(fontWeight: FontWeight.w300,
                        fontSize: 20,
                        color: kDarkSecondaryColor),
                    border: OutlineInputBorder(

                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(

                            color: Theme
                                .of(context)
                                .backgroundColor,
                            width: 2
                        )
                    ),
                    prefixIcon: const Padding(
                      child: Icon(Icons.email,),
                      padding: EdgeInsets.only(left: 20, right: 20),
                    ),
                  )

              ),
            ),
            const SizedBox(height: 20,),

            Center(
              child: ElevatedButton(

                onPressed: () async {
                  final form = _formKey.currentState;
                  if (form!.validate()) {

                    CustomDialog(context).showProgressDialog(context, 'Processing');

                    var result = await authService.sendPasswordResetEmail(emailController.text);

                    if(result == 'success') {
                      Navigator.pop(context);

                      CustomDialog(context).showCustomMessage('Password Link Sent', 'A password reset link was just sent to the email address provided.\n\nClick the link to reset your password.');
                    }

                    else if(result != null) {
                      Navigator.pop(context);

                      CustomDialog(context).showErrorDialog('Error', result);
                    }

                    else {
                      Navigator.pop(context);
                      CustomDialog(context).showErrorDialog('Error', 'Unable to reset your password. Please contact us at hello@skibble.app');

                    }

                  }
                  // else {
                  //   //var _auth = AuthService().getAuthObject();
                  //   try {
                  //     await _auth.sendPasswordResetEmail(
                  //         email: emailController.text);
                  //
                  //     Navigator.of(context).push(
                  //         MaterialPageRoute(builder: (context) {
                  //           return ConfirmEmailView(
                  //             email: emailController.text,);
                  //         }));
                  //   }
                  //   catch (e) {
                  //     print(e);
                  //     if (e.toString().contains('user-not-found')) {
                  //       _resetPasswordScaffoldKey.currentState.showSnackBar(
                  //           SnackBar(
                  //             backgroundColor: Colors.red,
                  //             content: Text(
                  //                 'We can\'t find this user in our records.'),
                  //             duration: Duration(seconds: 2),
                  //           ));
                  //     }
                  //     else if (e.toString().contains(
                  //         'an internal error has occurred')) {
                  //       _resetPasswordScaffoldKey.currentState.showSnackBar(
                  //           SnackBar(
                  //             backgroundColor: Colors.red,
                  //             content: Text(
                  //                 'We\'re unable to send the password reset link.'),
                  //             duration: Duration(seconds: 2),
                  //           ));
                  //     }
                  //   }
                  // }


                  // Future.delayed(Duration(seconds: 10), () {
                  //   setState(() {
                  //     showSignUPAgain = true;
                  //   });
                  // });

                },
                child: const Text(
                  'Reset password', style: TextStyle(
                    fontSize: 20,
                    color: kLightSecondaryColor
                ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),

                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 13),

                ),
              ),
            ),
          ],),
      ),
    );
  }
}
