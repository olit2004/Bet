import 'package:flutter/material.dart';
import 'package:bet/core/widgets/custom_button.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),
      appBar: _profileAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profileInfo(),
            SizedBox(height: 20),
            _stats(),
            SizedBox(height: 20),
            _detailedInfo(),
            SizedBox(height: 40),
            _activeListing(),
            SizedBox(height: 40),
            _activityLog(),
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
      "User Profile",
      style: TextStyle(
        color: Color(0xFF0D1B3E), // Dark navy text
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
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.all(30),
    padding: const EdgeInsets.all(10),
    child: Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: const AssetImage("/images/lemi.png"),
            ),

            Positioned(
              bottom: 5,
              right: 5,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF00695C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Text(
                  "ACTIVE",
                  style: TextStyle(
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
          'Julian Vance',
          style: _textStyle(30, FontWeight.bold, const Color(0xFF0D1B3E)),
        ),
        const SizedBox(height: 10),
        const Text(
          "Elite Property Curator • Joined Oct 2021",
          style: TextStyle(color: Color(0xFF7C8BB1), fontSize: 16),
        ),
        const SizedBox(height: 40),
        CustomButton(
          text: "Suspend",
          color: const Color.fromARGB(255, 229, 238, 255),
          textColor: const Color.fromARGB(255, 9, 13, 255),
          width: 450,
          height: 60,
          onPressed: () {},
        ),
      ],
    ),
  );
}

Widget _stats() {
  return Container(
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 200,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Listings"),
                  SizedBox(height: 5),
                  Text(
                    "14",
                    style: _textStyle(30, FontWeight.bold, Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              width: 200,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rating"),
                  SizedBox(height: 5),
                  Text(
                    "4.9",
                    style: _textStyle(30, FontWeight.bold, Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 20),

        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(15),
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
                  SizedBox(height: 5),
                  Text(
                    "\$12.4M",
                    style: _textStyle(40, FontWeight.bold, Colors.white),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.trending_up, color: Colors.white),
            ],
          ),
        ),

        SizedBox(height: 20),

        Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 250, 236),
            borderRadius: BorderRadius.circular(24),
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.safety_check, color: Colors.green, size: 70),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fayda Veriifed",
                    style: _textStyle(
                      25,
                      FontWeight.bold,
                      const Color.fromARGB(255, 11, 49, 2),
                    ),
                  ),
                  Text(
                    "Identity and assets verified on Oct",
                    style: _textStyle(
                      15,
                      FontWeight.bold,
                      const Color.fromARGB(255, 11, 49, 2),
                    ),
                  ),
                  Text(
                    "14, 2023",
                    style: _textStyle(
                      15,
                      FontWeight.bold,
                      const Color.fromARGB(255, 11, 49, 2),
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

Widget _detailedInfo() {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Profile Details",
          style: _textStyle(26, FontWeight.bold, Colors.black),
        ),
        SizedBox(height: 40),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Title(
                color: const Color.fromARGB(255, 81, 74, 74),
                child: Text("BIOGRAPHY"),
              ),
              SizedBox(height: 4),
              Text(
                "Luxury real estate specialist focusing on brutalist \narchitecture and mid-century modern \nrestorations in the Pacific Northwest.",
                style: _textStyle(18, FontWeight.normal, Colors.black),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.email, size: 40, color: Colors.deepPurple),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("EMAIL ADDRESS"),
                  Text(
                    "Julian123@gmail.com",
                    style: _textStyle(16, FontWeight.bold, Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 4),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.phone, size: 40, color: Colors.deepPurple),
              SizedBox(width: 10),
              Column(
                children: [
                  Text("PHONE NUMBER"),
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
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10),
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
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  _houseCard(
                    "/images/garden-state.png",
                    "The Obsidian Pavilion",
                    4,
                    2,
                  ),
                  const SizedBox(width: 15),
                  _houseCard(
                    "/images/Industrial-loft.png",
                    "Azure Shores Villa",
                    5,
                    3,
                  ),
                  const SizedBox(width: 15),
                  _houseCard(
                    "/images/skyline-retreat.png",
                    "Skyline Penthouse",
                    3,
                    2,
                  ),
                  const SizedBox(width: 15),
                  _houseCard(
                    "/images/the-glass-Pavillion.png",
                    "Oak Ridge Manor",
                    6,
                    4,
                  ),
                  const SizedBox(width: 15),
                  _houseCard(
                    "/images/garden-state.png",
                    "Emerald Valley Estate",
                    4,
                    3,
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
            child: Image.asset(imageUrl, fit: BoxFit.cover),
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
  return Container(
    padding: EdgeInsets.all(30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Activity Log",
          style: _textStyle(25, FontWeight.bold, Colors.black),
        ),
        SizedBox(height: 15),

        Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bid accepted",
                  style: _textStyle(15, FontWeight.bold, Colors.black),
                ),
                Text("The Obsidian Pavilion • \$4.15M"),
                Text("2 hours ago", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),

        SizedBox(height: 15),

        Row(
          children: [
            Icon(Icons.add_circle, color: Colors.blue),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Listed new property",
                  style: _textStyle(15, FontWeight.bold, Colors.black),
                ),
                Text("Ethereal Loft • Seattle, WA"),
                Text("Yesterday, 4:20 PM", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),

        SizedBox(height: 15),

        Row(
          children: [
            Icon(Icons.edit, color: Colors.grey),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile updated",
                  style: _textStyle(15, FontWeight.bold, Colors.black),
                ),
                Text("Updated bio and contact"),
                Text("3 days ago", style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),

        SizedBox(height: 100),
      ],
    ),
  );
}

TextStyle _textStyle(double fontsize, FontWeight fontweight, Color color) {
  return TextStyle(fontSize: fontsize, fontWeight: fontweight, color: color);
}
