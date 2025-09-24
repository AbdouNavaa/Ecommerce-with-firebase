import 'package:dartz/dartz.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../repository/product.dart';

class GetProductsByTitleUseCase implements UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<ProductRepository>().getProductsByTitle(params!);
  }
}
