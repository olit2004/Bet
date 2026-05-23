import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bet/core/widgets/custom_button.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;

  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  String errorMessage = "";
  bool isSuspending = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/admin/users/${widget.userId}'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            user = responseData['data'];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load user details: ${response.statusCode}';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error connecting to server.';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _suspendUser() async {
    if (user == null) return;
    setState(() {
      isSuspending = true;
    });

    try {
      final response = await http.patch(
        Uri.parse('http://localhost:8080/api/admin/users/${widget.userId}/moderate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'role': 'GUEST',
          'isVerified': false,
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User account suspended successfully.')),
          );
          _fetchUserDetails();
        }
      } else {
        final jsonRes = json.decode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes['message'] ?? 'Failed to suspend user')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error communicating with the backend.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSuspending = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),
      appBar: _profileAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      _profileInfo(),
                      const SizedBox(height: 20),
                      _stats(),
                      const SizedBox(height: 20),
                      _detailedInfo(),
                      const SizedBox(height: 40),
                      _activeListing(),
                      const SizedBox(height: 40),
                      _activityLog(),
                    ],
                  ),
                ),
    );
  }

  PreferredSizeWidget _profileAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF5C59E8)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "User Profile",
        style: TextStyle(
          color: Color(0xFF0D1B3E),
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Color(0xFF5C59E8)),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _profileInfo() {
    final email = user?['email'] ?? 'No Email';
    final name = email.split('@')[0];
    final role = user?['role'] ?? 'GUEST';
    final isVerified = user?['isVerified'] ?? false;
    final joinDate = _formatDate(user?['createdAt']);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(30),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage("assets/images/lemi.png"),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: isVerified ? const Color(0xFF00695C) : Colors.amber[800],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    isVerified ? "ACTIVE" : "PENDING",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: _textStyle(30, FontWeight.bold, const Color(0xFF0D1B3E)),
          ),
          const SizedBox(height: 10),
          Text(
            "$role • Joined $joinDate",
            style: const TextStyle(color: Color(0xFF7C8BB1), fontSize: 16),
          ),
          const SizedBox(height: 40),
          isSuspending
              ? const CircularProgressIndicator()
              : CustomButton(
                  text: (role == 'GUEST' && !isVerified) ? "Suspended" : "Suspend",
                  color: const Color.fromARGB(255, 229, 238, 255),
                  textColor: const Color.fromARGB(255, 9, 13, 255),
                  width: 450,
                  height: 60,
                  onPressed: (role == 'GUEST' && !isVerified) ? null : () => _suspendUser(),
                ),
        ],
      ),
    );
  }

  Widget _stats() {
    final isVerified = user?['isVerified'] ?? false;
    final joinDate = _formatDate(user?['createdAt']);
    
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Listings"),
                    const SizedBox(height: 5),
                    Text(
                      "14",
                      style: _textStyle(30, FontWeight.bold, Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width: 200,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Rating"),
                    const SizedBox(height: 5),
                    Text(
                      "4.9",
                      style: _textStyle(30, FontWeight.bold, Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 62, 82, 227),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      "Sales",
                      style: _textStyle(12, FontWeight.bold, Colors.white),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "\$12.4M",
                      style: _textStyle(40, FontWeight.bold, Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.trending_up, color: Colors.white),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: isVerified ? const Color.fromARGB(255, 207, 250, 236) : const Color.fromARGB(255, 255, 243, 224),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  isVerified ? Icons.safety_check : Icons.warning_amber_rounded,
                  color: isVerified ? Colors.green : Colors.orange,
                  size: 70,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isVerified ? "Fayda Verified" : "Verification Pending",
                        style: _textStyle(
                          25,
                          FontWeight.bold,
                          isVerified ? const Color.fromARGB(255, 11, 49, 2) : const Color.fromARGB(255, 94, 60, 0),
                        ),
                      ),
                      Text(
                        "Identity and assets verified on",
                        style: _textStyle(
                          15,
                          FontWeight.bold,
                          isVerified ? const Color.fromARGB(255, 11, 49, 2) : const Color.fromARGB(255, 94, 60, 0),
                        ),
                      ),
                      Text(
                        joinDate,
                        style: _textStyle(
                          15,
                          FontWeight.bold,
                          isVerified ? const Color.fromARGB(255, 11, 49, 2) : const Color.fromARGB(255, 94, 60, 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailedInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profile Details",
            style: _textStyle(26, FontWeight.bold, Colors.black),
          ),
          const SizedBox(height: 40),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Title(
                  color: const Color.fromARGB(255, 81, 74, 74),
                  child: const Text("BIOGRAPHY"),
                ),
                const SizedBox(height: 4),
                Text(
                  "Luxury real estate specialist focusing on brutalist \narchitecture and mid-century modern \nrestorations in the Pacific Northwest.",
                  style: _textStyle(18, FontWeight.normal, Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(Icons.email, size: 40, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("EMAIL ADDRESS"),
                    Text(
                      user?['email'] ?? 'N/A',
                      style: _textStyle(16, FontWeight.bold, Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(Icons.phone, size: 40, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PHONE NUMBER"),
                    Text(
                      "+1 (555) 092-4412",
                      style: _textStyle(16, FontWeight.bold, Colors.black),
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

  Widget _activeListing() {
    final List<dynamic> properties = user?['seller']?['properties'] ?? [];
    
    if (properties.isEmpty) {
       return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "   Active Listings",
                style: _textStyle(25, FontWeight.bold, Colors.black),
              ),
              const Spacer(),
              Text(
                "view all   ",
                style: _textStyle(
                  16,
                  FontWeight.bold,
                  const Color.fromARGB(255, 44, 38, 148),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: properties.map<Widget>((prop) {
                final imageUrls = prop['imageUrls'] as List<dynamic>? ?? [];
                final imagePath = imageUrls.isNotEmpty ? imageUrls[0] : "assets/images/garden-state.png";
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: _houseCard(
                    imagePath,
                    prop['title'] ?? 'Untitled Property',
                    prop['beds'] ?? 0,
                    prop['baths'] ?? 0,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _houseCard(String imageUrl, String houseNme, int bed, int bathRoom) {
    return Container(
      width: 400,
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
              width: 400,
              child: imageUrl.startsWith('http') 
                  ? Image.network(imageUrl, fit: BoxFit.cover) 
                  : Image.asset(imageUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  houseNme,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color.fromARGB(255, 25, 25, 65),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.bed),
                    const SizedBox(width: 5),
                    Text("$bed"),
                    const SizedBox(width: 12),
                    const Icon(Icons.bathroom),
                    const SizedBox(width: 5),
                    Text("$bathRoom"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityLog() {
    final List<dynamic> logs = user?['auditLogs'] ?? [];

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Activity Log",
            style: _textStyle(25, FontWeight.bold, Colors.black),
          ),
          const SizedBox(height: 15),
          if (logs.isEmpty)
            const Text("No activities logged for this user.")
          else
            ...logs.map((log) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log['action'] ?? 'Action performed',
                            style: _textStyle(15, FontWeight.bold, Colors.black),
                          ),
                          Text(log['details'] ?? ''),
                          Text(
                            _timeAgo(_formatDate(log['createdAt'])),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  TextStyle _textStyle(double fontsize, FontWeight fontweight, Color color) {
    return TextStyle(fontSize: fontsize, fontWeight: fontweight, color: color);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return "N/A";
    try {
      final date = DateTime.parse(dateStr);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return dateStr;
    }
  }

  String _timeAgo(String dateStr) {
    return "$dateStr • Recently";
  }
}
