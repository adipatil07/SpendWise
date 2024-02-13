import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spendwise/pages/dashboard.dart';
import 'package:spendwise/pages/transaction_page.dart';

import 'login.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController =  TextEditingController() ;

  TextEditingController passController =  TextEditingController() ;

  TextEditingController cpasscontrolller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  signUp(String email , String pass) async{
     UserCredential? userCredential;
     try{
       userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass) ;
       print("Registration Succesful");
       Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
     }
     on FirebaseAuthException catch(ex){

     }

    }

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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 50),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Join Spend-Wise Today",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            hintText: "Enter your email",
                          ),
                          validator: (value) {
                            if (value == "") {
                              return 'Email can not be empty';
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
                              return 'Password can not be empty';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          controller: cpasscontrolller,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            hintText: "Confirm Your Password",
                          ),
                          validator: (value) {
                            if (value != passController.text.toString()) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signUp(emailController.text.toString(), passController.text.toString());
                            }
                          },
                          child: SizedBox(
                            width: 100,
                            height: 30,
                            child: Center(
                              child: Text(
                                "Register",
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
