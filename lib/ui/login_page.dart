

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccoun = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccoun.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    final User user = (await _auth.signInWithCredential(credential)).user;

    _AlertDialog(user);
  }

  void _AlertDialog(User user) {
    AlertDialog dialog = AlertDialog(
      content: Container(
        height: 230,
        child: Column(
          children: [
            Text(
              "Sudah Login",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue),
            ),
            Divider(),
            CircleAvatar(
              child: Image.network(user.photoURL),
            ),
            Text("Anda sudah login sebagai ${user.displayName}"),
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (context) => dialog);
  }

  Future<void> _signOut() async {
    await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google SignIn"),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  signInWithGoogle();
                },
                child: Text(
                  "Login With Google",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                color: Colors.red,
                onPressed: () {
                  _signOut();
                },
                child: Text(
                  "LogOut",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
