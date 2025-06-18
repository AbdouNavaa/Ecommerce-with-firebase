import 'package:flutter/material.dart';
import 'package:flutter_with_firebase/features/admin/presentation/pages/editProduct.dart';
import '../../../../services/store.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/presentation/pages/productInfo.dart';
import '../../../../core/configs/theme/app_colors.dart';

class ProductItemList extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onDelete;

  const ProductItemList({
    super.key,
    required this.product,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // elevation: ,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[100]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: _buildProductInfo(context)),
            _buildImage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.pCategory ?? 'Catégorie inconnue',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          product.pName ?? 'Nom du produit',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        _actionButton(
          label: 'Modifier',
          icon: Icons.edit_outlined,
          color: Colors.blue,
          onPressed: () => _navigateToEdit(context),
        ),
        const SizedBox(width: 8),
        _actionButton(
          label: 'Supprimer',
          icon: Icons.delete_outline,
          color: Colors.red,
          onPressed: () => _showDeleteDialog(context),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Hero(
      tag: 'product_${product.pId}',
      child: GestureDetector(
        onTap: () => _navigateToProductInfo(context),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImageWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (product.pLocation == null || product.pLocation!.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    return Image(
      image:
          product.pLocation!.startsWith('http')
              ? NetworkImage(product.pLocation!)
              : AssetImage(product.pLocation!) as ImageProvider,
      fit: BoxFit.contain,
      errorBuilder:
          (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.pushNamed(context, EditProduct.id, arguments: product);
  }

  void _navigateToProductInfo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ProductInfo(
              arguments: product,
              color: AppColors.secondBackground,
            ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmer la suppression'),
            content: Text(
              'Êtes-vous sûr de vouloir supprimer "${product.pName}" ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteProduct();
                },
                child: const Text(
                  'Supprimer',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteProduct() async {
    try {
      await Store().deleteProduct(product.pId);
      onDelete();
    } catch (e) {
      // Gérer l'erreur si nécessaire
      debugPrint('Erreur lors de la suppression: $e');
    }
  }
}
