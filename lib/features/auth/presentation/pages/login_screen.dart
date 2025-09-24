import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';

import '../../../../../../common/bloc/button/button_state.dart';
import '../../../../common/bloc/button/button_state_cubit.dart';
import '../../../../common/navigator/app_navigator.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/button/basic_reactive_button.dart';
import '../../../../core/constants.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../admin/presentation/pages/adminHome.dart';
import '../../data/models/user_signin_req.dart';
import '../../domain/usecases/signin.dart';
import 'signup_screen.dart';
import '../../../home/pages/homePage.dart';

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
                  _forgotPasswordOrSignup(
                    context,
                    context.tr(AppStrings.forgotPassword),
                    () {
                      // AppNavigator.push(context, ForgotPasswordPage());
                    },
                    context.tr(AppStrings.reset),
                  ),
                  const SizedBox(height: 40),
                  _continueButton(context),
                  const SizedBox(height: 30),
                  _forgotPasswordOrSignup(
                    context,
                    context.tr(AppStrings.dontHaveAccount),
                    () {
                      AppNavigator.push(context, SignupScreen());
                    },
                    context.tr(AppStrings.createOne),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _siginText(BuildContext context) {
    return Text(
      context.tr(AppStrings.signIn),
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _emailCon,
      decoration: InputDecoration(
        hintText: context.tr(AppStrings.enterEmail),
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
      obscureText: true,
      decoration: InputDecoration(
        hintText: context.tr(AppStrings.enterPassword),
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
          title: context.tr(AppStrings.signIn),
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
