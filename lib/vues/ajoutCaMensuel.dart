import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppe/Bdd/bdd.dart';
import 'package:ppe/Mod%C3%A8les/Visiteur.dart';
import 'package:ppe/vues/menu.dart';
import 'package:string_validator/string_validator.dart';
import '../Modèles/fonctions.dart';
import '../Modèles/Collections.dart';
import '../Modèles/Date.dart';


class ajouterCaMensuel extends StatefulWidget {

  final Visiteur monVisiteur;
  final int index;


  _ajouterCaMensuel createState() => new _ajouterCaMensuel();
  ajouterCaMensuel({ Key key, this.monVisiteur, int this.index }) : super(key: key);
}

class _ajouterCaMensuel extends State<ajouterCaMensuel> {

  BaseDeDonnees bdd = BaseDeDonnees.OuvrirConnexion;
  final _frmCa = GlobalKey<FormState>();
  //Liste des mois à afficher
  static List<Mois> listeMois;
  var indexMois = fonctions.RecupNumMois()-2;

  //Fonction pour remplir la liste des mois à afficher
  Future _remplirListeMois() {
    listeMois=[];
    //On parcourt la collection de tous les mois
    for (var i = 0; i <= indexMois; i++) {
      //Si le visiteur n'a aucun CA on affcihe tous les mois précedent le mois actuel
      if (widget.monVisiteur.getListCa.length < 1) {
        listeMois.add(collection.collectionMois[i]);
        //Sinon, on affiche uniquement les mois pour lesquels il n'a pas de CA
      } else {
        List<String> mesMoisCa = widget.monVisiteur.getMoisCA();

        if(!mesMoisCa.contains(collection.collectionMois[i].getLibelle)){
          print(collection.collectionMois[i].getLibelle);
          listeMois.add(collection.collectionMois[i]);
        }
      }
    }
  }

  //Fonction pour récupérer le mois sélectionné
  Mois _recupMois(String string){

    for (var i = 0; i <= indexMois; i++) {

      if(collection.collectionMois[i].getLibelle == string){
        return collection.collectionMois[i];
      }

    }

  }


  String selectedItem = 'rien';



  @override
  Widget build(BuildContext context) {

    _remplirListeMois();


    listeMois.forEach((ligne){
      print(ligne.getLibelle);
    });

    //Tb et bouton Valider
    var _tbCaMensuel = TextEditingController();





    //Fonction de confirmation avant ajout
    Future<bool> _confirmer(int idVisiteur, int idMois, String mois, int Ca, int index){

      return showDialog(context: context, builder:
          (context) => AlertDialog(
        title: Text('Etes vous sur ?'),
        content: Text('Voulez-vous vraiment ajouter ce chiffre d\'affaires pour le mois de : '+mois),
        actions: <Widget>[
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Oui'),
            onPressed: (){
              var res = bdd.ajouterCaMensuel(idVisiteur, idMois, mois, Ca, index);
              res.then((retour){
                if(retour =='OK')
                {
                  setState(() {
                    selectedItem='rien';
                  });
                  fonctions.affciherToast('Ajout effectué', Colors.green);
                  if(listeMois.length ==1){

                  }else{
                    Navigator.of(context).pop(false);
                  }
                } else{
                  fonctions.affciherToast('Une erreur est survenue lors de l\'ajout', Colors.red);
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

    final tbCaMensuel =TextFormField(
      controller: _tbCaMensuel,
      keyboardType: TextInputType.number,
      validator: (value){
        if(value.isEmpty || !isNumeric(value.replaceAll(' ', ''))){
          return('Veuillez entrez un chiffre D\'affaire') ;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText:'Chiffre d\'affaires',
        icon: Container( margin: EdgeInsets.only(top: 20), child: Icon(Icons.euro_symbol)),
      ),
    );


    final btnValider = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          if(_frmCa.currentState.validate()){
            var monMois = _recupMois(selectedItem);
            _confirmer(widget.monVisiteur.getId,monMois.getId, selectedItem,int.parse(_tbCaMensuel.text), widget.index);
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
    );



    //Affichage de message et retour
    //Fonction de confirmation avant ajout


if(listeMois.length == 0){
  return Scaffold(
    backgroundColor: Colors.blue,
    appBar: AppBar(
      title: Text(widget.monVisiteur.getNom+" "+widget.monVisiteur.getPrenom),
    ),
    body: Form(
      key: _frmCa,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 70, right: 10, bottom: 70),
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
              Container(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(widget.monVisiteur.getNom[0]+widget.monVisiteur.getPrenom[0], style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),

              Container(
                height: 50,
              ),

              Container(
                margin: EdgeInsets.only(top:17, left: 7),
                child:  Text('Tous les chiffres d\'affaire précédent ce mois ont été renseigné', style: TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
              ),

              Container(
                height: 50,
              ),
              FlatButton(
                color: Colors.blue,
                child: Text('Retour', style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => Menu()));
                  }
              )
            ],
          ),
        ),
      ),
    ),
  );
}
else{
  return Scaffold(
    backgroundColor: Colors.blue,
    appBar: AppBar(
      title: Text(widget.monVisiteur.getNom+" "+widget.monVisiteur.getPrenom),
    ),
    body: Form(
      key: _frmCa,
      child: Center(
        child: Container(
          margin: EdgeInsets.only(left: 10, top: 70, right: 10, bottom: 70),
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
              Container(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(widget.monVisiteur.getNom[0]+widget.monVisiteur.getPrenom[0], style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top:17, left: 7),
                child:  Text('Ajouter un chiffre d\'affaires pour : ', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),),
              ),



              Container(
                margin: EdgeInsets.only(top: 60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: DropdownButton<String>(
                    value: selectedItem == 'rien' ? listeMois[0].getLibelle : selectedItem,
                    onChanged: (String string){
                      setState(() {
                        selectedItem = string;
                      });
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return listeMois.map<Widget>((Mois unMois) {
                        return Text(unMois.getLibelle);
                      }).toList();
                    },
                    items: listeMois.map((Mois unMois) {
                      return DropdownMenuItem<String>(
                        child: Text(unMois.getLibelle),
                        value: unMois.getLibelle,
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                height: 30,
              ),
              tbCaMensuel,
              Container(
                height: 70,
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
  }
