import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/admin/presentation/screens/admin_profile.dart';
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool isLoading = true;
  String errorMessage = '';

  double revenue = 0.0;
  int activeAuctions = 0;
  int pendingVerifications = 0;
  List<dynamic> recentActivities = [];
  List<dynamic> weeklyChartData = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/admin/dashboard'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final data = responseData['data'];

        if (mounted) {
          setState(() {
            revenue = data['revenue']?.toDouble() ?? 0.0;
            activeAuctions = data['activeAuctions'] ?? 0;
            pendingVerifications = data['pendingVerifications'] ?? 0;
            recentActivities = data['recentActivities'] ?? [];
            weeklyChartData = data['weeklyChartData'] ?? [];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load data: ${response.statusCode}';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error connecting to server. Is the backend running?';
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),
      appBar: _buildAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader("Global Performance", "Real-time ecosystem health"),
                      const SizedBox(height: 20),

                      _buildStatCard(
                        "TOTAL REVENUE",
                        "\$${(revenue / 1000000).toStringAsFixed(1)}M", 
                        "+12.5%",
                        Icons.payments,
                        Colors.indigo[50]!,
                        Colors.indigo,
                      ),
                      _buildStatCard(
                        "ACTIVE AUCTIONS",
                        "$activeAuctions",
                        "Hot",
                        Icons.gavel,
                        Colors.orange[50]!,
                        Colors.orange,
                      ),
                      _buildStatCard(
                        "PENDING VERIFICATIONS",
                        "$pendingVerifications",
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

                      ...recentActivities.map((activity) {
                        return _buildActivityTile(
                          activity['title'] ?? 'Activity',
                          activity['subtitle'] ?? '',
                          activity['avatar'] ?? '/images/verify.png',
                          Icons.notifications_active,
                          Colors.blue,
                        );
                      }),
                    ],
                  ),
                ),
    );
  }



  AppBar _buildAppBar(BuildContext context) {
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
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
          child: const CircleAvatar(
            radius: 18,
            backgroundImage: AssetImage("/images/avater.png"),
          ),
        ),
        const SizedBox(width: 15),
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
            color: Colors.black.withValues(alpha: 0.03),
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

    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 154, 177, 240).withValues(alpha: 0.3),
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
        color: const Color.fromARGB(
          255,
          112,
          79,
          218,
        ).withValues(alpha: opacity),
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
}
