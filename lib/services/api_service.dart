import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/cart_api_model.dart';
import '../utils/constants.dart';

class ApiService {
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await client.get(Uri.parse('${Constants.baseUrl}/products'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<CartApiResponse> fetchCart(int cartId) async {
    try {
      final response = await client.get(Uri.parse('${Constants.baseUrl}/carts/$cartId'));
      if (response.statusCode == 200) {
        return CartApiResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load cart: $e');
    }
  }
}
