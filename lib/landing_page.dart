import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/auth/wrapper.dart';

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
//          Container(
//            height: 50,
//            child: Center(
//              child: FlatButton(
//                color: Colors.green,
//                onPressed: () {
//                  Navigator.of(context).push(
//                    MaterialPageRoute(
//                      builder: (context) => FoodHomePage(),
//                    ),
//                  );
//                },
//                child: Container(
//                  margin: EdgeInsets.all(10.0),
//                  child: Text('Food'),
//                ),
//              ),
//            ),
//          ),
          Container(
            height: 50,
            child: Center(
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MarketWrapper(),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Text('Market'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
