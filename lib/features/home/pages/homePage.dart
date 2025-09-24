import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_with_firebase/core/resources/app_strings.dart';
import 'package:flutter_with_firebase/features/home/widgets/empty_view.dart';
import 'package:flutter_with_firebase/features/home/widgets/error_view.dart';
import 'package:flutter_with_firebase/features/home/widgets/loading_view.dart';
import 'package:flutter_with_firebase/features/home/widgets/product_grid.dart';
import 'package:flutter_with_firebase/features/home/widgets/title_section.dart';
import 'package:ionicons/ionicons.dart';

import 'package:flutter_with_firebase/common/navigator/app_navigator.dart';
import 'package:flutter_with_firebase/features/product/domain/usecases/get_products.dart';
import 'package:flutter_with_firebase/features/product/presentation/cubit/get_porducts_cubit.dart';
import 'package:flutter_with_firebase/features/product/presentation/cubit/get_porducts_state.dart';
import 'package:flutter_with_firebase/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_with_firebase/features/settings/pages/settings.dart';
import 'package:flutter_with_firebase/core/configs/assets/app_images.dart';
import 'package:flutter_with_firebase/services/auth.dart';
import 'package:flutter_with_firebase/widgets/custom_bottom_nav.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants.dart';
import '../../../core/localization/app_localization.dart';

/// HomePage - Écran principal amélioré avec design moderne
class HomePage extends StatefulWidget {
  static String id = 'HomePage';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  // Services et variables d'état
  final Auth _authService = Auth();
  User? _currentUser;
  int _selectedBottomNavIndex = 0;
  late TabController _tabController;

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
    // super.build(context);
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Expanded(child: TitleSection(context: context)),
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
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          ProductLoaded() => Container(
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
                borderRadius: BorderRadius.circular(2),
                color: AppColors.secondBackground,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              // indicatorPadding: EdgeInsets.symmetric(horizontal: 16),
              labelPadding: EdgeInsets.symmetric(horizontal: 16),
              unselectedLabelColor:
                  Theme.of(context).textTheme.bodyMedium?.color,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              tabs:
                  state.products
                      .map((e) => e.pCategory)
                      .whereType<
                        String
                      >() // s'assurer que ce sont bien des String non null
                      .toSet() // éliminer les doublons
                      .toList()
                      .map((category) => _buildEnhancedTab(category))
                      .toList(),
            ),
          ),

          ProductError() => Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          // TODO: Handle this case.
          _ => Container(),
        };
      },
    );
  }

  Widget _buildEnhancedTab(String category) {
    return Tab(
      height: 50,
      child: Center(child: Text(category, overflow: TextOverflow.ellipsis)),
    );
  }

  Widget _buildTabBarView() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => Center(
            child: CircularProgressIndicator.adaptive(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          ProductLoaded() => TabBarView(
            controller: _tabController,
            children:
                state.products
                    .map((e) => e.pCategory)
                    .whereType<
                      String
                    >() // s'assurer que ce sont bien des String non null
                    .toSet() // éliminer les doublons
                    .toList()
                    .map((category) => _buildCategoryView(category))
                    .toList(),
          ),
          ProductError() => Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          // TODO: Handle this case.
          _ => Container(),
        };
      },
    );
  }

  Widget _buildCategoryView(String category) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductLoading() => LoadingView(context: context),
          ProductLoaded() => ProductGrid(
            context: context,
            products: state.products,
            categoryFilter: category,
          ),
          ProductError() => ErrorView(context: context, message: state.message),
          _ => EmptyView(context: context),
        };
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return CustomBottomNav(
      currentIndex: _selectedBottomNavIndex,
      onTap: (index) => setState(() => _selectedBottomNavIndex = index),
      isAdmin: false,
    );
  }
}
