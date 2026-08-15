import '../../../core/network/api_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final ApiClient client;
  ProductRepository({required this.client});

  Future<List<Product>> fetchAllProducts() async {
    final data = await client.get('/products');
    if (data is List) {
      return data.map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<List<String>> fetchCategories() async {
    final data = await client.get('/products/categories');
    if (data is List) {
      return data.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<List<Product>> fetchByCategory(String category) async {
    final data = await client.get('/products/category/$category');
    if (data is List) {
      return data.map((e) => Product.fromJson(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }
}
