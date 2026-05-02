import 'package:flutter/material.dart';
import 'package:bet/core/constants/app_colors.dart';
import 'package:bet/core/widgets/app_logo.dart';

class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(size: 32),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Title Section
              Text(
                'PORTFOLIO OVERVIEW',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryBlue,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'My Listings',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.primaryText,
                    ),
              ),
              const SizedBox(height: 24),

              // Add New Listing Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to create property
                  },
                  icon: const Icon(Icons.add_circle, color: Colors.white),
                  label: const Text(
                    'Add New Listing',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Statistics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                childAspectRatio: 1.5,
                children: [
                  _buildStatItem(
                    context,
                    label: 'Active Properties',
                    value: '13',
                    valueColor: AppColors.primaryText,
                  ),
                  _buildStatItem(
                    context,
                    label: 'Total Bids',
                    value: '48',
                    valueColor: const Color(0xFF00684A), // Success Dark color from design
                  ),
                  _buildStatItem(
                    context,
                    label: 'Views (30d)',
                    value: '2.4k',
                    valueColor: AppColors.primaryText,
                  ),
                  _buildStatItem(
                    context,
                    label: 'Conversion',
                    value: '8.2%',
                    valueColor: AppColors.primaryBlue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar included here to match the design without altering global router
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: 0,
            onTap: (index) {},
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primaryBlue,
            unselectedItemColor: AppColors.secondaryText.withOpacity(0.6),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.business_outlined),
                activeIcon: Icon(Icons.business),
                label: 'Listings',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.gavel_outlined),
                activeIcon: Icon(Icons.gavel),
                label: 'Bids',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {required String label, required String value, required Color valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.secondaryText,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
