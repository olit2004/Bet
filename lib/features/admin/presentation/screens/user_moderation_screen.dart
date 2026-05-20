import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bet/core/widgets/app_logo.dart';
import 'package:bet/core/widgets/custom_button.dart';
import 'package:bet/features/admin/presentation/screens/admin_profile.dart';
import 'user_details_screen.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String currentFilter = "";
  List<dynamic> users = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/admin/users'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            users = responseData['data'] ?? [];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load users: ${response.statusCode}';
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
                      SizedBox(height: 20),
                      _currentStats(),
                      SizedBox(height: 20),
                      _filterBar(),
                      SizedBox(height: 20),
                      if (users.isEmpty)
                        const Center(child: Text("No users found in database.")),
                      ...users.map((user) {
                        return Column(
                          children: [
                            _usersCard(
                              context,
                              user['email']?.split('@')[0] ?? 'Unknown', // Use prefix as name
                              user['role'] ?? 'GUEST',
                              user['isVerified'] ? "Verified" : "Pending Verification",
                              "/images/profile.png", // Generic fallback avatar
                              user['role'] == 'SELLER',
                              type: user['isVerified'] ? 1 : 3,
                            ),
                            SizedBox(height: 20),
                          ],
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

  Widget _currentStats() {
    final totalUsers = users.length;
    final pendingUsers = users.where((u) => u['isVerified'] == false).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Colors.blue),
              Text("Total Users"),
              Text("$totalUsers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),

        Container(
          padding: EdgeInsets.all(10),
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.flag, color: Colors.red),
              Text("Pending"),
              Text("$pendingUsers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _filterBar() {
    return Container(
      margin: EdgeInsets.all(5),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              214,
              206,
              204,
              204,
            ).withValues(alpha: 0.05),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            "   Active  Moderation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            "Filtered by $currentFilter",
            style: TextStyle(
              color: const Color.fromARGB(255, 109, 36, 205),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 5),
          _menue(),
        ],
      ),
    );
  }

  Widget _menue() {
    List<String> filters = ['Role', 'State', 'Date', 'Name'];

    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list),
      onSelected: (value) {
        setState(() {
          currentFilter = value;
        });
      },
      itemBuilder: (context) {
        return filters.map((item) {
          return PopupMenuItem(value: item, child: Text(item));
        }).toList();
      },
    );
  }

  Widget _usersCard(
    BuildContext context,
    String name,
    String role,
    String statusDiscription,
    String imageUrl,
    bool isSeller, {
    Color roleColor = const Color.fromARGB(255, 147, 198, 239),
    int type = 1,
  }) {
    final Color finalRoleColor = isSeller
        ? const Color.fromARGB(255, 25, 166, 17)
        : roleColor;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(
              255,
              255,
              255,
              255,
            ).withValues(alpha: 0.05),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),

      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 246, 246, 246),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(imageUrl, fit: BoxFit.cover),
              ),

              SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text(statusDiscription, style: TextStyle(fontSize: 14)),
                ],
              ),
              const Spacer(),

              Container(
                width: 50,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: finalRoleColor,
                  borderRadius: BorderRadius.circular(7),
                ),

                child: Text(
                  role,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 254, 254),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildButtonRow(context, type),
        ],
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context, int type) {
    if (type == 1) {

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 140,
            child: CustomButton(
              text: "Suspend",
              textColor: Colors.black,
              onPressed: () {

              },
              color: const Color.fromARGB(255, 229, 238, 255),
            ),
          ),

          SizedBox(
            width: 140,
            child: CustomButton(
              text: "View Details",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserDetailScreen(),
                  ),
                );
              },
              color: const Color.fromARGB(255, 43, 63, 240),
            ),
          ),
        ],
      );
    } else if (type == 2) {

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: CustomButton(
              text: "Approve Seller",
              onPressed: () {

              },
              color: const Color.fromARGB(255, 0, 121, 66),
            ),
          ),
        ],
      );
    } else if (type == 3) {

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 140,
            child: CustomButton(
              text: "Restrict",
              textColor: Colors.white,
              onPressed: () {

              },
              color: const Color.fromARGB(255, 245, 129, 156),
            ),
          ),

          SizedBox(
            width: 140,
            child: CustomButton(
              text: "Verify Identity",
              textColor: Colors.black,
              onPressed: () {},
              color: const Color.fromARGB(255, 200, 216, 243),
            ),
          ),
        ],
      );
    }
    return SizedBox.shrink();
  }
}
