import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];
  bool _isLoading = false;
  
  List<Product> get products => _displayedProducts;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _allProducts = await _apiService.fetchProducts();
      _displayedProducts = _allProducts;
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Client-side filtering logic
  void filterProducts({String? category, double? minPrice}) {
    _displayedProducts = _allProducts.where((product) {
      final categoryMatch = category == null || category == "All" || product.category == category;
      final priceMatch = minPrice == null || product.price >= minPrice;
      return categoryMatch && priceMatch;
    }).toList();
    notifyListeners();
  }
}