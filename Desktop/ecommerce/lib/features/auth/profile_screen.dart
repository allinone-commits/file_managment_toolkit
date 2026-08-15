import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ecommerce/core/theme.dart';
import '../products/controllers/product_controller.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.background),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: authState.token == null || authState.token!.isEmpty
                ? Center(
                    child: Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Welcome back',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 12),
                            const Text('Sign in to access your account, orders, and saved items.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textSecondary, height: 1.5)),
                            const SizedBox(height: 28),
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed('/login'),
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, color: AppColors.accent, size: 22),
                          const SizedBox(width: 10),
                          Text('Profile',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Card(
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        child: Padding(
                          padding: const EdgeInsets.all(26),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: AppColors.accent,
                                child: Text('JD', style: TextStyle(color: AppColors.background, fontSize: 28, fontWeight: FontWeight.bold)),
                              ),
                              const SizedBox(height: 20),
                              Text('Welcome back',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              Text(authState.username ?? 'Jane Doe',
                                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              const SizedBox(height: 18),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: AppColors.accentSoft,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.check_circle, color: AppColors.accent, size: 20),
                                    SizedBox(width: 8),
                                    Text('Authenticated',
                                        style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Logged in and ready to explore products. Your account is secure and ready.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListView(
                          children: const [
                            _ProfileActionTile(icon: Icons.shopping_bag_outlined, label: 'My orders'),
                            _ProfileActionTile(icon: Icons.favorite_border, label: 'Saved items'),
                            _ProfileActionTile(icon: Icons.settings_outlined, label: 'Settings'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(authProvider.notifier).logout();
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                        child: const Text('Log out'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ProfileActionTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListTile(
        leading: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: AppColors.panel,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.accent, size: 22),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
