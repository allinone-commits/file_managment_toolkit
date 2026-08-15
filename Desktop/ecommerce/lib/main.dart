import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/profile_screen.dart';
import 'features/products/presentation/product_list_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce Demo',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const ProductListScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
