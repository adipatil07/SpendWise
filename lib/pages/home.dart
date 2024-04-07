import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/pages/dashboard.dart';
import 'package:spendwise/pages/login.dart';
import 'package:spendwise/pages/register.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      // If user is already signed in, navigate to dashboard
      return Dashboard();
    }

    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.asset(
              "images/bg4.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Login form taking 80% of the height, positioned at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: MediaQuery.of(context).size.height * 0.70,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Best Way to Save Your Money",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: SizedBox(
                            // width: 100,
                            // height: 30,
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          },
                          child: SizedBox(
                            // width: 100,
                            // height: 30,
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 19),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
