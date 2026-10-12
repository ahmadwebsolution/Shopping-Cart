class CartApiItem {
  final int productId;
  final int quantity;

  CartApiItem({required this.productId, required this.quantity});

  factory CartApiItem.fromJson(Map<String, dynamic> json) {
    return CartApiItem(
      productId: json['productId'] ?? 0,
      quantity: json['quantity'] ?? 1,
    );
  }
}

class CartApiResponse {
  final int id;
  final int userId;
  final List<CartApiItem> products;

  CartApiResponse({required this.id, required this.userId, required this.products});

  factory CartApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List? ?? [];
    List<CartApiItem> items = list.map((i) => CartApiItem.fromJson(i)).toList();
    return CartApiResponse(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      products: items,
    );
  }
}
