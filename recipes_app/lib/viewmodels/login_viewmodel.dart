import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/authentication_service.dart';
import '../static/helper_functions.dart';

class LoginViewModel extends GetxController {
  bool _loading = false;

  bool get loading => _loading;

  @override
  void onInit() {
    _loading = true;
    super.onInit();
    _loading = false;
  }

  logIn(emailController, passwordController, context) async {
    if (emailController.text.trim() == '') {
      showErrorMessage("fill_email".tr, context);
      return;
    }

    if (passwordController.text.trim() == '') {
      showErrorMessage("fill_password".tr, context);
      return;
    }

    try {
      await AuthenticationService().loginWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      showErrorMessage(e.message.toString(), context);
    }
  }
}
