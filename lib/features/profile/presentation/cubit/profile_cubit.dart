// presentation/blocs/profile_bloc.dart
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfile getUserProfile;

  ProfileCubit(this.getUserProfile) : super(ProfileInitial());

  void loadUser() async {
    emit(ProfileLoading());
    try {
      final user = await getUserProfile();
      debugPrint("User loaded: ${user.firstName}, Email: ${user.email}");
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileError("Erreur lors du chargement du profil"));
    }
  }
}
