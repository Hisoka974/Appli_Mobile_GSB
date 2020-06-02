import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Bdd/bdd.dart';
import '../Modèles/fonctions.dart';
import 'menu.dart';

class Connexion extends StatefulWidget {
  @override
  _Connexion createState() => _Connexion();
}

class _Connexion extends State<Connexion> {

 static BaseDeDonnees bdd = BaseDeDonnees.OuvrirConnexion;





  @override
  Widget build(BuildContext context) {


    //Fonction pour fermer l'application
    Future<bool> _fermerAppli() {


      return showDialog(context: context, builder:
          (context) => AlertDialog(
        title: Text('Etes vous sur ?'),
        content: Text('Vous allez quitter l''application'),
        actions: <Widget>[
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Oui'),
            onPressed: (){
              bdd.fermerConnexion();
              SystemNavigator.pop();
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

    final _frmConnexion = GlobalKey<FormState>();

    //Champs
    final _tbmdp = TextEditingController();
    final _tblogin = TextEditingController();
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
      controller: _tblogin,
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
      controller: _tbmdp,
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
              var res = bdd.testConnexion(_tblogin.text, _tbmdp.text);

              //On test si les identifiants sont corrects
              res.then((onValue){
                if(onValue==true)
                  {
                    //fonctions.affciherToast("OK", Colors.green);
                    bdd.remplirCollection();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => new Menu()),
                    );
                  } else{
                    fonctions.affciherToast("Login ou mot de passe incorrect", Colors.red);
                }

              });
              
            }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Connexion', style: TextStyle(color: Colors.white)),
      ),
    );

    //Formulaire de connexion
    return
        WillPopScope(child: Form(
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
        ), onWillPop: (){
          _fermerAppli();
        });

  }
}

