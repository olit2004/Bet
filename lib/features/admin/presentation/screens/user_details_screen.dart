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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to suspend user: ${response.statusCode}')),
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
                backgroundImage: AssetImage("/images/profile.png"),
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
                    isVerified ? "VERIFIED" : "PENDING",
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
            "$role • Joined ${_formatDate(user?['createdAt'])}",
            style: const TextStyle(color: Color(0xFF7C8BB1), fontSize: 16),
          ),
          const SizedBox(height: 40),
          if (role != 'GUEST' || isVerified)
            isSuspending
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: "Suspend User",
                    color: const Color.fromARGB(255, 229, 238, 255),
                    textColor: const Color.fromARGB(255, 9, 13, 255),
                    width: 450,
                    height: 60,
                    onPressed: _suspendUser,
                  ),
        ],
      ),
    );
  }

  Widget _stats() {
    final role = user?['role'] ?? 'GUEST';
    final isVerified = user?['isVerified'] ?? false;
    final faydaId = user?['faydaId'] ?? 'Not Provided';

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 170,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Role"),
                    const SizedBox(height: 5),
                    Text(
                      role,
                      style: _textStyle(20, FontWeight.bold, Colors.black),
                    ),
                  ],
                ),
              ),
              Container(
                width: 170,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Status"),
                    const SizedBox(height: 5),
                    Text(
                      isVerified ? "Verified" : "Unverified",
                      style: _textStyle(20, FontWeight.bold, isVerified ? Colors.green : Colors.orange),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: isVerified ? const Color.fromARGB(255, 207, 250, 236) : const Color.fromARGB(255, 255, 243, 224),
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Icon(
                  isVerified ? Icons.safety_check : Icons.warning_amber_rounded,
                  color: isVerified ? Colors.green : Colors.orange,
                  size: 50,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isVerified ? "Fayda Verified" : "Verification Pending",
                        style: _textStyle(
                          20,
                          FontWeight.bold,
                          isVerified ? const Color.fromARGB(255, 11, 49, 2) : const Color.fromARGB(255, 94, 60, 0),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Fayda ID: $faydaId",
                        style: const TextStyle(fontSize: 14),
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
          const SizedBox(height: 20),
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
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                const Icon(Icons.calendar_month, size: 40, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("MEMBER SINCE"),
                    Text(
                      _formatDate(user?['createdAt']),
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
    return Container();
  }

  Widget _activityLog() {
    final List<dynamic> logs = user?['auditLogs'] ?? [];

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Security & Activity Log",
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
                    const Icon(Icons.info_outline, color: Colors.blue),
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
                            _formatDate(log['createdAt']),
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
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
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return dateStr;
    }
  }
}
