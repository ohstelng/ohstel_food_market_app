import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/auth/methods/auth_methods.dart';
import 'package:ohstel_food_market_app/market_place/pages/add_new_product_page.dart';
import 'package:ohstel_food_market_app/market_place/pages/add_partner_page.dart';
import 'package:ohstel_food_market_app/market_place/pages/shop_owner_orders_page.dart';
import 'package:ohstel_food_market_app/market_place/pages/shop_owner_product_page.dart';

class MarketHomePage extends StatefulWidget {
  @override
  _MarketHomePageState createState() => _MarketHomePageState();
}

class _MarketHomePageState extends State<MarketHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Market Home Page')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddPartnerPage(),
                  ),
                );
              },
              child: Text(
                'Add Partner Page',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddNewMarketProductPage(),
                  ),
                );
              },
              child: Text(
                'Add New Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopOwnerOrders(),
                  ),
                );
              },
              child: Text(
                'View Shop Owners Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Center(
            child: FlatButton(
              color: Colors.green,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopOwnerProductPage(),
                  ),
                );
              },
              child: Text(
                'View Shop Owners Product',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 200),
          Center(
            child: FlatButton(
              color: Colors.red,
              onPressed: () async {
                await AuthService().signOut();
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
