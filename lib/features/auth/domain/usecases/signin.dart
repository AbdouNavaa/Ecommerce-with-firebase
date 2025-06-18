import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../../data/models/user_signin_req.dart';
import '../repository/auth.dart';

class SigninUseCase implements UseCase<Either, UserSigninReq> {
  @override
  Future<Either> call({UserSigninReq? params}) async {
    return sl<AuthRepository>().signin(params!);
  }
}
