import 'package:flutter/material.dart';
import 'package:ohstel_food_market_app/widgets/styles.dart' as Styles;

class LongButton extends StatelessWidget {
  final bool shadow;
  final bool border;
  final Color borderColor;
  final Color color;
  final Color labelColor;
  final String label;
  final Function onPressed;
  const LongButton({
    Key key,
    this.color = Styles.themePrimary ,
    @required this.onPressed,
    this.labelColor = Colors.white,
    @required this.label,
    this.shadow = false, this.border = false, this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 59,
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: border ? Border.all(color: borderColor):null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: shadow
            ? [
          BoxShadow(
            offset: Offset(0, 4),
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
          ),
        ]
            : null,
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: color,
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        onPressed: onPressed,
        child: Text(
          label ?? "",
          style: TextStyle(
            fontSize: 24,
            color: labelColor,
          ),
        ),
      ),
    );
  }
}
