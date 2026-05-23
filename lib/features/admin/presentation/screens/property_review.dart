import 'dart:convert';
import 'admin_http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bet/core/widgets/custom_button.dart';

class PropertyReview extends StatelessWidget {
  final Map<String, dynamic> property;
  const PropertyReview({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),
      appBar: _profileAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileInfo(property),
            SizedBox(height: 20),
            _description(property),
            SizedBox(height: 20),
            _buttons(context, property),
            SizedBox(height: 20),
            _map(property),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
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
      "Review Property",
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

Widget _profileInfo(Map<String, dynamic> property) {
  final imageUrls = property['imageUrls'] as List<dynamic>? ?? [];
  String imagePath = imageUrls.isNotEmpty ? imageUrls[0] : "assets/images/skyline-retreat.png";
  if (imagePath.startsWith('/')) {
    imagePath = 'http://localhost:8080$imagePath';
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),

    child: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: imagePath.startsWith('assets/')
                  ? Image.asset(imagePath, width: double.infinity, height: 260, fit: BoxFit.cover)
                  : Image.network(
                      imagePath, 
                      width: double.infinity, 
                      height: 260, 
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/skyline-retreat.png", width: double.infinity, height: 260, fit: BoxFit.cover),
                    ),
            ),

            Positioned(
              bottom: -20,
              left: -20,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFF5A20A),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white, width: 5),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Text(
                  property['status']?.toUpperCase() ?? "PENDING REVIEW",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 234, 241, 255),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(40),
          margin: EdgeInsets.all(0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "ASKING PRICE",
                style: _textStyle(28, FontWeight.bold, Colors.blueAccent),
              ),
              SizedBox(height: 20),
              Text(
                "${property['price'] ?? '0'} ETB",
                style: _textStyle(
                  34,
                  FontWeight.bold,
                  const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              _profile(property),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _description(Map<String, dynamic> property) {
  return Container(
    padding: EdgeInsets.all(30),
    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          property['title'] ?? "The Bole Pavilion",
          style: _textStyle(38, FontWeight.bold, Colors.black),
        ),
        SizedBox(height: 20),
        Text(
          property['description'] ?? "A beautiful property.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.black45,
          ),
        ),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _simpleContainer(Icons.area_chart, property['sqFootage']?.toString() ?? "-", " sqft"),
            _simpleContainer(Icons.bed, property['beds']?.toString() ?? "-", "BEDROOMS"),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _simpleContainer(Icons.bathtub, property['baths']?.toString() ?? "-", "BATHS"),
            _simpleContainer(Icons.calendar_month, property['createdAt'] != null ? DateTime.parse(property['createdAt']).year.toString() : "2023", "BUILT YEAR"),
          ],
        ),
      ],
    ),
  );
}

Widget _simpleContainer(IconData iconName, String mainTxt, String secondTxt) {
  return Container(
    height: 120,
    width: 170,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 215, 236, 248),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Icon(iconName, color: Colors.blue),
        Text(mainTxt, style: _textStyle(24, FontWeight.bold, Colors.black)),
        Text(secondTxt),
      ],
    ),
  );
}

Widget _profile(Map<String, dynamic> property) {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
    decoration: _boxStyle(const Color.fromARGB(255, 232, 240, 255)),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage("/images/avater.png"),
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text(
              "LISTING AGENT",
              style: _textStyle(
                18,
                FontWeight.normal,
                const Color.fromARGB(255, 115, 117, 115),
              ),
            ),
            Text(
              property['owner'] != null && property['owner']['user'] != null 
                  ? property['owner']['user']['email'].split('@')[0] 
                  : "Unknown",
              style: _textStyle(20, FontWeight.bold, Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buttons(BuildContext context, Map<String, dynamic> property) {
  return Column(
    children: [
      CustomButton(
        text: "Suspend Property",
        color: const Color.fromARGB(255, 237, 95, 88),
        textColor: const Color.fromARGB(255, 255, 255, 255),
        width: 450,
        height: 60,
        onPressed: () async {
          try {
            final response = await http.patch(
              Uri.parse('http://localhost:8080/api/admin/properties/${property['id']}/review'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'status': 'SUSPENDED'}),
            );
            if (response.statusCode == 200) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Property suspended successfully.')),
                );
                Navigator.pop(context);
              }
            } else {
              final jsonRes = json.decode(response.body);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(jsonRes['message'] ?? 'Failed to suspend property')),
                );
              }
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Connection failed.')),
              );
            }
          }
        },
      ),
    ],
  );
}

Widget _map(Map<String, dynamic> property) {
  return Container(
    padding: EdgeInsets.all(20),
    margin: EdgeInsets.all(15),
    decoration: _boxStyle(const Color.fromARGB(255, 220, 233, 255)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location",
          style: _textStyle(20, FontWeight.bold, Colors.black26),
        ),
        SizedBox(height: 10),
        Image.asset("images/map.png"),
        SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.location_city_sharp),
            Text(
              " Bole Distinct, Addis Ababa",
              style: _textStyle(20, FontWeight.bold, Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}

BoxDecoration _boxStyle(Color bgcolor) {
  return BoxDecoration(
    color: bgcolor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: const Color.fromARGB(255, 6, 5, 5).withValues(alpha: 0.01),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

TextStyle _textStyle(double fontsize, FontWeight fontweight, Color color) {
  return TextStyle(fontSize: fontsize, fontWeight: fontweight, color: color);
}
