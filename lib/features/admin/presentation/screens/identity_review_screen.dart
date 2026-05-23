import 'dart:convert';
import 'admin_http.dart' as http;
import 'package:flutter/material.dart';

class IdentityReviewScreen extends StatefulWidget {
  const IdentityReviewScreen({super.key});

  @override
  State<IdentityReviewScreen> createState() => _IdentityReviewScreenState();
}

class _IdentityReviewScreenState extends State<IdentityReviewScreen> {
  List<dynamic> pendingUsers = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    _fetchPendingVerifications();
  }

  Future<void> _fetchPendingVerifications() async {
    setState(() { isLoading = true; errorMessage = ""; });
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/admin/verifications/pending'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (mounted) {
          setState(() {
            pendingUsers = responseData['data'] ?? [];
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = 'Failed to load verifications';
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

  Future<void> _verifyIdentity(String userId, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/admin/users/$userId/verify-identity'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'approve': status == 'VERIFIED'}),
      );
      if (response.statusCode == 200) {
        _fetchPendingVerifications();
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),
      appBar: _topNavigator(context),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : errorMessage.isNotEmpty 
              ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
              : pendingUsers.isEmpty 
                  ? const Center(child: Text("No pending verifications", style: TextStyle(fontSize: 18)))
                  : _buildUserReview(pendingUsers.first),
    );
  }

  Widget _buildUserReview(Map<String, dynamic> user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _profile(user),
          SizedBox(height: 20),
          _idCard(user),
          SizedBox(height: 20),
          _verification(user),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _verifyIdentity(user['id'], 'VERIFIED'),
            child: _approval("Approve Identity", const Color.fromARGB(255, 37, 73, 230)),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => _verifyIdentity(user['id'], 'REJECTED'),
            child: _approval("Reject With Reason", const Color.fromARGB(255, 255, 255, 255)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  PreferredSizeWidget _topNavigator(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF4A61DD)),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Verification Console',
        style: TextStyle(
          color: Color(0xFF4A61DD),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
      centerTitle: false,
      titleSpacing: 0,
    );
  }
}

Widget _profile(Map<String, dynamic> user) {
  return Container(
    padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
    margin: EdgeInsets.all(30),
    decoration: _boxStyle(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("assets/images/avater.png"),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user['email'].split('@')[0], style: TextStyle(fontSize: 24)),
              SizedBox(height: 5),
              Text(
                user['email'] ?? "No Email",
                style: _textStyle(15, FontWeight.w400, Colors.black),
              ),
              Text(
                user['phoneNumber'] ?? "+251900000000",
                style: _textStyle(15, FontWeight.w400, Colors.black),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _idCard(Map<String, dynamic> user) {
  return Container(
    padding: EdgeInsets.all(30),
    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
    height: 360,
    decoration: _boxStyle(),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Identity Document",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 40, 238, 168),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(5),
              child: Text("Valid Type"),
            ),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: user['faydaImageUrl'] != null 
              ? Image.network('http://localhost:8080${user['faydaImageUrl']}', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/Fayda_National_ID_Card_-_Front.jpg"))
              : Image.asset("assets/images/Fayda_National_ID_Card_-_Front.jpg"),
        ),
      ],
    ),
  );
}

Widget _verification(Map<String, dynamic> user) {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
    decoration: _boxStyle(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verification Metrics",
          style: _textStyle(20, FontWeight.bold, Colors.black),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.email, color: Colors.blue, size: 40),
            Text(
              "  Email Address",
              style: _textStyle(15, FontWeight.w400, Colors.black),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 179, 237, 212),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(5),
              child: Text(
                " Verified",
                style: _textStyle(15, FontWeight.w400, Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Icon(Icons.location_city, color: Colors.blue, size: 40),
            Text(
              "  Location",
              style: _textStyle(15, FontWeight.w400, Colors.black),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 179, 237, 212),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(5),
              child: Text(" Match"),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Icon(Icons.translate, color: Colors.blue, size: 40),
            Text("  Language"),
            const Spacer(),
            Text("ES,EN"),
          ],
        ),
      ],
    ),
  );
}

Widget _approval(String title, Color bgColor) {
  return Container(
    margin: EdgeInsets.fromLTRB(30, 5, 30, 0),
    width: double.infinity,
    height: 55,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(30),
      border: bgColor == Colors.white
          ? Border.all(color: Colors.blue.shade100)
          : null,
    ),
    child: Text(
      title,
      style: TextStyle(
        color: bgColor == Colors.white ? Color(0xFF34495E) : Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}

BoxDecoration _boxStyle() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 6, 5, 5).withValues(alpha:0.01),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

TextStyle _textStyle(double fontsize, FontWeight fontweight, Color color) {
  return TextStyle(fontSize: fontsize, fontWeight: fontweight, color: color);
}
