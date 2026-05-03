import 'package:flutter/material.dart';

class IdentityReviewScreen extends StatelessWidget {
  const IdentityReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 249, 255, 1),

      appBar: _topNavigator(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _profile(),
            SizedBox(height: 20),
            _idCard(),
            SizedBox(height: 20),
            _verification(),
            SizedBox(height: 20),
            _approval(
              "Approve Identity",
              const Color.fromARGB(255, 37, 73, 230),
            ),
            SizedBox(height: 20),
            _approval(
              "Reject Withe Reason",
              const Color.fromARGB(255, 255, 255, 255),
            ),
            SizedBox(height: 50),
          ],
        ),
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

Widget _profile() {
  return Container(
    padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
    margin: EdgeInsets.all(30),

    decoration: _boxStyle(),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage("/images/avater.png"),
        ),
        SizedBox(width: 20),
        Column(
          children: [
            Text("Lemi Gobena", style: TextStyle(fontSize: 24)),
            SizedBox(height: 5),
            Text(
              "lemi@gmail.com",
              style: _textStyle(15, FontWeight.w400, Colors.black),
            ),
            Text(
              "+251988553202",
              style: _textStyle(15, FontWeight.w400, Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _idCard() {
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
        Image.asset("/images/Fayda_National_ID_Card_-_Front.jpg"),
      ],
    ),
  );
}

Widget _verification() {
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
              "  Email Adress",
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
      // Adding a light border automatically if the background is white
      border: bgColor == Colors.white
          ? Border.all(color: Colors.blue.shade100)
          : null,
    ),
    child: Text(
      title,
      style: TextStyle(
        // If background is white, use dark text; otherwise, use white text
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
        color: const Color.fromARGB(255, 6, 5, 5).withOpacity(0.01),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}

TextStyle _textStyle(double fontsize, FontWeight fontweight, Color color) {
  return TextStyle(fontSize: fontsize, fontWeight: fontweight, color: color);
}
