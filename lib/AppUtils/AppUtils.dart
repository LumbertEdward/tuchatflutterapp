import 'package:connectivity/connectivity.dart';

class CheckConnectivityClass{

  static Future<bool> checkInternet() async{
    var connected = await (Connectivity().checkConnectivity());
    if(connected == ConnectivityResult.mobile || connected == ConnectivityResult.wifi){
      return true;
    }
    else{
      return false;
    }
  }
}