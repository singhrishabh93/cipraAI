import 'package:flutter/material.dart';
import 'package:loginapp/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _logout() async {
    // Clear shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all shared preferences

    // Alternatively, if you want to clear only the login state:
    // await prefs.remove('isLoggedIn');

    // Navigate to LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Loginscreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Personalized Impact of Lifestyle Factors",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recommendation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  'Our analysis shows your BP is related to your \ndaily number of steps. This week, focus on \n increasing your daily step count. Regular \nphysical activity helps to lower blood pressure.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(height: 10),
                Image.asset("assets/easy.jpg")
              ],
            ),
          ),
        ),
      ),
    );
  }
}