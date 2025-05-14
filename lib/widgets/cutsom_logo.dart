import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 90,
              width: 90,
              child: Image(
                image: AssetImage('images/icons/buyicon1.png'),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Text(
                'Buy it',
                style: TextStyle(fontFamily: 'Pacifico', fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
