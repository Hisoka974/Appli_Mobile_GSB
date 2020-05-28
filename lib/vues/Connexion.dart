import 'package:flutter/material.dart';

class Connexion extends StatefulWidget {
  @override
  _Connexion createState() => _Connexion();
}

class _Connexion extends State<Connexion> {
  @override
  Widget build(BuildContext context) {

    final _frmConnexion = GlobalKey<FormState>();

    //Logo
    final logo =Hero(
      tag: 'gsb',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/logo.png'),
      ),
    );

    //input Login
    final tblogin =TextFormField(
      validator: (value){
          if(value.isEmpty){
            return('Veuillez entrez votre login') ;
          }
          return null;
      },
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        hintText:'Entrez votre login',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        )
      ),
    );

    //input Mot de passe
    final tbmdp =TextFormField(
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez votre mot de passe') ;
        }
        return null;
      },

      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
          hintText:'Entrez votre mot de passe',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
      ),
    );


    //Bouton Valider

    final btnValider = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
            if(_frmConnexion.currentState.validate()){
              
            }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Connexion', style: TextStyle(color: Colors.white)),
      ),
    );

    //Formulaire de connexion
    return Form(
      key: _frmConnexion,
      child: Scaffold(
        backgroundColor: Colors.white,
        body:Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              SizedBox(
                height: 48.0,
              ),
              tblogin,
              SizedBox(
                height: 8.0,
              ),
              tbmdp,
              SizedBox(
                height: 48.0,
              ),
              btnValider,
            ],
          ),
        ),
      ),
    );
  }
}

