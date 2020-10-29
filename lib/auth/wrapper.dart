import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/auth/pages/login_page.dart';
import 'package:ohstel_food_market_app/market_place/pages/market_home_page.dart';
import 'package:provider/provider.dart';

import 'methods/auth_methods.dart';
import 'models/login_user_model.dart';

class MarketWrapper extends StatefulWidget {
  @override
  _MarketWrapperState createState() => _MarketWrapperState();
}

class _MarketWrapperState extends State<MarketWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<LoginUserModel>.value(
      value: AuthService().userStream,
      child: MaterialApp(
        title: "O'Hstel Agent",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // this wrapper class is here to monitor the auth changes, it returns home
    // page if the user is already logged in and login page if not instance of
    // login is present(no user is already logged in) or the user logged out.
    // provider is being used to monitor the UserStream in the auth method class

    final user = Provider.of<LoginUserModel>(context);

    if (user == null) {
      return ToggleBetweenLoginAndSignUpPage();
    } else {
      return MarketHomePage();
    }
  }
}
