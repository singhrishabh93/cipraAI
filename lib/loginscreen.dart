import 'package:flutter/material.dart';
import 'package:loginapp/homescreen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/io_client.dart';
import 'dart:async';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _obscureText = true;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isLoading = false;
  
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      setState(() {
        _isEmailFocused = _emailFocusNode.hasFocus;
      });
    });
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      }
    } catch (e) {
      _showErrorSnackBar('Error checking login status: $e');
    }
  }

  Future<bool> _checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Internet connectivity check passed');
        return true;
      }
    } on SocketException catch (_) {
      print('Internet connectivity check failed');
      return false;
    }
    return false;
  }

  Future<bool> _signIn(String email, String password) async {
    final url = Uri.parse('https://api.cipra.ai:5000/takehome/signin')
        .replace(queryParameters: {
      'email': email,
      'password': password,
    });

    try {
      print('Attempting to connect to: $url');

      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) {
        print('Bad certificate callback: host=$host, port=$port');
        return true;
      };
      final http = IOClient(ioc);

      print('Sending request...');
      final response = await http.get(url).timeout(Duration(seconds: 30));
      print('Response received. Status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        // Check if the response body is "Valid Credentials"
        if (response.body.trim() == "Valid Credentials") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          return true;
        } else {
          _showErrorSnackBar('Invalid credentials');
          return false;
        }
      } else {
        _showErrorSnackBar('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Detailed error: $e');
      if (e is SocketException) {
        print('SocketException details: ${e.message}, ${e.address}, ${e.port}');
        _showErrorSnackBar('Network error: Unable to connect to the server. Please check your internet connection.');
      } else if (e is HandshakeException) {
        print('HandshakeException details: ${e.message}');
        _showErrorSnackBar('SSL/TLS Handshake failed. There might be an issue with the server\'s certificate.');
      } else if (e is TimeoutException) {
        print('TimeoutException: The connection timed out');
        _showErrorSnackBar('The connection timed out. Please try again.');
      } else {
        _showErrorSnackBar('An unexpected error occurred: $e');
      }
      return false;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset("assets/bg1.png"),
            Column(
              children: [
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120,
                    child: Image.asset("assets/logo.png"),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 60),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(
                        _isEmailFocused ? Icons.person_2_rounded : Icons.person_2_outlined,
                        color: _isEmailFocused ? Colors.black : Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                    cursorColor: Colors.black,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(
                        _isPasswordFocused ? Icons.key_off : Icons.key_off_outlined,
                        color: _isPasswordFocused ? Colors.black : Colors.grey,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3A4F98),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isLoading ? null : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      final email = _emailController.text;
                      final password = _passwordController.text;

                      if (email.isEmpty || password.isEmpty) {
                        _showErrorSnackBar('Please enter both email and password');
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      bool hasInternet = await _checkInternetConnectivity();
                      if (!hasInternet) {
                        _showErrorSnackBar('No internet connection. Please check your network settings.');
                        setState(() {
                          _isLoading = false;
                        });
                        return;
                      }

                      final success = await _signIn(email, password);

                      setState(() {
                        _isLoading = false;
                      });

                      if (success) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } else {
                        // Optionally, you can show a message here for failed login
                        _showErrorSnackBar('Login failed. Please try again.');
                      }
                    },
                    child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Urbanistbold',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}