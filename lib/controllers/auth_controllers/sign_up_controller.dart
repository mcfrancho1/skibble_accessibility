import 'package:get/get.dart';
import 'package:skibble/services/firebase/auth.dart';
import 'package:skibble/services/firebase/auth_services/skibble_auth_service.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();


  String? email;
  String? fullName;
  String? userName;
  String? password;
  String? confirmPassword;
  bool remember = false;
  String? userNameErrorText;


}