import 'package:clean_app/views/pages/sign_in.dart';
import 'package:clean_app/views/pages/sign_up.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? SignIn(
          onClickedSignUp: toggle,
        )
      : SignUp(
          onClickedSignIn: toggle,
        );
  void toggle() => setState(() => isLogin = !isLogin);
}
