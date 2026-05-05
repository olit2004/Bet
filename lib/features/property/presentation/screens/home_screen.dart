import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../widgets/search_bar.dart';
import '../../property_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_logo.dart';

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
        title: const AppLogo(size: 20),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.inputFill,
            child: ClipOval(
              child: Image.asset(
                'assets/images/avater.png',
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: AppColors.secondaryText),
              ),
            ),
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.inputFill),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hey message!',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryText,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Mohamed and the Devs, here you see your business and real estate listing status here.',
                                style: GoogleFonts.inter(
                                  color: AppColors.secondaryText,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.close, size: 18, color: AppColors.secondaryText),
                          onPressed: () {
                            // Logic to hide banner
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // 2. Search and Categories Section
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
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
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PropertyCard(
                              property: property,
                              onTap: () {
                                context.push(PropertyRoutes.detail, extra: property);
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.secondaryText.withValues(alpha: 0.5),
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded), 
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline_rounded), 
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded), 
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded), 
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
