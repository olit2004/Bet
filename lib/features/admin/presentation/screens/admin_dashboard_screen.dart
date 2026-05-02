import 'package:flutter/material.dart';
import 'package:bet/core/widgets/app_logo.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),

      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader("Global Performance", "Real-time ecosystem health"),
            const SizedBox(height: 20),

            _buildStatCard(
              "TOTAL REVENUE",
              "\$4.2M",
              "+12.5%",
              Icons.payments,
              Colors.indigo[50]!,
              Colors.indigo,
            ),
            _buildStatCard(
              "ACTIVE AUCTIONS",
              "142",
              "Hot",
              Icons.gavel,
              Colors.orange[50]!,
              Colors.orange,
            ),
            _buildStatCard(
              "PENDING VERIFICATIONS",
              "28",
              "Priority",
              Icons.verified,
              Colors.teal[50]!,
              Colors.teal,
            ),

            const SizedBox(height: 30),
            _buildSectionTitle(
              "Market Activity",
              "Last 7 days volume",
              "Weekly View",
            ),
            _buildSimpleBarChart(),

            const SizedBox(height: 30),
            _buildSectionTitle("Recent Activity", "", "LIVE", isBadge: true),
            const SizedBox(height: 10),

            // Activity List
            _buildActivityTile(
              "New Bid: \$1.2M",
              "Skyline Penthouse • 2m ago",
              "/home/ulakeb/learn/flutter/Bet/assets/images/auction.png",
              Icons.trending_up,
              Colors.green,
            ),
            _buildActivityTile(
              "Property Verified",
              "Oak Ridge Manor • 15m ago",
              "/home/ulakeb/learn/flutter/Bet/assets/images/verify.png",
              Icons.verified_user,
              Colors.blue,
            ),
            _buildActivityTile(
              "Sale Confirmed",
              "Azure Shores Villa • 42m ago",
              "/home/ulakeb/learn/flutter/Bet/assets/images/clipboard.png",
              Icons.check_circle,
              Colors.teal,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // UI COMPONENTS

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          SizedBox(width: 10),
          AppLogo(size: 30),
          const SizedBox(width: 8),
        ],
      ),
      actions: const [
        CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage(
            "/home/ulakeb/learn/flutter/Bet/assets/images/profile.png",
          ),
        ),
        SizedBox(width: 15),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B3E),
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: const Color.fromARGB(255, 73, 82, 129),
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    String badge,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 76, 90, 109),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B3E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    badge,
                    style: TextStyle(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    String actionText, {
    bool isBadge = false,
  }) {
    return Row(
      children: [
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D1B3E),
              ),
            ),

            SizedBox(height: 10),

            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 124, 139, 177),
              ),
            ),
          ],
        ),
        const Spacer(),

        isBadge
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.greenAccent[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  actionText,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              )
            : Text(
                actionText,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ],
    );
  }

  Widget _buildSimpleBarChart() {
    // This creates a simple visual bar chart using Containers
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 154, 177, 240)!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _bar(40),
          _bar(70),
          _bar(50),
          _bar(90),
          _bar(60),
          _bar(100),
          _bar(110),
        ],
      ),
    );
  }

  Widget _bar(double height) {
    double maxHeight = 200;
    double opacity = height / maxHeight;

    opacity = opacity.clamp(0.2, 1.0);

    return Container(
      width: 60,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 112, 79, 218).withOpacity(opacity),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(6),
          topRight: Radius.circular(6),
        ),
      ),
    );
  }

  Widget _buildActivityTile(
    String title,
    String subtitle,
    String iconUrl,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            color: Colors.black87,
            width: 45,
            height: 45,
            child: CircleAvatar(
              backgroundImage: AssetImage(iconUrl),
              backgroundColor: color,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Icon(icon, color: color, size: 20),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Users',
        ),
      ],
    );
  }
}
