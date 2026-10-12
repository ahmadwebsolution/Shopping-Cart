import 'package:flutter/foundation.dart';
import '../models/product.dart';

class WishlistProvider extends ChangeNotifier {
  final Set<int> _wishlistProductIds = {};
  final Map<int, Product> _wishlistProducts = {};

  Set<int> get wishlistIds => _wishlistProductIds;
  List<Product> get wishlistProducts => _wishlistProducts.values.toList();

  bool isWishlisted(int productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(Product product) {
    if (_wishlistProductIds.contains(product.id)) {
      _wishlistProductIds.remove(product.id);
      _wishlistProducts.remove(product.id);
    } else {
      _wishlistProductIds.add(product.id);
      _wishlistProducts[product.id] = product;
    }
    notifyListeners();
  }
}
