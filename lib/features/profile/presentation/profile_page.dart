// presentation/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/features/product/presentation/pages/FavoritesScreen.dart';
import 'package:flutter_with_firebase/features/profile/presentation/widgets/error_state.dart';
import 'package:flutter_with_firebase/features/profile/presentation/widgets/language_button.dart';
import 'package:flutter_with_firebase/features/profile/presentation/widgets/menu_item.dart';
import 'package:flutter_with_firebase/features/profile/presentation/widgets/profile_header.dart';
import 'package:flutter_with_firebase/features/profile/presentation/widgets/theme_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/helper/navigator/app_navigator.dart';
import '../../../core/constants.dart';
import '../../../core/resources/app_strings.dart';
import '../../../services/auth.dart';
import '../../auth/presentation/pages/login_screen.dart';
import '../../settings/pages/my_orders.dart';
import '../data/repos/profile_repository_impl.dart';
import '../data/sources/profile_remote_data_source.dart';
import '../domain/usecases/get_user_profile.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  final _auth = Auth();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isDark(context);

    return BlocProvider(
      create:
          (_) => ProfileCubit(
            GetUserProfile(
              ProfileRepositoryImpl(ProfileRemoteDataSourceImpl()),
            ),
          )..loadUser(),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF8FAFC),
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            print('Profile state: $state');
            return CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, isDarkMode),
                SliverToBoxAdapter(
                  child: _buildBody(context, state, isDarkMode),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          context.tr(AppStrings.profile),
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      actions: [
        LanguageButton(context: context),
        ThemeButton(context: context),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, bool isDarkMode) {
    if (state is ProfileLoading) {
      return _buildLoadingState();
    } else if (state is ProfileLoaded) {
      return _buildLoadedState(context, state.user, isDarkMode);
    } else if (state is ProfileError) {
      return ErrorState(message: state.message, isDarkMode: isDarkMode);
    }
    return const SizedBox.shrink();
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Chargement du profil...'),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    dynamic user,
    bool isDarkMode,
  ) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            ProfileHeader(context: context, user: user, isDarkMode: isDarkMode),
            const SizedBox(height: 24),
            _buildMenuSection(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, bool isDarkMode) {
    final menuItems = _getMenuItems(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              context.tr(AppStrings.shopping),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          ...menuItems
              .map((item) => MenuItem(item: item, isDarkMode: isDarkMode))
              .toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMenuItems(BuildContext context) {
    return [
      {
        'title': context.tr(AppStrings.myOrders),
        'icon': Icons.shopping_bag_outlined,
        'color': Colors.blue,
        'onTap': () => AppNavigator.push(context, const MyOrdersPage()),
      },
      {
        'title': context.tr(AppStrings.myFavorites),
        'icon': Icons.favorite_border,
        'color': Colors.red,
        'onTap': () => AppNavigator.push(context, const MyFavoritesPage()),
      },
      {
        'title': context.tr(AppStrings.myAddresses),
        'icon': Icons.location_on_outlined,
        'color': Colors.green,
        'onTap': () {
          // Navigate to addresses page
        },
      },
      {
        'title': context.tr(AppStrings.myInformations),
        'icon': Icons.info_outline,
        'color': Colors.orange,
        'onTap': () {
          // Navigate to information page
        },
      },
      {
        'title': context.tr(AppStrings.help),
        'icon': Icons.help_outline,
        'color': Colors.purple,
        'onTap': () {
          // Navigate to help page
        },
      },
      {
        'title': context.tr(AppStrings.logout),
        'icon': Icons.logout,
        'color': Colors.red,
        'onTap': () => _showLogoutDialog(context),
      },
    ];
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark(context) ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          title: Text(context.tr(AppStrings.logout)),
          content: Text(context.tr(AppStrings.logoutConfirmation)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.tr(AppStrings.cancel)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text(context.tr(AppStrings.logout)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() async {
    _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    AppNavigator.pushAndRemove(context, SigninPage());
  }
}
