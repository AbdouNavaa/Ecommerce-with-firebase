import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import 'package:flutter_with_firebase/features/order/domain/entities/order.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../core/constants.dart';
import '../../../../core/constants/enums.dart';
import '../../../../core/constants/models.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../../widgets/custom_bottom_nav.dart';
import '../../../settings/bloc/orders_display_cubit.dart';
import '../../../settings/bloc/orders_display_state.dart';
import '../widgets/empty_order_view.dart';
import '../widgets/error_view.dart';
import '../widgets/order_item.dart';

/// Page de liste des commandes avec filtrage par statut
///
/// Affiche les commandes organisées par onglets selon leur statut
/// et permet de naviguer entre différents états de commande.
class OrdersListPage extends StatefulWidget {
  const OrdersListPage({super.key});

  @override
  State<OrdersListPage> createState() => _OrdersListPageState();
}

class _OrdersListPageState extends State<OrdersListPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  late TabController _tabController;
  late OrdersDisplayCubit _ordersDisplayCubit;

  // State variables
  int _currentTabIndex = 0;
  List<OrderEntity> _allOrders = [];

  @override
  void initState() {
    super.initState();
    _initializeComponents();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Initialise les composants nécessaires
  void _initializeComponents() {
    _tabController = TabController(
      length: 4, // Nombre fixe d'onglets
      vsync: this,
    );

    _tabController.addListener(_handleTabChange);
    _ordersDisplayCubit = OrdersDisplayCubit();
  }

  /// Obtient la configuration des onglets avec localisation
  List<OrderStatusTab> _getOrderStatusTabs(BuildContext context) {
    return [
      OrderStatusTab(
        title: context.tr(AppStrings.placed), // ou votre clé de localisation
        status: OrderStatus.placed,
        statusValue: 0,
        icon: Icons.receipt_outlined,
        color: Colors.orange,
      ),
      OrderStatusTab(
        title: context.tr(AppStrings.confirmed),
        status: OrderStatus.confirmed,
        statusValue: 1,
        icon: Icons.check_circle_outline,
        color: Colors.blue,
      ),
      OrderStatusTab(
        title: context.tr(AppStrings.shipped),
        status: OrderStatus.shipped,
        statusValue: 2,
        icon: Icons.local_shipping_outlined,
        color: Colors.purple,
      ),
      OrderStatusTab(
        title: context.tr(AppStrings.delivred),
        status: OrderStatus.delivered,
        statusValue: 3,
        icon: Icons.done_all,
        color: Colors.green,
      ),
    ];
  }

  /// Gère le changement d'onglet
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  /// Filtre les commandes selon le statut sélectionné
  List<OrderEntity> _getFilteredOrders(OrderStatus status) {
    final orderStatusTabs = _getOrderStatusTabs(context);
    return _allOrders.where((order) {
      final currentStatusIndex = _getCurrentOrderStatusIndex(order);
      final targetStatusIndex =
          orderStatusTabs.firstWhere((tab) => tab.status == status).statusValue;

      return currentStatusIndex == targetStatusIndex;
    }).toList();
  }

  /// Détermine l'index du statut actuel d'une commande
  int _getCurrentOrderStatusIndex(OrderEntity order) {
    if (order.orderStatus.isEmpty) return 0;

    int lastCompletedStatus = -1;
    for (int i = 0; i < order.orderStatus.length; i++) {
      if (order.orderStatus[i].done == true) {
        lastCompletedStatus = i;
      }
    }

    if (lastCompletedStatus == -1) {
      return 0; // Placed
    } else if (lastCompletedStatus == order.orderStatus.length - 1) {
      return 3; // Delivered
    } else {
      return lastCompletedStatus + 1; // Next status
    }
  }

  /// Obtient le nombre de commandes pour un statut donné
  int _getOrderCountForStatus(OrderStatus status) {
    return _getFilteredOrders(status).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: BlocProvider.value(
        value: _ordersDisplayCubit..displayOrders(),
        child: BlocBuilder<OrdersDisplayCubit, OrdersDisplayState>(
          builder: (context, state) => _buildBody(context, state),
        ),
      ),
    );
  }

  /// Construit l'AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        context.tr(AppStrings.orders), // Localisé
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
      ),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _refresh(),
          tooltip: context.tr(AppStrings.retry), // Localisé
        ),
      ],
    );
  }

  void _refresh() => _ordersDisplayCubit.displayOrders();

  /// Construit le corps de la page selon l'état
  Widget _buildBody(BuildContext context, OrdersDisplayState state) {
    return switch (state) {
      OrdersLoading() => _buildLoadingView(context),
      OrdersLoaded() => _buildOrdersView(context, state.orders),
      LoadOrdersFailure() => ErrorView(
        context: context,
        ordersDisplayCubit: _ordersDisplayCubit,
        message: state.errorMessage,
      ),
      _ => _buildEmptyView(context),
    };
  }

  /// Construit la vue de chargement
  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator.adaptive(),
          const SizedBox(height: 16),
          Text(
            context.tr(AppStrings.loadingProducts), // Localisé
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Construit la vue des commandes
  Widget _buildOrdersView(BuildContext context, List<OrderEntity> orders) {
    _allOrders = orders;

    return Column(
      children: [
        _buildTabBar(context),
        Expanded(child: _buildTabBarView(context)),
      ],
    );
  }

  /// Construit la barre des onglets
  Widget _buildTabBar(BuildContext context) {
    final orderStatusTabs = _getOrderStatusTabs(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicatorColor: themeColors(
          context,
          AppColors.primary,
          AppColors.background,
        ),
        labelColor: themeColors(context, Colors.white, Colors.black),
        unselectedLabelColor: Theme.of(context).hintColor,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: TextStyle(
          color: themeColors(context, Colors.white, Colors.black54),
          fontWeight: FontWeight.w400,
          fontSize: 13,
        ),
        labelPadding: const EdgeInsets.symmetric(vertical: 5),
        tabs: orderStatusTabs.map((tab) => _buildTab(context, tab)).toList(),
      ),
    );
  }

  /// Construit un onglet individuel
  Widget _buildTab(BuildContext context, OrderStatusTab tab) {
    final count = _getOrderCountForStatus(tab.status);

    return Tab(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, size: 16),
              const SizedBox(width: 4),
              Text(tab.title),
            ],
          ),
        ],
      ),
    );
  }

  /// Construit la vue des onglets
  Widget _buildTabBarView(BuildContext context) {
    final orderStatusTabs = _getOrderStatusTabs(context);

    return TabBarView(
      controller: _tabController,
      children:
          orderStatusTabs.map((tab) {
            final count = _getOrderCountForStatus(tab.status);
            return _buildOrdersList(context, tab.status, count);
          }).toList(),
    );
  }

  /// Construit la liste des commandes pour un statut donné
  Widget _buildOrdersList(BuildContext context, OrderStatus status, int count) {
    final filteredOrders = _getFilteredOrders(status);

    if (filteredOrders.isEmpty) {
      return EmptyOrderView(
        orderStatusTabs: _getOrderStatusTabs(context),
        context: context,
        status: status,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _ordersDisplayCubit.displayOrders();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${context.tr(AppStrings.itemsCount)} $count', // Localisé avec paramètre
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: filteredOrders.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildOrderItem(context, filteredOrders[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construit un élément de commande amélioré
  Widget _buildOrderItem(BuildContext context, OrderEntity order) {
    final currentStatusIndex = _getCurrentOrderStatusIndex(order);
    final currentTab = _getOrderStatusTabs(context)[currentStatusIndex];

    return OrderItem(
      order: order,
      currentStatusIndex: currentStatusIndex,
      currentTab: currentTab,
    );
  }

  /// Construit la vue vide
  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Text(context.tr(AppStrings.noProductsFound)), // Localisé
    );
  }
}
