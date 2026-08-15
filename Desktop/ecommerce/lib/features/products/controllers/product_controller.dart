import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../data/product_repository.dart';
import '../models/product_model.dart';

final apiClientProvider = Provider((ref) => ApiClient());
final productRepositoryProvider = Provider((ref) => ProductRepository(client: ref.read(apiClientProvider)));

final productsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.fetchAllProducts();
});

final categoriesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final repo = ref.read(productRepositoryProvider);
  return repo.fetchCategories();
});

class FavoritesNotifier extends StateNotifier<Set<int>> {
  FavoritesNotifier() : super({});

  void toggle(int productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state}..add(productId);
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) => FavoritesNotifier());

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void add(Product product) {
    state = [...state, product];
  }

  void remove(int productId) {
    state = state.where((item) => item.id != productId).toList();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) => CartNotifier());
final cartCountProvider = Provider<int>((ref) => ref.watch(cartProvider).length);

class AuthState {
  final String? token;
  final String? username;
  final bool isLoading;
  final String? error;

  const AuthState({this.token, this.username, this.isLoading = false, this.error});

  AuthState copyWith({String? token, String? username, bool? isLoading, String? error}) {
    return AuthState(
      token: token ?? this.token,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState());

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _ref.read(apiClientProvider).post('/auth/login', body: {
        'username': username,
        'password': password,
      });
      final token = response is Map<String, dynamic> ? response['token']?.toString() ?? '' : '';
      if (token.isEmpty) {
        throw Exception('Login failed');
      }
      state = state.copyWith(token: token, username: username, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
