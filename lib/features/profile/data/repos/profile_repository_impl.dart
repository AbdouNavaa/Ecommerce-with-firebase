// data/repositories/profile_repository_impl.dart
import '../../../auth/data/models/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../sources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserModel> getUserProfile() {
    return remoteDataSource.getUserProfile();
  }
}
