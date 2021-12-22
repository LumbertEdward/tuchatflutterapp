import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuchatapp/Auth/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 3000), (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
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
