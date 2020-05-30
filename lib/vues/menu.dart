
import 'package:flutter/material.dart';

import 'Connexion.dart';

class Menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State<Menu> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));

  Future<bool> _alert() {
   
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
          title: const Text('AppBar Demo'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show Snackbar',
              onPressed: () {
                scaffoldKey.currentState.showSnackBar(snackBar);
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Next page',
              onPressed: () {

              },
            ),
          ],
        ),
        body:
          const Center(
            child: Text(
              'This is the home page',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ), onWillPop: (){
      _alert();
    },
    );
  }
}