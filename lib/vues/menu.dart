
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'Connexion.dart';
import '../Modèles/fonctions.dart';
import 'ajouterVisiteur.dart';

class Menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));

  Future<bool> _Deconnexion() {
   
    return showDialog(context: context, builder:
    (context) => AlertDialog(
      title: Text('Etes vous sur ?'),
      content: Text('Vous allez être déconnecté de l''application'),
      actions: <Widget>[
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Oui'),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Connexion()),
            );
          },
        ),
        FlatButton(
          color: Colors.red,
          textColor: Colors.white,
          child: Text('Non'),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        )
      ],
    )

    );

  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('GSB Mobile - Visiteurs'),
          actions: <Widget>[


          ],
        ),
        body:
           Center(
            child: Container(

            )
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.person_add),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AjouterVisiteur()),
              );
            },
          ),
        ), onWillPop: (){
      _Deconnexion();
    },
    );
  }
}