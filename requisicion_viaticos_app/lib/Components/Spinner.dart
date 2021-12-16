import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 255, 255, 1)),
              ),
              SizedBox(height:20),
              Text('Espere un momento...',style: TextStyle(  fontSize: 20,color: HexColor("#FFFFFF"),))
              //Theme.of(context).textTheme.headline3,)
            ],
          ),
        ),
      ),
    );
  }
}