import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../repository/auth.dart';

class SendPasswordResetEmailUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return sl<AuthRepository>().sendPasswordResetEmail(params!);
  }
}
