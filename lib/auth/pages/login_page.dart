import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ohstel_food_market_app/auth/methods/auth_methods.dart';
import 'package:ohstel_food_market_app/widgets/custom_button.dart';
import 'package:ohstel_food_market_app/widgets/custom_textfield.dart';
import 'package:ohstel_food_market_app/widgets/styles.dart' as Styles;

import 'sigup_page.dart';

class ToggleBetweenLoginAndSignUpPage extends StatefulWidget {
  @override
  _ToggleBetweenLoginAndSignUpPageState createState() =>
      _ToggleBetweenLoginAndSignUpPageState();
}

class _ToggleBetweenLoginAndSignUpPageState
    extends State<ToggleBetweenLoginAndSignUpPage> {
  bool showLogInPage = true;

  void toggleView() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LogInPage(toggleView: toggleView);
    } else {
      return SignUpPage(toggleView: toggleView);
    }
  }
}

class LogInPage extends StatefulWidget {
  final Function toggleView;

  LogInPage({this.toggleView});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String email;
  String password;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  AuthService authService = AuthService();

  Future<void> validateAndSave() async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        loading = true;
        print(loading);
      });
      print('From is vaild');
      print(email);
      print(password);
      await logInUser();
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    } else {
      Fluttertoast.showToast(msg: 'Invaild Inputs');
      setState(() {
        loading = false;
      });
    }
    print(loading);
  }

  Future<void> logInUser() async {
    await authService.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading != true
          ? SingleChildScrollView(
              child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 100),
                    Container(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Welcome Ohstel Agent',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
                    emailInputFieldBox(),
                    passwordInputFieldBox(),
                    logInButton(),
                    forgotPassword(),
                    SizedBox(height: 50),
                    signUpButton(),
                  ],
                ),
              ),
            ))
          : Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading......')
                  ],
                ),
              ),
            ),
    );
  }

  Widget emailInputFieldBox() {
    return CustomTextField(
      textInputType: TextInputType.emailAddress,
      labelText: "Email",
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Email Can\'t Be Empty';
        } else {
          return null;
        }
      },
      onSaved: (value) => email = value.trim(),
    );
  }

  Widget passwordInputFieldBox() {
    return CustomTextField(
      icon: true,
      obscureText: _obscureText,
      iconName: GestureDetector(
        child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onTap: () {
          setState(() => _obscureText = !_obscureText);
        },
      ),
      labelText: "Password",
      validator: (value) {
        if (value.trim().isEmpty) {
          return 'Password Can\'t Be Empty';
        } else {
          return null;
        }
      },
      onSaved: (value) => password = value.trim(),
    );
  }

  Widget logInButton() {
    return LongButton(
      labelColor: Colors.white,
      label: "Sign In",
      onPressed: () => validateAndSave(),
      color: Styles.themePrimary,
    );
  }

  Widget signUpButton() {
    return LongButton(
      labelColor: Colors.white,
      label: "Sign Up",
      onPressed: () => widget.toggleView(),
      color: Styles.themePrimary,
    );
  }

  Widget forgotPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          widget.toggleView();
        },
        child: Text(
          'Forgot Password ??',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    );
  }
}
