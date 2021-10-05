import 'package:flutter/material.dart';
import 'package:flutter_google_signin/services/authentication.dart';

class HomePage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignOut;
  final String userId;

  const HomePage({Key key, this.auth, this.onSignOut, this.userId})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool emailIsVerified = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _checkEmailVerified() async {
    emailIsVerified = await widget.auth.isEmailVerified();
    if (!emailIsVerified) {
      _showDialogKonfirmasi();
    }
  }

  void _showDialogKonfirmasi() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Silahkan verifikasi akun anda"),
            content: Text("LInk to Verify account has been emaii"),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  resendEmail();
                },
                child: Text("Resend Link"),
              )
            ],
          );
        });
  }

  void resendEmail() {
    widget.auth.sendEmailVerification();
    _showDialogVerifikasiEmail();
  }

  void _showDialogVerifikasiEmail(){
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Silahkan verifikasi akun anda"),
            content: Text("LInk to Verify account has been emaii"),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);

                },
                child: Text("dismiss"),
              )
            ],
          );
        });
  }

  _signOut() async {
    try{
      await widget.auth.signOut();
      widget.onSignOut;
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Apps"),
        backgroundColor: Colors.green,
        actions: [
          FlatButton(onPressed: _signOut, child: Text("LogOUt"))
        ],
      ),
    );
  }
}
