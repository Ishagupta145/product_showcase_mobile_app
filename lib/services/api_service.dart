import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ApiService {
  static const String baseUrl = "https://dummyjson.com";

  // Fetch all products
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Fetch single product
  Future<Product> fetchProductById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load product details');
    }
  }

  // Fetch related products (by category)
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final response = await http.get(Uri.parse('$baseUrl/products/category/$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List products = data['products'];
      return products.map((e) => Product.fromJson(e)).toList();
    } else {
      // Fail silently for related products or return empty
      return [];
    }
  }
}