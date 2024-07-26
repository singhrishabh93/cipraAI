import 'package:flutter/material.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _obscureText = true;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 100,
              child: Image.asset("assets/logo.png"),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Sign In",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: TextFormField(
              focusNode: _emailFocusNode,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffE7EAEB)),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                icon: Icon(
                  _isEmailFocused ? Icons.email : Icons.email_outlined,
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
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: TextFormField(
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
                  borderSide: BorderSide(color: Color(0xffE7EAEB)),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                icon: Icon(
                  _isPasswordFocused ? Icons.lock : Icons.lock_outline,
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
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              print("The Button is Pressed");
            },
            child: Text(
              'Sign In',
              style: TextStyle(
                fontFamily: 'Urbanistbold',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}