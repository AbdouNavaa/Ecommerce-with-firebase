// domain/usecases/get_user_profile.dart
import '../../../auth/data/models/user.dart';
import '../repositories/profile_repository.dart';

class GetUserProfile {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  Future<UserModel> call() {
    return repository.getUserProfile();
  }
}
