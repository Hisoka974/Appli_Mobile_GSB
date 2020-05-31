import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:string_validator/string_validator.dart';
import '../Modèles/fonctions.dart';
import 'package:flutter/material.dart';
import '../Bdd/bdd.dart';


class AjouterVisiteur extends StatefulWidget {
  @override
  _AjouterVisiteur createState() => _AjouterVisiteur();
}

class _AjouterVisiteur extends State<AjouterVisiteur> {

  static BaseDeDonnees bdd = BaseDeDonnees.OuvrirConnexion;
  final _frmConnexion = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    //Variables qui serviront à récupérer le texte des tb
    var _tbNom, _tbPrenom, _tbEmail, _tbTel, _tbAdr, _tbDob, _tbObj = TextEditingController();




    //Définitions des textboxs
    final tbNom =TextFormField(
      controller: _tbNom,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez un nom') ;
        }
        return null;
      },

      onSaved: (String value){

      },


      decoration: InputDecoration(
        labelText:'Nom',
        icon: Icon(Icons.person,size: 30)
      ),
    );

    final tbPrenom =TextFormField(
      controller: _tbPrenom,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez un prénom') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Prénom',
          icon: Icon(Icons.person,size: 30)
      ),
    );

    final tbEmail =TextFormField(
      controller: _tbEmail,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez un e-mail') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'E-mail',
          icon: Icon(Icons.email,size: 30)
      ),
    );

    final tbTel =TextFormField(
      controller: _tbTel,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez un numéro de téléphone') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Téléphone',
          icon: Icon(Icons.phone_android,size: 30)
      ),
    );

    final tbAdr =TextFormField(
      controller: _tbAdr,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez une adresse postale') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Adresse postale',
          icon: Icon(FontAwesomeIcons.houseUser)
      ),
    );

    final tbDateNaiss =TextFormField(
      controller: _tbDob,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez une date de naissance') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Date de naissance',
          icon: Icon(FontAwesomeIcons.calendar)
      ),
    );

    final tbObjAnn =TextFormField(
      controller: _tbObj,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez un objectif annuel') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Objectif annuel',
          icon: Icon(Icons.assessment)
      ),
    );











    return
        Form(
          key:_frmConnexion ,
          child: Scaffold(
            backgroundColor: Colors.blue,
            appBar: AppBar(
            title: Text('Ajouter un Visiteur'),
            ),
            body: Center(
                  child: Container(
                    margin: EdgeInsets.only(left: 10, top: 70, right: 10, bottom: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],

                    ),

                    //On vient ajouter toutes les textboxs
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        tbNom,
                        tbPrenom,
                        tbAdr
                      ],
                    ),
                  ),
            ),
          ),
        );
  }
}