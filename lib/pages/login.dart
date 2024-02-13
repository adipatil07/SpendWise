import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spendwise/pages/dashboard.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  // Snackbar to show login failure
  void showLoginFailedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login failed. Please try again.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    login(String email, String pass) async {
      UserCredential? userCredential;
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
      } on FirebaseAuthException catch (ex) {
        // Show login failure message
        showLoginFailedSnackbar();
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3, // 30% of screen height
              child: Image.asset(
                "images/bg4.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3, // Start login form below the image
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              color: Colors.white,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Welcome Back, \nPlease Login to Continue",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter your Email",
                        ),
                        validator: (value) {
                          if (value == "") {
                            return "Please enter your email";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your Password",
                        ),
                        validator: (value) {
                          if (value == "") {
                            return "Please enter your password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey2.currentState!.validate()) {
                            login(emailController.text.toString(), passController.text.toString());
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 19),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
