import 'package:flutter/material.dart';
import 'package:bet/core/widgets/app_logo.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String currentFilter = "";
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
            _currentStats(),
            SizedBox(height: 20),
            _filterBar(),
            SizedBox(height: 20),
            _usersCard(
              "Bekalu",
              "Seller",
              "susbended due to fraud",
              "/images/bekalu.png",
              true,
            ),
            SizedBox(height: 20),

            _usersCard(
              "Bety",
              "buyer",
              "Listed 1 property",
              "/images/bety.png",
              false,
            ),
            SizedBox(height: 20),
            _usersCard(
              "Fita",
              "Buyer",
              "Pending Verification",
              "/images/profile.png",
              true,
            ),

            SizedBox(height: 20),
            _usersCard(
              "Lemi",
              "Seller",
              "Listed 12 properties",
              "/images/lemi.png",
              false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
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
          backgroundImage: AssetImage("/images/avater.png"),
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

  Widget _currentStats() {
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
                color: Colors.black.withValues(alpha:0.1), // shadow color
                blurRadius: 10, // softness
                offset: Offset(0, 5), // position (x, y)
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.person, color: Colors.blue),
              Text("Total Curators"),
              Text("1,200"),
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
                color: Colors.black.withValues(alpha:0.1), // shadow color
                blurRadius: 10, // softness
                offset: Offset(0, 5), // position (x, y)
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(Icons.flag, color: Colors.red),
              Text("Flaged"),
              Text("14"),
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
            ).withValues(alpha:0.05), // shadow color
            blurRadius: 5, // softness
            offset: Offset(0, 3), // position (x, y)
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
    String name,
    String role,
    String statusDiscription,
    String imageUrl,
    bool isSeller, {
    Color roleColor = const Color.fromARGB(255, 147, 198, 239),
  }) {
    final Color finalRoleColor = isSeller
        ? const Color.fromARGB(255, 25, 166, 17)
        : roleColor;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05), // shadow color
            blurRadius: 5, // softness
            offset: Offset(0, 3), // position (x, y)
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
                    "name",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text("statusDiscription", style: TextStyle(fontSize: 14)),
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
                  "role",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 254, 254),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 135, 187, 230),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text("Suspend"),
              ),

              Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 43, 63, 240),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Veiw Details",
                  style: TextStyle(color: Colors.white),
                ),
                
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue[800],
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Users',
        ),
      ],
    );
  }
}
