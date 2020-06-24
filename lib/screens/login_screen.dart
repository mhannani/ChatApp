//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogInScreen extends StatefulWidget {
//  static String routeName = 'choice/log_in';
//  final void Function(
//    String email,
//    String password,
//    BuildContext ctx,
//  ) logIn;
//
//  LogInScreen(this.logIn);

  _AuthScreen createState() => _AuthScreen();
}

class _AuthScreen extends State<LogInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> _logIn(String email, String password,BuildContext ctx) async {
    // Log in the registered user with credential provided :
    try {
      final logInResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (e) {
      var message = "Oops! something went wrong";
      if (e.message != null) {
        // If the error occurred ;
        message = e.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      print(message);
    }
  }
  void _validateInputs(BuildContext context) {
    final _isValid = _formKey.currentState.validate();
    if (_isValid) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus();
      // send a authentication request for the existing user trying to log in :
//      widget.logIn(_email.text, _password.text, context);
      _logIn(_email.text, _password.text, context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.white,
      body: Padding(

        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, //vert
//            mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center, // horiz.
          children: [
            Form(
              key: _formKey,
              child: Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
//              crossAxisAlignment: CrossAxisAlignment.s,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        controller: _email,
//                    keyboardAppearance: Brightness.dark,
                        keyboardType: TextInputType.emailAddress,
//                    autofocus: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.user,
                            size: 16,
                          ),
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(fontSize: 10.0),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0.0),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (email) {
                          if (EmailValidator.validate(email)) {
                            return null;
                          }
                          return 'Oops! You entered invalid email ';
                        },
                        onSaved: (email) {
                          _email.text = email;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            FontAwesomeIcons.key,
                            size: 16,
                          ),
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(fontSize: 10.0),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 0.0),
                        ),
                        textInputAction: TextInputAction.send,
                        validator: (password) {
                          if (password.length > 7) {
                            return null;
                          }
                          return 'Oops! Weak password';
                        },
                        onSaved: (password) {
                          _password.text = password;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FlatButton(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
              onPressed: () => _validateInputs(context),
              color: Colors.lightBlueAccent,
              child: Text(
                'LOG IN',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
