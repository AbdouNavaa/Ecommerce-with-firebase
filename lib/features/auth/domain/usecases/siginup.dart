import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../../data/models/user_creation_req.dart';
import '../repository/auth.dart';

class SignupUseCase implements UseCase<Either, UserCreationReq> {
  @override
  Future<Either> call({UserCreationReq? params}) async {
    return await sl<AuthRepository>().signup(params!);
  }
}
