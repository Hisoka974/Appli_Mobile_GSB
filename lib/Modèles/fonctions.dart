import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class  fonctions{

  //Collection de visiteurs
 static void affciherToast(String message, Color couleur){
        Fluttertoast.showToast(

            msg: message,
            backgroundColor:couleur,
            textColor: Colors.white
        );
  }


}