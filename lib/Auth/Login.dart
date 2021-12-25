import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/Auth/Register.dart';
import 'package:tuchatapp/Classes/Home.dart';
import 'package:tuchatapp/sqflitedatabase/DatabaseHelper/DatabaseHelper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool status = false;

  Future<void> loginUser() async{
    if(emailController.text != "" || passwordController.text != ""){
      setState(() {
        status = true;
      });
      var user = await DatabaseHelper.instance.loginUser(emailController.text, passwordController.text);

      if(user.isNotEmpty){
        Fluttertoast.showToast(msg: "Login successful", toastLength: Toast.LENGTH_LONG);
        setState(() {
          status = false;
        });
        var sharedPrefs = await SharedPreferences.getInstance();
        sharedPrefs.setString("firstName", user[0].firstName);
        sharedPrefs.setString("lastName", user[0].lastName);
        sharedPrefs.setString("email", user[0].email);
        sharedPrefs.setString("phone", user[0].phone);
        sharedPrefs.setString("userId", user[0].userId);

        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      }else{
        Fluttertoast.showToast(msg: "Wrong username or password", toastLength: Toast.LENGTH_LONG);
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
      body: SafeArea(
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
                    Text("Login", style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8,),
                    Text("login to continue", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400)),
                  ],
                ),
              ),
              SizedBox(height: 20,),
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
                    onPressed: loginUser,
                    child: Text("Login",),
                    style: ElevatedButton.styleFrom(
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(13),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Register", style: TextStyle(color: Colors.blue, fontSize: 15),
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
      )
    );
  }
}
