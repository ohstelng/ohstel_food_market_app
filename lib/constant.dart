import 'package:flutter/material.dart';


final String baseApiUrl = 'http://178.79.132.197:8080';

void showDonePopUp({@required BuildContext context, @required String message}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text('Message'),
        content: Text(
          '$message',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        ],
      );
    },
  );
}


Map categoryMap = {
  'Foodstuff': [
    'Grains and Rice',
    'Oil',
    'Canned Foods',
    'Spices and Seasonings',
    'Juices, Soft Drinks and Water',
    'Sugars',
    'Noodles and Pasta',
    'Breakfast and Beverages',
  ],
  'Hostel Cleaning': [
    'Laundry',
    'Dish washing',
    'Bathroom and Toilet cleaners',
    'Air Fresheners',
    'Toilet Paper',
    'Disinfectant Wipes',
  ],
  'Bed and Beddings': [
    'Mattress',
    'Blanket and Duvet',
    'Bed Cover',
    'Pillow and Home Decor',
  ],
  'Men Fashion': [
    'Clothing',
    'Men Shoes',
    'Men Accessories',
    'Men Watches',
  ],
  'Women Fashion': [
    'Clothing',
    'Women Shoes',
    'Women Accessories',
    'Women Watches',
  ],
  'Educational Needs': [
    'Board and Accessories',
    'School Bags',
    'School Shoes',
    'Canvas',
  ],
  'Health and Beauty': [
    'Hair Care',
    'Body Care',
    'Fragrance and Perfume',
    'Make Up',
    'Teeth',
    'Health and Personal Care',
  ],
  'Phone and Tablets': [
    'Phones',
    'Tablets',
    'Mobile Phone Accessories',
  ],
  'Stationeries': [
    'Books',
    'Writing Materials',
    'Calculators',
    'Engineering Needs',
    'Handouts and Materials',
  ],
};
