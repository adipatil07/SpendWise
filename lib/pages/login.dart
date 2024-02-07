import 'package:flutter/material.dart';
import 'package:spendwise/pages/dashboard.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Welcome Back, \nPlease Login to Continue",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Username",
                          hintText: "Enter your Username",
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter your Password",
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                          );
                        },
                        child: SizedBox(
                          width: 100,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Login",
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
        ],
      ),
    );
  }
}
