import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};
  final ApiService _apiService = ApiService();
  bool _isLoadingCart = false;

  Map<int, CartItem> get items => _items;

  List<CartItem> get cartItems => _items.values.toList();

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  bool get isLoadingCart => _isLoadingCart;

  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  Future<void> loadRemoteCart(int cartId, List<Product> allProducts) async {
    _isLoadingCart = true;
    notifyListeners();
    try {
      final cartResponse = await _apiService.fetchCart(cartId);
      for (var cartApiItem in cartResponse.products) {
        final productMatch = allProducts.firstWhere(
          (p) => p.id == cartApiItem.productId,
          orElse: () => Product(
            id: cartApiItem.productId,
            title: 'Product #${cartApiItem.productId}',
            price: 10.0,
            description: '',
            category: '',
            image: '',
          ),
        );
        _items[productMatch.id] = CartItem(
          product: productMatch,
          quantity: cartApiItem.quantity,
        );
      }
    } catch (e) {
      debugPrint('Error loading remote cart: $e');
    } finally {
      _isLoadingCart = false;
      notifyListeners();
    }
  }

  void addToCart(Product product, {int quantity = 1}) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += quantity;
    } else {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeFromCart(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void incrementQuantity(int productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += 1;
      notifyListeners();
    }
  }

  void decrementQuantity(int productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity -= 1;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
