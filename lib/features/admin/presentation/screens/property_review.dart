import 'package:flutter/material.dart';
import 'package:bet/core/widgets/custom_button.dart';

class PropertyReview extends StatelessWidget {
  const PropertyReview({super.key});

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
            _description(),
            SizedBox(height: 20),
            _buttons(),
            SizedBox(height: 20),
            _map(),
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

Widget _profileInfo() {
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
              child: Image.asset(
                "images/skyline-retreat.png",
                width: double.infinity,
                height: 260,
                fit: BoxFit.cover,
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

                child: const Text(
                  "PENDING REVIEW",
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
                "45,000,000 ETB",
                style: _textStyle(
                  34,
                  FontWeight.bold,
                  const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              _profile(),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _description() {
  return Container(
    padding: EdgeInsets.all(30),
    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "The Bole Pavilion",
          style: _textStyle(38, FontWeight.bold, Colors.black),
        ),
        SizedBox(height: 20),
        Text(
          "A glass-walled masterpiece offering panoramic views of the city's diplomatic quarter. Fully furnished with Italian finishes, this residence redefines luxury in Addis Ababa.",
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
            _simpleContainer(Icons.area_chart, "1,200", " sqft"),
            _simpleContainer(Icons.bed, "4.5", "BEDROOMS"),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _simpleContainer(Icons.bathtub, "4.5", "BATHS"),
            _simpleContainer(Icons.calendar_month, "2023", "BUILT YEAR"),
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

Widget _profile() {
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
              "Dawit Mengist",
              style: _textStyle(20, FontWeight.bold, Colors.black),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buttons() {
  return Column(
    children: [
      CustomButton(
        text: "Approve Submission",
        color: const Color.fromARGB(255, 10, 87, 229),
        textColor: const Color.fromARGB(255, 255, 255, 255),
        width: 450,
        height: 60,
        onPressed: () {},
      ),
      SizedBox(height: 10),
      CustomButton(
        text: "Flag for Revision",
        color: const Color.fromARGB(255, 200, 213, 237),
        textColor: const Color.fromARGB(255, 0, 0, 0),
        width: 450,
        height: 60,
        onPressed: () {},
      ),
    ],
  );
}

Widget _map() {
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
