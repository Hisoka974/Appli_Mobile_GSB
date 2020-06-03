import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppe/Mod%C3%A8les/Visiteur.dart';
import 'package:ppe/Mod%C3%A8les/fonctions.dart';
import 'package:ppe/vues/menu.dart';
import 'package:string_validator/string_validator.dart';
import 'package:flutter/material.dart';
import '../Bdd/bdd.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';


class ModifierVisiteur extends StatefulWidget {


  final Visiteur monVisiteur;
  final int index;

  //On récupère le visiteur à modifier
  ModifierVisiteur({Key key, @required this.monVisiteur, @required this.index}) : super(key: key);

  @override
  _ModifierVisiteur createState() => _ModifierVisiteur();
}

class _ModifierVisiteur extends State<ModifierVisiteur> {

  BaseDeDonnees bdd = BaseDeDonnees.OuvrirConnexion;
  final _frmConnexion = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //Variables qui serviront à récupérer le texte des tb
    var _tbNom = TextEditingController();
    _tbNom.text = widget.monVisiteur.getNom;

    var _tbPrenom= TextEditingController();
    _tbPrenom.text = widget.monVisiteur.getPrenom;

    var _tbEmail = TextEditingController();
    _tbEmail.text = widget.monVisiteur.getMail;

    var _tbTel = TextEditingController();
    _tbTel.text = widget.monVisiteur.getTel;

    var _tbAdr = TextEditingController();
    _tbAdr.text = widget.monVisiteur.getAdr;

    var _tbDob = TextEditingController();
    _tbDob.text = widget.monVisiteur.getDatNaiss;

    var _tbObj = TextEditingController();
    _tbObj.text= widget.monVisiteur.getObjAnnuel.toString();




    Future<bool> _confirmer(){

      return showDialog(context: context, builder:
          (context) => AlertDialog(
        title: Text('Etes vous sur ?'),
        content: Text('Vous allez modifier les informations de '+widget.monVisiteur.getNom+" "+widget.monVisiteur.getPrenom),
        actions: <Widget>[
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Oui'),
            onPressed: (){
              var res = bdd.ModifierVisiteur(widget.monVisiteur.getId, _tbNom.text, _tbPrenom.text, _tbTel.text, _tbAdr.text, _tbDob.text, _tbEmail.text, int.parse(_tbObj.text), widget.index);
              res.then((retour){
                if(retour =='OK')
                {
                  Navigator.of(context).pop(false);
                  fonctions.affciherToast('Modification effectuée', Colors.green);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Menu()),
                  );
                } else{
                  fonctions.affciherToast('Une erreur est survenue lors de la modification', Colors.red);
                }
              });
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



    //Définitions des textboxs
    final tbNom =TextFormField(
      controller: _tbNom,
      validator: (value){
        if(value.isEmpty || isNumeric(value)){
          return('Veuillez entrez un nom') ;
        }

        return null;
      },
      decoration: InputDecoration(
          labelText:'Nom',
          icon: Container( margin: EdgeInsets.only(top: 20) ,child:Icon(Icons.person,size: 30,))
      ),
    );

    final tbPrenom =TextFormField(
      controller: _tbPrenom,
      validator: (value){
        if(value.isEmpty || isNumeric(value)){
          return('Veuillez entrez un prénom') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Prénom',
          icon: Container( margin: EdgeInsets.only(top: 20) ,child:Icon(Icons.person,size: 30))
      ),
    );

    final tbEmail =TextFormField(
      controller: _tbEmail,
      validator: (value){
        if(value.isEmpty || !value.contains("@")){
          return('Veuillez entrez un e-mail') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'E-mail',
          icon: Container( margin: EdgeInsets.only(top: 20), child:Icon(Icons.email,size: 30))

      ),
    );

    final tbTel =TextFormField(
      controller: _tbTel,
      maxLength: 10,
      maxLengthEnforced: true,
      keyboardType: TextInputType.number,
      validator: (value){
        if(value.isEmpty || !isNumeric(value) || !isNumeric(value.replaceAll(' ', '')) || !isNumeric(value.replaceAll('-', ''))){
          return('Veuillez entrez un numéro de téléphone valide') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Téléphone',
          icon: Container( margin: EdgeInsets.only(top: 20), child:Icon(Icons.phone_android,size: 30))
      ),
    );

    final tbAdr =  TextFormField(
      controller: _tbAdr,
      validator: (value){
        if(value.isEmpty){
          return('Veuillez entrez une adresse postale') ;
        }
        return null;
      },
      decoration: InputDecoration(
          labelText:'Adresse postale',
          icon: Container( margin: EdgeInsets.only(top: 20), child:Icon(FontAwesomeIcons.houseUser))
      ),
    );

    final tbDateNaiss = DateTimeField(
      controller: _tbDob,
      validator: (value){
        if(value.toString() == ""){
          return('Veuillez entrez une date de naissance') ;
        }
        return null;
      },

      format: DateFormat('dd/MM/yyyy'),
      onShowPicker: (context, currentValue) {
        return showDatePicker(
            context: context,
            firstDate: DateTime(1900),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
      },

      decoration:  InputDecoration(
        icon: Container( margin: EdgeInsets.only(top: 20), child:Icon(Icons.calendar_today)),
        labelText: 'Date de naissance',
      ),
      resetIcon: Icon(Icons.autorenew),

    );

    final tbObjAnn =TextFormField(
      controller: _tbObj,
      keyboardType: TextInputType.number,
      validator: (value){
        if(value.isEmpty || !isNumeric(value)|| !isNumeric(value.replaceAll(' ', ''))){
          return('Veuillez entrez un objectif annuel') ;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText:'Objectif annuel',
        icon: Container( margin: EdgeInsets.only(top: 20), child: Icon(Icons.assessment)),
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
            _confirmer();
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Valider', style: TextStyle(color: Colors.white)),
      ),
    );



    return
      Form(
        key:_frmConnexion ,
        child: Scaffold(
          backgroundColor: Colors.blue,
          appBar: AppBar(
            title: Text(widget.monVisiteur.getNom+" "+widget.monVisiteur.getPrenom),
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
                  tbAdr,
                  tbTel,
                  tbDateNaiss,
                  tbEmail,
                  tbObjAnn,
                  Container(
                    height: 10,
                  ),
                  btnValider,
                ],
              ),
            ),
          ),
        ),
      );
  }
}