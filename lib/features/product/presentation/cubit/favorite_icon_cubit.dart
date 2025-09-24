import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/features/product/domain/usecases/get_favorties_products.dart';
import '../../../../service_locator.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/add_or_remove_favorite_product.dart';
import '../../domain/usecases/is_favorite.dart';

class FavoriteIconCubit extends Cubit<bool> {
  FavoriteIconCubit() : super(false);

  //show favorites
  Future<void> displayProducts({dynamic params}) async {
    final returnedData = await sl<GetFavortiesProductsUseCase>().call();
    // var returnedData = await useCase.call(params: params);
    returnedData.fold(
      (error) {
        print('❌ Erreur lors de recuperer des favoris: $error');
      },
      (data) {
        print('✅ Produits Favorites : $returnedData ');
        print('✅ Produits Favorites1 : $data ');
        emit(data);
      },
    );
  }

  // Vérifie si le produit est dans les favoris
  Future<void> checkFavoriteStatus(String productId) async {
    try {
      final isFav = await sl<IsFavoriteUseCase>().call(params: productId);
      emit(isFav);
    } catch (e) {
      emit(false); // En cas d'erreur, considérer comme non favori
    }
  }

  // Basculer l'état favori
  Future<void> toggleFavorite(ProductEntity product) async {
    print("🔄 Tentative d'ajout/suppression du produit ${product.pId}");
    final result = await sl<AddOrRemoveFavoriteProductUseCase>().call(
      params: product,
    );

    result.fold(
      (error) {
        print('❌ Erreur lors de l\'ajout/suppression des favoris: $error');
      },
      (isFavorite) {
        print(
          '✅ Produit ${product.pId} ajouté/supprimé avec succès : $isFavorite',
        );
        emit(isFavorite);
      },
    );
  }
}
