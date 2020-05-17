import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Container(

      color: Color.fromRGBO(30, 31, 45, 1),

      child: Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 100,
          
        ),
      ),
    );
  }


}