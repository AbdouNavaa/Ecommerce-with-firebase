import '../../../../core/usecase/usecase.dart';
import '../../../../service_locator.dart';
import '../repository/product.dart';

class IsFavoriteUseCase implements UseCase<bool, String> {
  @override
  Future<bool> call({String? params}) async {
    return await sl<ProductRepository>().isFavorite(params!);
  }
}
