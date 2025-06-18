import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import 'button_state.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  Future<void> execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonLoadingState());
    try {
      Either returnedData = await usecase.call(params: params);
      returnedData.fold(
        (error) {
          emit(ButtonFailureState(errorMessage: error));
        },
        (data) {
          if (data is String) {
            // Si data est une simple chaîne, émet l'état sans user
            emit(ButtonSuccessState(successMessage: data));
          } else if (data is Map<String, dynamic>) {
            // Si data a un user, émet l'état avec le user
            emit(ButtonSuccessState(user: data));
          } else {
            // Dans les autres cas, émet l'état par défaut
            emit(ButtonSuccessState());
          }
        },
      );
    } catch (e) {
      emit(ButtonFailureState(errorMessage: e.toString()));
    }
  }
}
