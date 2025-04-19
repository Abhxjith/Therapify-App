import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import Font Awesome icons
import 'package:therapify/theme.dart'; 
import 'package:therapify/Login/login.dart'; 

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  void _togglePasswordView() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleConfirmPasswordView() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Registration',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w500,
                  color: appTheme.primaryColor,
                  fontFamily: 'Lato',
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 11.0),
              Text(
                'Please enter the following details for registration purposes.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                  fontFamily: 'Lato',
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 33.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: _obscureTextPassword,
                decoration: InputDecoration(
                  labelText: 'Enter Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eye,
                      size: 20.0, // Adjust the size if needed
                    ),
                    onPressed: _togglePasswordView,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                obscureText: _obscureTextConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureTextConfirmPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eye,
                      size: 20.0, // Adjust the size if needed
                    ),
                    onPressed: _toggleConfirmPasswordView,
                  ),
                ),
              ),
              SizedBox(height: 44.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(), // Navigate to LoginScreen
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.primaryColor, // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
              SizedBox(height: 38.0),
            ],
          ),
        ),
      ),
    );
  }
}
