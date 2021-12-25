import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/Auth/Login.dart';
import 'package:tuchatapp/Chatts/Home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void checkUser() async{
    var sharedPrefs = await SharedPreferences.getInstance();
    var currentUser = (sharedPrefs.getString("userId") ?? "");
    if(currentUser != ""){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
    }
    else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000), (){
      checkUser();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logotuchat.png", height: 70, width: 70,),
              const SizedBox(height: 20,),
              const Text("Tuchat App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),),
              const SizedBox(height: 15,),
            ],
          ),
        ),
      )
    );
  }
}
