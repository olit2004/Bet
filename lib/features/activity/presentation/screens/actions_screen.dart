import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class ActionsScreen extends StatefulWidget {
  const ActionsScreen({super.key});

  @override
  State<ActionsScreen> createState() => _ActionsScreenState();
}

class _ActionsScreenState extends State<ActionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Actions',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryText),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // 1. Stats Grid
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _buildStatCard('12', 'ACTIVE BIDS', Colors.blue.shade50, Colors.blue),
                _buildStatCard('4', 'PAY BACK', Colors.green.shade50, Colors.green),
                _buildStatCard('ETB 4.2M', 'LOAN VALUE', Colors.purple.shade50, Colors.purple),
                _buildStatCard('7', 'PROPERTIES', Colors.orange.shade50, Colors.orange),
              ],
            ),
          ),
          
          // 2. Tab Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                labelColor: AppColors.primaryBlue,
                unselectedLabelColor: AppColors.secondaryText,
                labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13),
                unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Active Bids'),
                  Tab(text: 'History'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 3. Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityList('Active Bids'),
                _buildActivityList('History'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor.withValues(alpha: 0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(String type) {
    // Mock data for the list
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inputFill),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?ixlib=rb-1.2.1&auto=format&fit=crop&w=300&q=80',
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Elegant Apartments',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppColors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bole, Addis Ababa',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: type == 'Active Bids' ? Colors.blue.shade50 : AppColors.inputFill,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      type == 'Active Bids' ? 'Bidding' : 'Completed',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: type == 'Active Bids' ? Colors.blue : AppColors.secondaryText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ETB 15,000',
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
