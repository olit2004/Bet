import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:bet/core/property/providers/property_provider.dart';
import 'package:bet/features/buyer/presentation/widgets/property_card.dart';
import 'package:bet/features/buyer/presentation/widgets/search_bar.dart';

import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/core/providers/navigation_provider.dart';
import 'package:bet/features/notification/presentation/widgets/notification_bell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:bet/features/auth/application/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load properties when the screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PropertyProvider>().loadProperties();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const AppLogo(size: 20, isClickable: false),
        actions: [
          const NotificationBell(),
          const SizedBox(width: 8),
          riverpod.Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(authNotifierProvider).user;
              return GestureDetector(
                onTap: () => context.read<NavigationProvider>().setIndex(2),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.inputFill,
                  backgroundImage: (user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty)
                      ? NetworkImage('http://localhost:8080${user.avatarUrl}') as ImageProvider
                      : null,
                  child: (user?.avatarUrl == null || user!.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 24, color: Colors.grey)
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryBlue,
          onRefresh: () => context.read<PropertyProvider>().loadProperties(),
          child: CustomScrollView(
            slivers: [
              // 1. Greeting Banner (Hey message!)
              // 1. Search and Categories Section
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: PropertySearchBar(),
                ),
              ),
              
              // 3. Properties List
              Consumer<PropertyProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading && provider.properties.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primaryBlue),
                      ),
                    );
                  }

                  if (provider.errorMessage != null && provider.properties.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                            const SizedBox(height: 16),
                            Text(provider.errorMessage!),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => provider.loadProperties(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (provider.properties.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: AppColors.secondaryText.withValues(alpha: 0.3)),
                            const SizedBox(height: 16),
                            Text(
                              'No properties found',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final property = provider.properties[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: PropertyCard(
                              property: property,
                              onTap: () {
                                context.pushNamed(
                                  'property-detail',
                                  pathParameters: {'id': property.id},
                                  extra: property,
                                );
                              },
                            ),
                          );
                        },
                        childCount: provider.properties.length,
                      ),
                    ),
                  );
                },
              ),
              // Bottom spacing
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}
