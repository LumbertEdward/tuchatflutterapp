import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuchatapp/Models/Member.dart';
import 'package:tuchatapp/sqflitedatabase/DatabaseHelper/DatabaseHelper.dart';

import 'Home.dart';
import 'Messages.dart';

class CodeVerification extends StatefulWidget {
  const CodeVerification({Key? key}) : super(key: key);

  @override
  _CodeVerificationState createState() => _CodeVerificationState();
}

class _CodeVerificationState extends State<CodeVerification> {
  TextEditingController one = TextEditingController();
  TextEditingController two = TextEditingController();
  TextEditingController three = TextEditingController();
  TextEditingController four = TextEditingController();
  TextEditingController five = TextEditingController();
  TextEditingController six = TextEditingController();

  Future<void> checkCode() async{
    var sharedPrefs = await SharedPreferences.getInstance();
    var code = sharedPrefs.getString("code") ?? "";
    var userId = sharedPrefs.getString("userId") ?? "";
    var grpId = sharedPrefs.getString("AddedGroupId") ?? "";
    var receivedCode = one.text + two.text + three.text + four.text + five.text + six.text;
    if(receivedCode == ""){
      Fluttertoast.showToast(msg: "Incomplete Code", toastLength: Toast.LENGTH_LONG);
    }
    else{
      if(code == ""){
        Fluttertoast.showToast(msg: "No Code", toastLength: Toast.LENGTH_LONG);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
      }
      else{
        if(code == receivedCode){
          var member = Member(userId: userId, groupId: grpId, code: code, dateAdded:
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());
          var response = await DatabaseHelper.instance.addMember(member);
          if(response > 0){
            var sharedPrefs = await SharedPreferences.getInstance();
            sharedPrefs.setString("chatGroupId", grpId);
            Fluttertoast.showToast(msg: "added", toastLength: Toast.LENGTH_LONG);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Messages()));
          }else{
            Fluttertoast.showToast(msg: "Not added", toastLength: Toast.LENGTH_LONG);
          }

        }
        else{
          Fluttertoast.showToast(msg: "Code does not match", toastLength: Toast.LENGTH_LONG);
        }

      }
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(10),
                child: SizedBox(
                  height: 90,
                  width: 90,
                  child: Image(
                    image: AssetImage("images/logotuchat.png"),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                child: Text("Code Verification", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                child: Text("Enter code sent", style: TextStyle(color: Colors.white54),),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: SizedBox(
                            width: 13,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                 counterText: ""
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: one,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: SizedBox(
                            height: 2,
                            width: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: SizedBox(
                            width: 13,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: ""
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: two,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: SizedBox(
                            height: 2,
                            width: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: SizedBox(
                            width: 13,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: ""
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: three,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: SizedBox(
                            height: 2,
                            width: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: SizedBox(
                            width: 13,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: ""
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: four,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: SizedBox(
                            height: 2,
                            width: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: SizedBox(
                            width: 13,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: ""
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: five,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: SizedBox(
                            height: 2,
                            width: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                          child: SizedBox(
                            width: 13,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: ""
                              ),
                              style: TextStyle(color: Colors.white),
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              controller: six,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),
                          child: SizedBox(
                            height: 2,
                            width: 14,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () async{
                    var prefs = await SharedPreferences.getInstance();
                    var pn = prefs.getString("phone") ?? "";
                    FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: "+254$pn",
                        verificationCompleted: (PhoneAuthCredential authCredential) async{
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString("code", authCredential.smsCode.toString());
                        },
                        verificationFailed: (FirebaseAuthException firebaseAuthException) {
                          Fluttertoast.showToast(msg: "Verification Failed", toastLength: Toast.LENGTH_LONG);
                        },
                        codeSent: (String verificationId, int? forceResendingToken){

                        },
                        codeAutoRetrievalTimeout: (String timeout){

                        });
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "Didn't receive the code? ", style: TextStyle(color: Colors.white),
                        children: <TextSpan>[
                          TextSpan(text: "Resend Code", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold))
                        ]
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: checkCode,
                    child: Text("Verify", style: TextStyle(color: Colors.blue),),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
