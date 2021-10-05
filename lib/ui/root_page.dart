import 'package:flutter/material.dart';
import 'package:flutter_google_signin/services/authentication.dart';
import 'package:flutter_google_signin/ui/home_page.dart';
import 'package:flutter_google_signin/ui/login_status.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  const RootPage({Key key, this.auth}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

//status Auth
enum AuthStatus{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN
}
class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String userId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((user){
      setState(() {
        if(user != null){
          userId = user.uid;
        }
        authStatus = user.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user){
      setState(() {
        userId = user.uid.toString();
      });
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    });
  }

  void _onSignOut(){
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      userId = "";
    });
  }


  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.NOT_DETERMINED:
      return _buildWaitingScreen();
      break;
      case AuthStatus.NOT_LOGGED_IN:
      return LoginSignUpPage(
        auth: widget.auth,
        onLoggedIn: _onLoggedIn,
      );
      break;
      case AuthStatus.LOGGED_IN:
      if(userId.length > 0 && userId != null){
        return HomePage(
          userId: userId,
          auth: widget.auth,
          onSignOut: _onSignOut,
        );
      }else return _buildWaitingScreen();
      break;
      default:
        return _buildWaitingScreen();
    }
    return Container(

    );
  }
  Widget _buildWaitingScreen(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
