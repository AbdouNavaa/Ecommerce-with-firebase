import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_with_firebase/core/localization/app_localization.dart';
import '../../../../common/widgets/appbar/app_bar.dart';
import '../../../../core/constants.dart';
import '../../../../core/resources/app_strings.dart';
import '../../../product/domain/entities/product.dart';
import '../widgets/product_item_Grid.dart';
import 'addProduct.dart';
import '../../../product/presentation/cubit/get_porducts_cubit.dart';
import '../../../product/presentation/cubit/get_porducts_state.dart';
import '../widgets/product_item_list.dart';

class ProductsManagement extends StatefulWidget {
  const ProductsManagement({super.key});

  @override
  State<ProductsManagement> createState() => _ProductsManagementState();
}

class _ProductsManagementState extends State<ProductsManagement>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  // State variables
  bool _showAll = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  ProductSortOption _sortOption = ProductSortOption.name;
  bool _isGridView = false;

  // Animation controllers
  late AnimationController _fadeAnimationController;
  late AnimationController _slideAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Sample categories - replace with your actual categories
  final List<String> _categories = [
    'All',
    'Jackets',
    'Shoes',
    'T-Shirts',
    'trousers',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupSearchListener();
  }

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  void _initializeAnimations() {
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideAnimationController,
        curve: Curves.easeOutBack,
      ),
    );

    // Start animations
    _fadeAnimationController.forward();
    _slideAnimationController.forward();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      if (_searchController.text != _searchQuery) {
        setState(() {
          _searchQuery = _searchController.text;
        });
      }
    });
  }

  void _disposeResources() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _fadeAnimationController.dispose();
    _slideAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  _buildSearchAndFilters(),
                  _buildStatsCard(),
                  Expanded(child: _buildProductsList()),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return BasicAppbar(
      title: Text(
        context.tr(AppStrings.productsManagement),
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      ),
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                _isGridView ? Icons.list : Icons.grid_view,
                key: ValueKey(_isGridView),
                size: 24,
              ),
            ),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
          _buildSortButton(),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSortButton() {
    return PopupMenuButton<ProductSortOption>(
      icon: const Icon(Icons.sort, size: 24),
      tooltip: context.tr(AppStrings.sortProducts),
      onSelected: (option) {
        setState(() {
          _sortOption = option;
        });
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              value: ProductSortOption.name,
              child: Row(
                children: [
                  Icon(
                    Icons.sort_by_alpha,
                    color:
                        _sortOption == ProductSortOption.name
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Text(context.tr(AppStrings.name)),
                ],
              ),
            ),
            PopupMenuItem(
              value: ProductSortOption.price,
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    color:
                        _sortOption == ProductSortOption.price
                            ? Theme.of(context).primaryColor
                            : null,
                  ),
                  const SizedBox(width: 8),
                  Text(context.tr(AppStrings.price)),
                ],
              ),
            ),

            // PopupMenuItem(
            //   value: ProductSortOption.date,
            //   child: Row(
            //     children: [
            //       Icon(
            //         Icons.calendar_today,
            //         color:
            //             _sortOption == ProductSortOption.date
            //                 ? Theme.of(context).primaryColor
            //                 : null,
            //       ),
            //       const SizedBox(width: 8),
            //       const Text('Date Added'),
            //     ],
            //   ),
            // ),
          ],
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildCategoryFilter(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          isDark(context)
              ? BoxShadow(
                color: Colors.grey.shade900,
                blurRadius: 10,
                offset: const Offset(0, 2),
              )
              : BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xff737373),
            size: 22,
          ),
          suffixIcon:
              _searchQuery.isNotEmpty
                  ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _searchFocusNode.unfocus();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Color(0xff737373),
                      size: 20,
                    ),
                  )
                  : null,
          hintText: context.tr(AppStrings.searchProducts),
          hintStyle: const TextStyle(color: Color(0xff737373), fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor,
              checkmarkColor: Colors.white,
              elevation: isSelected ? 2 : 0,
              pressElevation: 4,
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCard() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          final totalProducts = state.products.length;
          final filteredProducts = _getFilteredProducts(state.products).length;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context.tr(AppStrings.totalProducts),
                  totalProducts.toString(),
                  Icons.inventory,
                ),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                _buildStatItem(
                  context.tr(AppStrings.filtered),
                  filteredProducts.toString(),
                  Icons.filter_list,
                ),
                Container(height: 40, width: 1, color: Colors.grey[300]),
                _buildStatItem(
                  context.tr(AppStrings.categories),
                  (_categories.length - 1).toString(),
                  Icons.category,
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildProductsList() {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildLoadingState();
        } else if (state is ProductLoaded) {
          final filteredProducts = _getFilteredProducts(state.products);

          if (filteredProducts.isEmpty) {
            return _buildEmptyState();
          }

          final List<ProductEntity> visibleProducts =
              _showAll
                  ? filteredProducts.cast<ProductEntity>()
                  : filteredProducts.take(10).toList().cast<ProductEntity>();

          return Column(
            children: [
              Expanded(
                child:
                    _isGridView
                        ? _buildGridView(visibleProducts)
                        : _buildListView(visibleProducts),
              ),
              if (filteredProducts.length > 10)
                _buildShowToggleButton(filteredProducts.length),
            ],
          );
        } else if (state is ProductError) {
          return _buildErrorState(state.message);
        } else {
          return _buildEmptyState();
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            context.tr(AppStrings.loadingProducts),
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? context.tr(AppStrings.noProductsFound)
                : context.tr(AppStrings.noProductsAvailable),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty || _selectedCategory != 'All'
                ? context.tr(AppStrings.tryAdjustingSearch)
                : context.tr(AppStrings.addFirstProduct),
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          if (_searchQuery.isEmpty && _selectedCategory == 'All') ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddProduct(),
              icon: const Icon(Icons.add),
              label: Text(context.tr(AppStrings.addProduct)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            context.tr(AppStrings.somethingWentWrong),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductCubit>().loadProducts();
            },
            icon: const Icon(Icons.refresh),
            label: Text(context.tr(AppStrings.retry)),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<ProductEntity> products) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 100 + (index * 50)),
          child: ProductItemList(
            product: products[index],
            onDelete: () => _handleProductDelete(context),
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<ProductEntity> products) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 100 + (index * 50)),
          child: ProductItemGrid(
            product: products[index],
            onDelete: () => _handleProductDelete(context),
            // isGridView: true,
          ),
        );
      },
    );
  }

  Widget _buildShowToggleButton(int totalCount) {
    final hiddenCount = totalCount - (_showAll ? totalCount : 10);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _showAll = !_showAll;
            });
          },
          icon: AnimatedRotation(
            turns: _showAll ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(Icons.expand_more),
          ),
          label: Text(
            _showAll
                ? context.tr(AppStrings.showLess)
                : '${context.tr(AppStrings.showAll)} ($hiddenCount more)',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      // backgroundColor: themeColors(context, Colors.white, Colors.black),
      backgroundColor: Colors.white,
      onPressed: _navigateToAddProduct,
      icon: const Icon(Icons.add),
      label: Text(context.tr(AppStrings.addProduct)),
      tooltip: context.tr(AppStrings.addNewProduct),
    );
  }

  List<dynamic> _getFilteredProducts(List<ProductEntity> products) {
    var filtered =
        products.where((product) {
          // Search filter
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            final name = product.pName?.toLowerCase() ?? '';
            final description = product.pDescription?.toLowerCase() ?? '';
            if (!name.contains(query) && !description.contains(query)) {
              return false;
            }
          }

          // Category filter
          if (_selectedCategory != 'All') {
            final category = product.pCategory?.toLowerCase() ?? '';
            if (category != _selectedCategory.toLowerCase()) {
              return false;
            }
          }

          return true;
        }).toList();

    // Sort products
    switch (_sortOption) {
      case ProductSortOption.name:
        filtered.sort((a, b) => (a.pName ?? '').compareTo(b.pName ?? ''));
        break;
      case ProductSortOption.price:
        filtered.sort(
          (a, b) => (num.parse(
            a.pPrice ?? '0',
          )).compareTo(num.parse(b.pPrice ?? '0')),
        );
        break;
      // case ProductSortOption.date:
      //   // Assuming there's a createdAt field in ProductEntity
      //   filtered.sort(
      //     (a, b) => ((b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now())),
      //   );
      //   break;
    }

    return filtered;
  }

  void _handleProductDelete(BuildContext context) {
    context.read<ProductCubit>().loadProducts();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text(context.tr(AppStrings.productDeleted)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _navigateToAddProduct() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));
  }
}

enum ProductSortOption { name, price }
