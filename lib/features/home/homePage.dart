import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_with_firebase/core/resources/app_strings.dart';
import 'package:ionicons/ionicons.dart';

import 'package:flutter_with_firebase/common/navigator/app_navigator.dart';
import 'package:flutter_with_firebase/features/product/domain/entities/product.dart';
import 'package:flutter_with_firebase/features/product/domain/usecases/get_products.dart';
import 'package:flutter_with_firebase/features/product/presentation/cubit/get_porducts_cubit.dart';
import 'package:flutter_with_firebase/features/product/presentation/cubit/get_porducts_state.dart';
import 'package:flutter_with_firebase/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_with_firebase/features/settings/pages/settings.dart';
import 'package:flutter_with_firebase/common/widgets/product/product_card.dart';
import 'package:flutter_with_firebase/core/configs/assets/app_images.dart';
import 'package:flutter_with_firebase/services/auth.dart';
import 'package:flutter_with_firebase/widgets/custom_bottom_nav.dart';

import '../../core/constants.dart';
import '../../core/localization/app_localization.dart';

/// HomePage - Écran principal amélioré avec design moderne
class HomePage extends StatefulWidget {
  static String id = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // Services et variables d'état
  final Auth _authService = Auth();
  User? _currentUser;
  int _selectedBottomNavIndex = 0;
  late TabController _tabController;

  // Catégories de produits avec design amélioré
  List<ProductCategory> get _productCategories => [
    ProductCategory(
      name: context.tr(AppStrings.jackets),
      filter: 'jackets',
      icon: Ionicons.shirt_outline,
    ),
    ProductCategory(
      name: context.tr(AppStrings.trousers),
      filter: 'trousers',
      icon: Ionicons.accessibility_outline,
    ),
    ProductCategory(
      name: context.tr(AppStrings.tShirts),
      filter: 'tshirts',
      icon: Ionicons.man_outline,
    ),
    ProductCategory(
      name: context.tr(AppStrings.shoes),
      filter: 'shoes',
      icon: Ionicons.footsteps_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getUser();
      if (mounted) setState(() => _currentUser = user);
    } catch (error) {
      if (mounted) AppNavigator.pushAndRemove(context, SigninPage());
    }
  }

  Future<void> _handleLogout() async {
    try {
      await _authService.signOut();
      if (mounted) AppNavigator.pushAndRemove(context, SigninPage());
    } catch (error) {
      _showErrorSnackBar(context.tr(AppStrings.logoutError));
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => ProductCubit(GetProductsUseCase())..loadProducts(),
      child: Scaffold(
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          _buildEnhancedAppBar(),
          _buildTabBarSection(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  Widget _buildEnhancedAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _buildProfileImageEnhanced(),
          const SizedBox(width: 16),
          Expanded(child: _buildTitleSection()),
          _buildLogoutButtonEnhanced(),
        ],
      ),
    );
  }

  Widget _buildProfileImageEnhanced() {
    return GestureDetector(
      onTap: () => AppNavigator.push(context, const SettingsPage()),
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(AppImages.profile),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back!',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Text(
          context.tr(AppStrings.discover),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButtonEnhanced() {
    return GestureDetector(
      onTap: _handleLogout,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
          border: Border.all(
            color: Theme.of(context).colorScheme.error.withOpacity(0.2),
          ),
        ),
        child: Icon(
          Ionicons.log_out_outline,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTabBarSection() {
    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        border: Border.all(
          color: themeColors(context, Colors.white24, Colors.black12),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.primary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        // indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
        labelPadding: EdgeInsets.symmetric(horizontal: 16),
        unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        tabs:
            _productCategories
                .map((category) => _buildEnhancedTab(category))
                .toList(),
      ),
    );
  }

  Widget _buildEnhancedTab(ProductCategory category) {
    return Tab(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(category.icon, size: 16),
          const SizedBox(width: 4),
          Flexible(child: Text(category.name, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children:
          _productCategories
              .map((category) => _buildCategoryView(category))
              .toList(),
    );
  }

  Widget _buildCategoryView(ProductCategory category) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => _buildLoadingView(),
          ProductLoaded() => _buildProductGrid(state.products, category.filter),
          ProductError() => _buildErrorView(state.message),
          _ => _buildEmptyView(),
        };
      },
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          Text('Loading...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildProductGrid(
    List<ProductEntity> products,
    String categoryFilter,
  ) {
    final filteredProducts =
        products
            .where((product) => product.pCategory == categoryFilter)
            .toList();

    if (filteredProducts.isEmpty) return _buildEmptyView();

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 20,
      ),
      itemCount: filteredProducts.length,
      itemBuilder:
          (context, index) =>
              ProductCard(productEntity: filteredProducts[index]),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.errorContainer,
              ),
              child: Icon(
                Ionicons.alert_circle_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.tr(AppStrings.errorLoading),
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<ProductCubit>().loadProducts(),
              icon: const Icon(Ionicons.refresh_outline),
              label: Text(context.tr(AppStrings.retry)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
            ),
            child: Icon(
              Ionicons.bag_outline,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            context.tr(AppStrings.noProductsFound),
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr(AppStrings.checkConnection),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CustomBottomNav(
      currentIndex: _selectedBottomNavIndex,
      onTap: (index) => setState(() => _selectedBottomNavIndex = index),
      isAdmin: false,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

/// Modèle amélioré pour les catégories de produits
class ProductCategory {
  final String name;
  final String filter;
  final IconData icon;
  // final LinearGradient gradient;

  const ProductCategory({
    required this.name,
    required this.filter,
    required this.icon,
    // required this.gradient,
  });
}
