import 'package:flutter/material.dart';
import 'package:flutter_google_signin/services/authentication.dart';

class LoginSignUpPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onLoggedIn;

  const LoginSignUpPage({Key key, this.auth, this.onLoggedIn})
      : super(key: key);

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = GlobalKey<FormState>();

  String email, password, errorMessage;

  FormMode formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _validateAndSubmit() async {
    String userId = "";
    try {
      if (formMode == FormMode.LOGIN) {
        userId = await widget.auth.signIn(email, password);
        print("UserId $userId");
      } else {
        userId = await widget.auth.signUp(email, password);
        widget.auth.sendEmailVerification();
        _showDialogVerif();
      }
      setState(() {
        _isLoading = false;
      });
      if (userId.length > 0 && userId != null && formMode == FormMode.LOGIN) {
        widget.onLoggedIn();
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
        if (_isIos) {
          errorMessage = e.toString();
        } else {
          errorMessage = e.toString();
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    errorMessage = "";
    _isLoading = false;
  }

  void _changeFormSignUp() {
    _formKey.currentState.reset();
    errorMessage = "";
    setState(() {
      formMode = FormMode.SIGNUP;

    });
  }

  void _changeFormLogin() {
    _formKey.currentState.reset();
    errorMessage = "";
    setState(() {
      formMode = FormMode.LOGIN;
    });
  }

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.android;
    return Scaffold(
      appBar: AppBar(
        title: Text("Food Apps"),
      ),
      body: Stack(
        children: [
          _showBody(),
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _showBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Form(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: TextFormField(
                maxLines: 1,
                decoration: InputDecoration(hintText: "Email Address"),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: TextFormField(
                obscureText: true,
                maxLines: 1,
                decoration: InputDecoration(hintText: "Password"),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.only(top: 45),
              child: MaterialButton(
                onPressed: () {
                  _validateAndSubmit();
                },
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.green,
                child: formMode == FormMode.LOGIN
                    ? Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )
                    : Text(
                        "Create Account",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                formMode == FormMode.LOGIN
                    ? _changeFormSignUp()
                    : _changeFormLogin();
              },
              child: formMode == FormMode.LOGIN
                  ? Text("Create an acount")
                  : Text("Have an account? please signIn"),
            ),
          ],
        ),
        key: _formKey,
      ),
    );
  }

  Widget _showDialogVerif() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("verify account"),
            content: Text("LInk to Verify account has been emaii"),
            actions: [
              MaterialButton(
                onPressed: () {
                  _changeFormLogin();
                  Navigator.pop(context);
                },
                child: Text("Dismiss"),
              ),
            ],
          );
        });
  }
}
