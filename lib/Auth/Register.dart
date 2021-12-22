import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tuchatapp/Auth/Login.dart';
import 'package:tuchatapp/Models/User.dart';
import 'package:tuchatapp/sqflitedatabase/DatabaseHelper/DatabaseHelper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool status = false;

  Future<void> registerUser() async{
    if(firstNameController.text != "" || lastNameController.text != "" || emailController.text != "" ||
        phoneController.text != "" || passwordController.text != ""){

      setState(() {
        status = true;
      });

      var user = User(userId: Random().nextInt(1000).toString(),
          firstName: firstNameController.text, lastName: lastNameController.text,
          phone: phoneController.text, password: passwordController.text, email: emailController.text);

      var response = await DatabaseHelper.instance.registerUser(user);

      if(response > 0){
        Fluttertoast.showToast(msg: "Registration successful", toastLength: Toast.LENGTH_LONG);
        setState(() {
          status = false;
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
      else{
        Fluttertoast.showToast(msg: "Registration not successful", toastLength: Toast.LENGTH_LONG);
        setState(() {
          status = false;
        });
      }
    }
    else{
      Fluttertoast.showToast(msg: "Parameter Missing", toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 13, right: 13, top: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Register", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8,),
                        Text("Sign up to continue", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "First Name",
                          hintText: "First Name",
                        prefixIcon: Icon(Icons.person)
                      ),
                      keyboardType: TextInputType.text,
                      controller: firstNameController,
                    ),
                  ),
                  SizedBox(height: 1,),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "lastname",
                          hintText: "Last Name",
                          prefixIcon: Icon(Icons.person)
                      ),
                      keyboardType: TextInputType.text,
                      controller: lastNameController,
                    ),
                  ),
                  SizedBox(height: 1,),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter Email",
                          hintText: "Enter Email",
                          prefixIcon: Icon(Icons.email)
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                  ),
                  SizedBox(height: 1,),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Valid Phone Number (ignore +254)",
                        hintText: "Valid Phone Number (ignore +254)",
                          prefixIcon: Icon(Icons.phone)
                      ),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                    ),
                  ),
                  SizedBox(height: 1,),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "password",
                        hintText: "Enter Password",
                          prefixIcon: Icon(Icons.lock)
                      ),
                      controller: passwordController,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(13),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        child: Text("Register",),
                        style: ElevatedButton.styleFrom(
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(13),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? login", style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                        ),
                      )
                  ),
                  status ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(height: 30,),
                      SizedBox(height: 20, width: 20, child: CircularProgressIndicator(),),
                      SizedBox(height: 30,),
                    ],
                  ): Row()
                ],
              ),
            )
        ),
      ),
    );
  }
}
