import 'dart:convert';
import 'admin_http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/features/admin/presentation/screens/admin_profile.dart';
import 'package:bet/features/admin/presentation/screens/property_review.dart';
import 'package:bet/core/widgets/custom_button.dart';

class PropertiesScreen extends StatefulWidget {
  const PropertiesScreen({super.key});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> {
  List<dynamic> properties = [];
  bool isLoading = true;
  String errorMessage = "";
  String currentFilter = "All";

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/admin/properties/review'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            properties = responseData['data'] ?? [];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load properties: ${response.statusCode}';
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
    List<dynamic> filteredProperties = properties.where((p) {
      if (currentFilter == 'All') return true;
      final title = (p['title'] ?? '').toString().toLowerCase();
      final desc = (p['description'] ?? '').toString().toLowerCase();
      bool isCommercial = title.contains('office') || title.contains('shop') || title.contains('commercial') || desc.contains('office') || desc.contains('commercial');
      if (currentFilter == 'Commercial') return isCommercial;
      if (currentFilter == 'Residential') return !isCommercial;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 249, 255, 1),
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
                      _buildHeader(
                        "Property Approvals",
                        "Review pending submissions for quality assurance.",
                      ),
                      SizedBox(height: 20),
                      _filterButtons(),
                      SizedBox(height: 20),
                      
                      if (filteredProperties.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Text("No properties found for this filter.", style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        
                      ...filteredProperties.map((property) {
                        final imageUrls = property['imageUrls'] as List<dynamic>? ?? [];
                        String imagePath = imageUrls.isNotEmpty ? imageUrls[0] : "assets/images/skyline-retreat.png";
                        if (imagePath.startsWith('/')) {
                          imagePath = 'http://localhost:8080$imagePath';
                        }
                        return _houseCard(
                          context,
                          property,
                          imagePath,
                          property['title'] ?? 'Untitled Property',
                          property['price']?.toString() ?? '0',
                          property['owner'] != null && property['owner']['user'] != null ? property['owner']['user']['email'].split('@')[0] : 'Unknown Seller',
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
            backgroundImage: AssetImage("assets/images/avater.png"),
          ),
        ),
        const SizedBox(width: 15),
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
        _buildFilterButton('All', isActive: currentFilter == 'All'),
        const SizedBox(width: 10),
        _buildFilterButton('Residential', isActive: currentFilter == 'Residential'),
        const SizedBox(width: 10),
        _buildFilterButton('Commercial', isActive: currentFilter == 'Commercial'),
      ],
    );
  }

  Widget _buildFilterButton(String text, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentFilter = text;
        });
      },
      child: Container(
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
      ),
    );
  }

  Widget _houseCard(
    BuildContext context,
    Map<String, dynamic> property,
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
              child: houseImage.startsWith('assets/')
                  ? Image.asset(houseImage, fit: BoxFit.cover)
                  : Image.network(
                      houseImage, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/skyline-retreat.png", fit: BoxFit.cover),
                    ),
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
                        text: "Review Property",
                        onPressed: () => _buttonAction(context, property),
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

  void _buttonAction(BuildContext context, Map<String, dynamic> property) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PropertyReview(property: property)),
    );
  }
}
