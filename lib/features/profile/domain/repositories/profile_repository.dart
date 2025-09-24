// domain/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';

import '../../../auth/data/models/user.dart';

abstract class ProfileRepository {
  Future<UserModel> getUserProfile();
}
