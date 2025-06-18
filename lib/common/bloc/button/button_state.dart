import '../../../features/auth/domain/entity/user.dart';

abstract class ButtonState {}

class ButtonInitialState extends ButtonState {}

class ButtonLoadingState extends ButtonState {}

class ButtonSuccessState extends ButtonState {
  final Map<String, dynamic>? user;
  final String? successMessage;

  ButtonSuccessState({this.successMessage, this.user});
}

class ButtonFailureState extends ButtonState {
  final String errorMessage;
  ButtonFailureState({required this.errorMessage});
}
