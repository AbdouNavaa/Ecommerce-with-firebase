import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../common/bloc/button/button_state.dart';
import '../../../../common/bloc/button/button_state_cubit.dart';
import '../../../../common/navigator/app_navigator.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/button/basic_reactive_button.dart';
import '../../../../core/constants.dart';
import '../../../admin/presentation/pages/adminHome.dart';
import '../../data/models/user_signin_req.dart';
import '../../domain/usecases/signin.dart';
import 'signup_screen.dart';
import '../../../home/homePage.dart';

class SigninPage extends StatelessWidget {
  SigninPage({super.key});

  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(hideBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 60),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.redAccent,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }

              if (state is ButtonSuccessState) {
                //check if admin
                if (state.user!['isAdmin']) {
                  AppNavigator.pushAndRemove(context, AdminHome());
                } else {
                  AppNavigator.pushAndRemove(context, HomePage());
                }

                // AppNavigator.pushAndRemove(context, HomePage());
              }
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _siginText(context),
                  const SizedBox(height: 50),
                  _emailField(context),
                  const SizedBox(height: 30),
                  _passwordField(context),
                  const SizedBox(height: 30),
                  _forgotPasswordOrSignup(context, 'Forgot password? ', () {
                    // AppNavigator.push(context, ForgotPasswordPage());
                  }, 'Reset'),
                  const SizedBox(height: 40),
                  _continueButton(context),
                  const SizedBox(height: 30),
                  _forgotPasswordOrSignup(context, 'Sign up', () {
                    AppNavigator.push(context, SignupScreen());
                  }, 'Create One'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _siginText(BuildContext context) {
    return const Text(
      'Sign in',
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _emailCon,
      decoration: const InputDecoration(
        hintText: 'Enter Email',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black12, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _passwordCon,
      decoration: const InputDecoration(
        hintText: 'Enter Password',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black12, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: Colors.black12, width: 1),
        ),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            context.read<ButtonStateCubit>().execute(
              usecase: SigninUseCase(),
              params: UserSigninReq(
                email: _emailCon.text,
                password: _passwordCon.text,
              ),
            );
          },
          title: 'Sign in',
        );
      },
    );
  }

  Widget _forgotPasswordOrSignup(
    BuildContext context,
    String title,
    VoidCallback onTap,
    String text,
  ) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                color: isDark(context) ? Colors.white : Colors.black54,
              ),
            ),
            const TextSpan(text: ' '),
            TextSpan(
              text: text,
              recognizer: TapGestureRecognizer()..onTap = onTap,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark(context) ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
