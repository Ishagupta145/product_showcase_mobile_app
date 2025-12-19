import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/product_model.dart';
import '../../services/api_service.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<Product> _productFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _productFuture = _apiService.fetchProductById(widget.productId);
  }

  void _shareProduct(Product product) {
    Share.share('Check out ${product.title} for \$${product.price} at https://dummyjson.com/products/${product.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Details")),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading product"));
          }

          final product = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Carousel (Simplified with PageView)
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: product.images.length,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: product.images[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
                Text("\$${product.price}", style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Chip(label: Text(product.category)),
                const SizedBox(height: 10),
                Text(product.description),
                const SizedBox(height: 30),
                
                // Share Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _shareProduct(product),
                    icon: const Icon(Icons.share),
                    label: const Text("Share Product"),
                  ),
                ),

                const SizedBox(height: 20),
                const Text("Related Products", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // Load Related Products
                SizedBox(
                  height: 120,
                  child: FutureBuilder<List<Product>>(
                    future: _apiService.fetchProductsByCategory(product.category),
                    builder: (context, snap) {
                      if (!snap.hasData) return const LinearProgressIndicator();
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snap.data!.length,
                        itemBuilder: (context, index) {
                          final rel = snap.data![index];
                          if (rel.id == product.id) return const SizedBox.shrink(); // Skip current
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                Expanded(child: CachedNetworkImage(imageUrl: rel.thumbnail, fit: BoxFit.cover)),
                                Text(rel.title, maxLines: 1, overflow: TextOverflow.ellipsis)
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}