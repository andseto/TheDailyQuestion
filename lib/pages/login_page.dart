import 'package:flutter/material.dart';
import 'package:the_daily_question/widgets/rounded_test_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showLogin = true; // Track current selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background_image.png",
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          Column(
            children: [
              _header(context),                      // Top logo + title
              _loginForm(context),                   // Lower login/signup card
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .25,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Image.asset(
                "assets/images/Talking_Point-NoSub-trans.png",
                width: MediaQuery.of(context).size.width * .3,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Get Started Now",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 29,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Create an account or log in to vote!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 25),
          child: Column(
            children: [
              _toggleButtons(),
              SizedBox(height: 20),
              showLogin ? _buildLoginForm() : _buildSignupForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _toggleButtons() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Color(0xFFF1F2F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildToggleButton("Log In", showLogin, () {
            setState(() {
              showLogin = true;
            });
          }),
          _buildToggleButton("Sign Up", !showLogin, () {
            setState(() {
              showLogin = false;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(4), // Add spacing between button and outer border
          child: Container(
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                color: Color.fromRGBO(45, 50, 80, 1.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label("Email"),
        RoundedTextFormField(
          prefixIcon: Icons.email_outlined,
          hintText: "Email address",
        ),

        SizedBox(height: 16),

        _label("Password"),
        RoundedTextFormField(
          prefixIcon: Icons.lock_outline,
          hintText: "Password",
          obscureText: true,
        ),

        SizedBox(height: 10),

        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Colors.blue, fontSize: 12),
          ),
        ),

        SizedBox(height: 16),

        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(33, 150, 243, 1.0),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text("Login", style: TextStyle(fontSize: 15)),
        ),

        SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: .6),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Or",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),

            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: .6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label("Username"),
        RoundedTextFormField(
          prefixIcon: Icons.person_outline,
          hintText: "Username",
        ),

        SizedBox(height: 16),

        _label("Email"),
        RoundedTextFormField(
          prefixIcon: Icons.email_outlined,
          hintText: "Email address",
        ),

        SizedBox(height: 16),

        _label("Password"),
        RoundedTextFormField(
          prefixIcon: Icons.lock_outline,
          hintText: "Create password",
          obscureText: true,
        ),

        SizedBox(height: 25),

        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(33, 150, 243, 1.0),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text("Sign Up", style: TextStyle(fontSize: 15)),
        ),

        SizedBox(height: 15),

        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: .6),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Or",
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),

            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: .6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          color: Color.fromRGBO(110, 110, 110, 1.0),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
