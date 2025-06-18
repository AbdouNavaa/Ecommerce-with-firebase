import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/features/admin/presentation/pages/adminHome.dart';
import 'package:ionicons/ionicons.dart';

import 'package:flutter_with_firebase/features/admin/presentation/pages/addProduct.dart';
import 'package:flutter_with_firebase/features/product/presentation/pages/FavoritesScreen.dart';
import 'package:flutter_with_firebase/features/home/homePage.dart';
import 'package:flutter_with_firebase/features/cart/pages/cart.dart';
import 'package:flutter_with_firebase/features/profile/presentation/profile_page.dart';
import 'package:flutter_with_firebase/features/search/pages/search.dart';
import 'package:flutter_with_firebase/common/navigator/app_navigator.dart';
import 'package:flutter_with_firebase/services/auth.dart';

import '../core/resources/app_strings.dart';
import '../features/admin/presentation/pages/admin_orders.dart';
import '../features/admin/presentation/pages/admin_products.dart';

/// Widget de navigation inférieure personnalisé
///
/// Fournit une navigation intuitive entre les principales sections de l'application
/// avec support pour les modes utilisateur et administrateur.
class CustomBottomNav extends StatefulWidget {
  /// Index de l'onglet actuellement sélectionné
  final int currentIndex;

  /// Callback appelé lors du changement d'onglet
  final ValueChanged<int> onTap;

  /// Indique si l'utilisateur est un administrateur
  final bool isAdmin;

