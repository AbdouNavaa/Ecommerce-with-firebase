import 'package:flutter_with_firebase/features/admin/data/datasources/dashboard_remote_data_source.dart';
import 'package:get_it/get_it.dart';

import 'features/admin/data/repositories/dashboard_repository_impl.dart';
import 'features/admin/domain/repositories/dashboard_repository.dart';
import 'features/admin/domain/usecases/get_dashboard_stats_stream.dart';
import 'features/admin/presentation/cubit/dashboard_cubit.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/data/source/auth_firebase_service.dart';
import 'features/auth/domain/repository/auth.dart';
import 'features/auth/domain/usecases/get_ages.dart';
import 'features/auth/domain/usecases/get_user.dart';
import 'features/auth/domain/usecases/is_logged_in.dart';
import 'features/auth/domain/usecases/send_password_reset_email.dart';
import 'features/auth/domain/usecases/siginup.dart';
import 'features/auth/domain/usecases/signin.dart';
import 'features/order/data/repository/order_repository_imp.dart';
import 'features/order/data/source/order_firebase_service.dart';
import 'features/order/domain/repository/order.dart';
import 'features/order/domain/usecases/add_to_cart.dart';
import 'features/order/domain/usecases/delete_order.dart';
import 'features/order/domain/usecases/get_cart_products.dart';
import 'features/order/domain/usecases/get_orders.dart';
import 'features/order/domain/usecases/get_user_orders.dart';
import 'features/order/domain/usecases/order_change_status.dart';
import 'features/order/domain/usecases/order_registration.dart';
import 'features/order/domain/usecases/remove_cart_product.dart';
import 'features/product/data/repository/product.dart';
import 'features/product/data/source/product_firebase_service.dart';
import 'features/product/domain/repository/product.dart';
import 'features/product/domain/usecases/add_or_remove_favorite_product.dart';
import 'features/product/domain/usecases/get_favorties_products.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/get_products_by_title.dart';
import 'features/product/domain/usecases/is_favorite.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services

  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());

  // sl.registerSingleton<CategoryFirebaseService>(
  //   CategoryFirebaseServiceImpl()
  // );

  sl.registerSingleton<ProductFirebaseService>(ProductFirebaseServiceImpl());

  sl.registerSingleton<OrderFirebaseService>(OrderFirebaseServiceImpl());
  // Data sources
  sl.registerSingleton<DashboardRemoteDataSource>(
    DashboardRemoteDataSourceImpl(),
  );
  // Repositories

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // sl.registerSingleton<CategoryRepository>(
  //   CategoryRepositoryImpl()
  // );

  sl.registerSingleton<ProductRepository>(ProductRepositoryImpl());

  sl.registerSingleton<OrderRepository>(OrderRepositoryImpl());
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );

  // Usecases());

  // Usecases

  sl.registerSingleton<SignupUseCase>(SignupUseCase());

  sl.registerSingleton<GetAgesUseCase>(GetAgesUseCase());

  sl.registerSingleton<SigninUseCase>(SigninUseCase());

  sl.registerSingleton<SendPasswordResetEmailUseCase>(
    SendPasswordResetEmailUseCase(),
  );

  sl.registerSingleton<IsLoggedInUseCase>(IsLoggedInUseCase());

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());

  // sl.registerSingleton<GetCategoriesUseCase>(GetCategoriesUseCase());

  sl.registerSingleton<GetProductsUseCase>(GetProductsUseCase());

  // sl.registerSingleton<GetNewInUseCase>(GetNewInUseCase());

  // sl.registerSingleton<GetProductsByCategoryIdUseCase>(
  //   GetProductsByCategoryIdUseCase(),
  // );

  sl.registerSingleton<GetProductsByTitleUseCase>(GetProductsByTitleUseCase());

  sl.registerSingleton<AddToCartUseCase>(AddToCartUseCase());

  sl.registerSingleton<GetCartProductsUseCase>(GetCartProductsUseCase());

  sl.registerSingleton<RemoveCartProductUseCase>(RemoveCartProductUseCase());

  sl.registerSingleton<OrderRegistrationUseCase>(OrderRegistrationUseCase());

  sl.registerSingleton<AddOrRemoveFavoriteProductUseCase>(
    AddOrRemoveFavoriteProductUseCase(),
  );

  sl.registerSingleton<IsFavoriteUseCase>(IsFavoriteUseCase());

  sl.registerSingleton<GetFavortiesProductsUseCase>(
    GetFavortiesProductsUseCase(),
  );

  sl.registerSingleton<GetUserOrdersUseCase>(GetUserOrdersUseCase());
  sl.registerSingleton<GetOrdersUseCase>(GetOrdersUseCase());
  sl.registerSingleton<OrderChangeStatusUseCase>(OrderChangeStatusUseCase());
  sl.registerSingleton<DeleteOrderUseCase>(DeleteOrderUseCase());

  sl.registerLazySingleton(() => GetDashboardStats(sl()));
  sl.registerLazySingleton(() => GetDashboardStatsStream(sl()));

  // Cubit
  sl.registerFactory(
    () =>
        DashboardCubit(getDashboardStats: sl(), getDashboardStatsStream: sl()),
  );
}
