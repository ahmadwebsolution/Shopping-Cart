import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shoppping/models/product.dart';
import 'package:shoppping/providers/cart_provider.dart';
import 'package:shoppping/providers/wishlist_provider.dart';
import 'package:shoppping/screens/product_detail_screen.dart';

void main() {
  testWidgets('ProductDetailScreen displays product details and adds to cart',
      (WidgetTester tester) async {
    final testProduct = Product(
      id: 1,
      title: 'Test Jacket',
      price: 99.99,
      description: 'A warm and stylish jacket.',
      category: 'clothing',
      image: 'https://example.com/jacket.png',
      ratingRate: 4.5,
      ratingCount: 20,
    );

    final cartProvider = CartProvider();
    final wishlistProvider = WishlistProvider();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: cartProvider),
          ChangeNotifierProvider.value(value: wishlistProvider),
        ],
        child: MaterialApp(
          home: ProductDetailScreen(product: testProduct),
        ),
      ),
    );

    // Verify product information is displayed
    expect(find.text('Test Jacket'), findsOneWidget);
    expect(find.text('\$99.99'), findsOneWidget);
    expect(find.text('A warm and stylish jacket.'), findsOneWidget);
    expect(find.text('CLOTHING'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);

    // Test quantity stepper
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    // Test Add to Cart action
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pump();

    expect(cartProvider.itemCount, equals(2));
  });
}