  /// Configuration optionnelle pour personnaliser l'apparence
  final CustomBottomNavConfig? config;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.isAdmin,
    this.config,
  });

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav>
    with TickerProviderStateMixin {
  // Services
  final Auth _authService = Auth();

  // Animation controllers
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<Color?>> _colorAnimations;

  // Configuration
  late CustomBottomNavConfig _config;

  // Navigation items
  List<BottomNavItem> _navigationItems = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeConfig();
    // Don't initialize navigation items here - wait for didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeNavigationItems();
      _initializeAnimations();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomBottomNav oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _updateSelectedIndex(widget.currentIndex);
    }
    if (oldWidget.isAdmin != widget.isAdmin) {
      _initializeNavigationItems();
      _reinitializeAnimations();
    }
  }

  /// Initialise la configuration
  void _initializeConfig() {
    _config = widget.config ?? CustomBottomNavConfig.defaultConfig();
  }

  /// Initialise les éléments de navigation selon le type d'utilisateur
  void _initializeNavigationItems() {
    _navigationItems =
        widget.isAdmin ? _getAdminNavigationItems() : _getUserNavigationItems();
  }

  /// Retourne les éléments de navigation pour un utilisateur standard
  List<BottomNavItem> _getUserNavigationItems() {
    return [
      BottomNavItem(
        index: 0,
        icon: Ionicons.home_outline,
        activeIcon: Ionicons.home,
        label: context.tr(AppStrings.home),
        destination: () => Navigator.pushNamed(context, HomePage.id),
      ),
      BottomNavItem(
        index: 1,
        icon: Ionicons.search_outline,
        activeIcon: Ionicons.search,
        label: context.tr(AppStrings.search),
        destination: () => Navigator.pushNamed(context, SearchPage.id),
      ),
      BottomNavItem(
        index: 2,
        icon: Ionicons.heart_outline,
        activeIcon: Ionicons.heart,
        label: context.tr(AppStrings.favorites),
        destination: () => Navigator.pushNamed(context, MyFavoritesPage.id),
      ),
      BottomNavItem(
        index: 3,
        icon: Ionicons.bag_outline,
        activeIcon: Ionicons.bag,
        label: 'Cart',
        destination: () => AppNavigator.push(context, const CartPage()),
      ),
      BottomNavItem(
        index: 4,
        icon: Ionicons.person_outline,
        activeIcon: Ionicons.person,
        label: context.tr(AppStrings.profile),
        destination: () => AppNavigator.push(context, const ProfilePage()),
      ),
    ];
  }

  /// Retourne les éléments de navigation pour un administrateur
  List<BottomNavItem> _getAdminNavigationItems() {
    return [
      BottomNavItem(
        index: 0,
        icon: Ionicons.home_outline,
        activeIcon: Ionicons.home,
        label: context.tr(AppStrings.home),
        destination: () => Navigator.pushNamed(context, AdminHome.id),
      ),
      BottomNavItem(
        index: 1,
        icon: Ionicons.search_outline,
        activeIcon: Ionicons.search,
        label: context.tr(AppStrings.search),

        destination: () => Navigator.pushNamed(context, SearchPage.id),
      ),
      BottomNavItem(
        index: 2,
        icon: Ionicons.cube_outline,
        activeIcon: Ionicons.cube,
        label: context.tr(AppStrings.products),
        destination:
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductsManagement()),
            ),
      ),
      BottomNavItem(
        index: 3,
        icon: Ionicons.receipt_outline,
        activeIcon: Ionicons.receipt,
        label: context.tr(AppStrings.orders),
        destination: () => AppNavigator.push(context, const OrdersListPage()),
      ),
      BottomNavItem(
        index: 4,
        icon: Ionicons.person_outline,
        activeIcon: Ionicons.person,
        label: context.tr(AppStrings.profile),
        destination: () => AppNavigator.push(context, const ProfilePage()),
      ),
    ];
  }

  /// Initialise les animations
  void _initializeAnimations() {
    if (_navigationItems.isEmpty) return;

    _animationControllers = List.generate(
      _navigationItems.length,
      (index) =>
          AnimationController(duration: _config.animationDuration, vsync: this),
    );

    _scaleAnimations =
        _animationControllers.map((controller) {
          return Tween<double>(begin: 1.0, end: _config.selectedScale).animate(
            CurvedAnimation(parent: controller, curve: _config.animationCurve),
          );
        }).toList();

    _colorAnimations =
        _animationControllers.map((controller) {
          return ColorTween(
            begin: _config.unselectedColor,
            end: _config.selectedColor,
          ).animate(
            CurvedAnimation(parent: controller, curve: _config.animationCurve),
          );
        }).toList();

    // Animer l'élément sélectionné initialement
    if (widget.currentIndex < _animationControllers.length) {
      _animationControllers[widget.currentIndex].forward();
    }
  }

  /// Réinitialise les animations lors du changement de mode (admin/user)
  void _reinitializeAnimations() {
    _disposeAnimations();
    _initializeAnimations();
  }

  /// Libère les ressources d'animation
  void _disposeAnimations() {
    if (_animationControllers.isNotEmpty) {
      for (final controller in _animationControllers) {
        controller.dispose();
      }
    }
  }

  /// Met à jour l'index sélectionné avec animation
  void _updateSelectedIndex(int newIndex) {
    if (newIndex >= 0 && newIndex < _animationControllers.length) {
      // Réinitialiser toutes les animations
      for (int i = 0; i < _animationControllers.length; i++) {
        if (i == newIndex) {
          _animationControllers[i].forward();
        } else {
          _animationControllers[i].reverse();
        }
      }
    }
  }

  /// Gère la sélection d'un onglet
  void _handleTabSelection(int index) {
    if (index == widget.currentIndex) return;

    // Feedback haptique
    HapticFeedback.lightImpact();

    // Mettre à jour les animations
    _updateSelectedIndex(index);

    // Notifier le parent
    widget.onTap(index);

    // Naviguer vers la destination
    final item = _navigationItems[index];
    item.destination();
  }

  @override
  Widget build(BuildContext context) {
    // Don't render until navigation items are initialized
    if (!_isInitialized || _navigationItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Container(
        margin: _config.margin,
        child: _buildNavigationContainer(),
      ),
    );
  }

  /// Construit le conteneur de navigation
  Widget _buildNavigationContainer() {
    return Container(
      padding: _config.padding,
      decoration: _buildContainerDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            _navigationItems.asMap().entries.map((entry) {
              return _buildNavigationItem(entry.key, entry.value);
            }).toList(),
      ),
    );
  }

  /// Construit la décoration du conteneur
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      gradient: _config.backgroundGradient,
      color: _config.backgroundColor,
      borderRadius: _config.borderRadius,
      boxShadow: _config.boxShadow,
      border: _config.border,
    );
  }

  /// Construit un élément de navigation individuel
  Widget _buildNavigationItem(int index, BottomNavItem item) {
    final isSelected = index == widget.currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleTabSelection(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _scaleAnimations[index],
            _colorAnimations[index],
          ]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimations[index].value,
              child: _buildItemContent(item, isSelected, index),
            );
          },
        ),
      ),
    );
  }

  /// Construit le contenu d'un élément
  Widget _buildItemContent(BottomNavItem item, bool isSelected, int index) {
    return Container(
      padding: _config.itemPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(item, isSelected, index),
          if (_config.showLabels) ...[
            const SizedBox(height: 4),
            _buildLabel(item, isSelected, index),
          ],
        ],
      ),
    );
  }

  /// Construit l'icône d'un élément
  Widget _buildIcon(BottomNavItem item, bool isSelected, int index) {
    return AnimatedContainer(
      duration: _config.animationDuration,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:
            isSelected
                ? _config.selectedColor.withOpacity(0.1)
                : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSelected ? item.activeIcon : item.icon,
        size: _config.iconSize,
        color: _colorAnimations[index].value,
      ),
    );
  }

  /// Construit le label d'un élément
  Widget _buildLabel(BottomNavItem item, bool isSelected, int index) {
    return Text(
      item.label,
      style: TextStyle(
        fontSize: _config.labelFontSize,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        color: _colorAnimations[index].value,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Modèle représentant un élément de navigation
class BottomNavItem {
  final int index;
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final VoidCallback destination;

  const BottomNavItem({
    required this.index,
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.destination,
  });
}

/// Configuration pour personnaliser l'apparence de la barre de navigation
class CustomBottomNavConfig {
  final EdgeInsets margin;
  final EdgeInsets padding;
  final EdgeInsets itemPadding;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Gradient? backgroundGradient;
  final List<BoxShadow> boxShadow;
  final Border? border;
  final Color selectedColor;
  final Color unselectedColor;
  final double iconSize;
  final double labelFontSize;
  final double selectedScale;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showLabels;

  const CustomBottomNavConfig({
    required this.margin,
    required this.padding,
    required this.itemPadding,
    required this.borderRadius,
    required this.backgroundColor,
    this.backgroundGradient,
    required this.boxShadow,
    this.border,
    required this.selectedColor,
    required this.unselectedColor,
    required this.iconSize,
    required this.labelFontSize,
    required this.selectedScale,
    required this.animationDuration,
    required this.animationCurve,
    required this.showLabels,
  });

  /// Configuration par défaut
  factory CustomBottomNavConfig.defaultConfig() {
    return CustomBottomNavConfig(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      itemPadding: const EdgeInsets.symmetric(vertical: 8),
      borderRadius: BorderRadius.circular(20),
      backgroundColor: const Color(0xFF1A1A1A),
      backgroundGradient: LinearGradient(
        colors: [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.05),
          blurRadius: 1,
          offset: const Offset(0, 1),
        ),
      ],
      selectedColor: Colors.white,
      unselectedColor: Colors.grey.shade600,
      iconSize: 24,
      labelFontSize: 12,
      selectedScale: 1.1,
      animationDuration: const Duration(milliseconds: 200),
      animationCurve: Curves.easeInOut,
      showLabels: true,
    );
  }

  /// Configuration pour un thème minimaliste
  factory CustomBottomNavConfig.minimal() {
    return CustomBottomNavConfig(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      itemPadding: const EdgeInsets.symmetric(vertical: 4),
      borderRadius: BorderRadius.circular(16),
      backgroundColor: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
      border: Border.all(color: Colors.grey.shade200, width: 1),
      selectedColor: const Color(0xFF007AFF),
      unselectedColor: Colors.grey.shade500,
      iconSize: 22,
      labelFontSize: 11,
      selectedScale: 1.05,
      animationDuration: const Duration(milliseconds: 150),
      animationCurve: Curves.easeOut,
      showLabels: false,
    );
  }
}
