import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/authentication/views/user/user_login_page.dart';
import 'package:skibble/features/authentication/views/user/user_register_page.dart';


import '../../controllers/auth_provider.dart';
import '../shared_screens/welcome_page.dart';

class UserAuthPage extends StatefulWidget {
  const UserAuthPage({Key? key}) : super(key: key);

  @override
  State<UserAuthPage> createState() => _UserAuthPageState();
}

class _UserAuthPageState extends State<UserAuthPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<SkibbleAuthProvider>(
      builder: (context, data, child) {
        // return data.isOnSignUpPage? RegisterPage() : LoginPage();
        return data.isOnSignUpPage? const UserRegisterPage() : const LoginPage();

      }
    );
  }
}
