import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/auth/wrapper.dart';
import 'package:ohstel_food_market_app/food/pages/food_home.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FoodHomePage(),
                  ),
                );
              },
              child: Text('Food'),
            ),
          ),
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MarketWrapper(),
                  ),
                );
              },
              child: Text('Market'),
            ),
          )
        ],
      ),
    );
  }
}
