import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/common/bloc/button/button_state_cubit.dart';
import 'package:flutter_with_firebase/core/constants.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/navigator/app_navigator.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../common/widgets/button/basic_reactive_button.dart';
import '../../../../core/resources/app_strings.dart';
import '../../data/models/user_creation_req.dart';
import '../../domain/usecases/siginup.dart';
import '../../../home/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  // final UserCreationReq userCreationReq;
  static String id = 'SignupScreen';

  final TextEditingController _firstNameCon = TextEditingController();
  final TextEditingController _lastNameCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();

  // SignupScreen({super.key, required this.userCreationReq});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      // backgroundColor: kMainColor,
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              // print('###############${state.errorMessage}');
              var snackbar = SnackBar(
                content: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: isDark(context) ? Colors.white : Colors.black,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            } else if (state is ButtonSuccessState) {
              AppNavigator.pushAndRemove(context, HomePage());
            }
          },

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // CustomLogo(),
                Text(
                  context.tr(AppStrings.signUp),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                _textField(
                  context,
                  _firstNameCon,
                  context.tr(AppStrings.enterFirstName),
                ),
                const SizedBox(height: 30),
                _textField(
                  context,
                  _lastNameCon,
                  context.tr(AppStrings.enterLastName),
                ),
                const SizedBox(height: 30),
                _textField(
                  context,
                  _emailCon,
                  context.tr(AppStrings.enterEmail),
                ),
                const SizedBox(height: 30),
                _textField(
                  context,
                  _passwordCon,
                  context.tr(AppStrings.enterPassword),
                ),
                const SizedBox(height: 30),
                _finishButton(
                  context,
                  _firstNameCon.text,
                  _lastNameCon.text,
                  _emailCon.text,
                  _passwordCon.text,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(
    BuildContext context,
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(hintText: hint),
    );
  }

  Widget _finishButton(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
  ) {
    return SizedBox(
      height: 100,
      // color: AppColors.secondBackground,
      // padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Builder(
          builder: (context) {
            return BasicReactiveButton(
              onPressed: () {
                context.read<ButtonStateCubit>().execute(
                  usecase: SignupUseCase(),
                  params: UserCreationReq(
                    firstName: _firstNameCon.text,
                    email: _emailCon.text,
                    lastName: _lastNameCon.text,
                    password: _passwordCon.text,
                  ),
                );
              },
              title: context.tr(AppStrings.finish),
            );
          },
        ),
      ),
    );
  }
}
