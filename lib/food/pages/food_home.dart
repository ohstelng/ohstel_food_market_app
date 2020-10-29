import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/widgets/styles.dart' as Styles;

import 'add_new_drinks_page.dart';
import 'add_new_extra_items_page.dart';
import 'add_new_fast_food_page.dart';
import 'add_new_food_item_page.dart';
import 'food_list.dart';

class FoodHomePage extends StatefulWidget {
  @override
  _FoodHomePageState createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.grey[200],
          title: Text(
            'Food Management Console',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  child: Text(
                    "Store",
                    style: Styles.captionTextStyle,
                  ),
                  icon: Icon(
                    Icons.store,
                    color: Styles.themePrimary,
                  )),
              Tab(
                  child: Text("Item", style: Styles.captionTextStyle),
                  icon: Icon(Icons.fastfood, color: Styles.themePrimary)),
              Tab(
                  child: Text("Extras", style: Styles.captionTextStyle),
                  icon: Icon(Icons.add_shopping_cart,
                      color: Styles.themePrimary)),
              Tab(
                  child: Text("Drinks", style: Styles.captionTextStyle),
                  icon: Icon(Icons.local_drink, color: Styles.themePrimary)),
              Tab(
                child: Text("Menu", style: Styles.captionTextStyle),
                icon: Icon(Icons.restaurant_menu, color: Styles.themePrimary),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddNewFastFood(),
            AddNewFoodItemPage(),
            AddExtraItemPage(),
            AddNewDrinksPage(),
            FastFoodListPage(),
          ],
        ),
      ),
    );
  }
}
