import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../services/authentication_service.dart';
import '../static/helper_functions.dart';

class SignUpViewModel extends GetxController {
  bool _loading = false;

  bool get loading => _loading;

  @override
  void onInit() {
    _loading = true;
    super.onInit();
    _loading = false;
  }

  signUp(emailController, passwordController, confirmPasswordController,
      context) async {
    if (emailController.text.trim() == '') {
      showErrorMessage("Please fill the email field!", context);
      return;
    }

    if (passwordController.text.trim() == '') {
      showErrorMessage("Please fill the password field!", context);
      return;
    }

    if (confirmPasswordController.text.trim() == '') {
      showErrorMessage("Please fill the confirm password field!", context);
      return;
    }

    if (confirmPasswordController.text.trim() ==
        passwordController.text.trim()) {
      try {
        await AuthenticationService().signUpWithEmail(
            email: emailController.text.trim(),
            password: passwordController.text.trim());
      } on FirebaseAuthException catch (e) {
        showErrorMessage(e.message.toString(), context);
      }
    }
  }
}
