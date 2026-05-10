import 'package:flutter/material.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/admin/presentation/screens/identity_review_screen.dart';
import 'package:bet/core/widgets/custom_button.dart';

class PropertiesScreen extends StatelessWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 249, 255, 1),

      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(
              "Property Approvals",
              "Review pending submissions for quality assurance.",
            ),
            SizedBox(height: 20),
            _filterButtons(),
            SizedBox(height: 20),

            _houseCard(
              context,
              "assets/images/skyline-retreat.png",
              "Grand x",
              "4,000,000",
              "Lemi Gobena",
            ),

            _houseCard(
              context,
              "assets/images/garden-state.png",
              "Grand x",
              "30,000,000",
              "Bekalu Addissu",
            ),

            _houseCard(
              context,
              "assets/images/Industrial-loft.png",
              "Grand x",
              "20,000,000",
              "Olit jira",
            ),

            _houseCard(
              context,
              "assets/images/the-glass-Pavillion.png",
              "Grand x",
              "20,000,000",
              "misganaw andualem",
            ),
          ],
        ),
      ),
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
          backgroundImage: AssetImage("assets/images/avater.png"),
        ),
        SizedBox(width: 15),
      ],
    );
  }

  Widget _buildHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
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
            color: Color.fromARGB(255, 73, 82, 129),
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _filterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFilterButton('All', isActive: true),
        const SizedBox(width: 10),
        _buildFilterButton('Residential'),
        const SizedBox(width: 10),
        _buildFilterButton('Commercial'),
      ],
    );
  }

  Widget _buildFilterButton(String text, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4C5DF4) : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _houseCard(
    BuildContext context,
    String houseImage,
    String name,
    String price,
    String seller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: SizedBox(
              height: 280,
              width: double.infinity,
              child: Image.asset(houseImage, fit: BoxFit.cover),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        color: Color.fromARGB(255, 25, 25, 65),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "\$$price",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 65, 65, 197),
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 2),
                    Text(
                      "submitted by $seller",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 74, 72, 66),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      child: CustomButton(
                        text: "Review & approve",
                        onPressed: () => _buttonAction(context),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 220, 216, 216),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.flag,
                        color: Color.fromARGB(255, 237, 95, 88),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _buttonAction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IdentityReviewScreen()),
    );
  }
}
