import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ppe/Bdd/bdd.dart';
import 'package:ppe/Mod%C3%A8les/Visiteur.dart';
import 'package:string_validator/string_validator.dart';
import '../Modèles/fonctions.dart';
import '../Modèles/caMensuel.dart';


class modifierCaMensuel extends StatefulWidget {

  final Visiteur monVisiteur;
  final int index;


  _modifierCaMensuel createState() => new _modifierCaMensuel();
  modifierCaMensuel({ Key key, this.monVisiteur, int this.index }) : super(key: key);
}

class _modifierCaMensuel extends State<modifierCaMensuel> {

  BaseDeDonnees bdd = BaseDeDonnees.OuvrirConnexion;
  final _frmCa = GlobalKey<FormState>();
  //Liste des mois à afficher
  static List<caMensuel> listeMois;

  //Fonction pour remplir la liste des mois à afficher
  Future _remplirListeMois() {
    listeMois= widget.monVisiteur.getListCa;
    //On parcourt la collection de tous les mois
  }





  String selectedItem = 'rien';
  String CaMois = 'rien';



  @override
  Widget build(BuildContext context) {

    _remplirListeMois();



    listeMois.forEach((ligne){
      print(ligne.getMois);
    });

    //Tb et bouton Valider
    var _tbCaMensuel = TextEditingController();
    _tbCaMensuel.text = (CaMois == "rien")?listeMois[0].getCaMensuel.toString():CaMois;


     _recupMois(String string){
      var numMois;
        widget.monVisiteur.getListCa.forEach((unCa){
          if(unCa.getMois == string ){
            numMois = unCa.getNumMois;
          }
        });
      return numMois;
    }


    String _recupCA(String string){
      var monCa;
      widget.monVisiteur.getListCa.forEach((unCa){
        if(unCa.getMois == string){
          monCa = unCa.getCaMensuel.toString();
        }
      });
      return monCa;
    }



    //Fonction de confirmation avant ajout
    Future<bool> _confirmer(int idVisiteur, int idMois, String mois, int Ca, int index){

      return showDialog(context: context, builder:
          (context) => AlertDialog(
        title: Text('Etes vous sur ?'),
        content: Text('Voulez-vous vraiment modifier ce chiffre d\'affaires pour le mois de : '+mois),
        actions: <Widget>[
          FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text('Oui'),
            onPressed: (){
              var res = bdd.uptCaMensuel(idVisiteur, idMois, mois, Ca, index);
              res.then((retour){
                if(retour =='OK')
                {
                  setState(() {
                    selectedItem='rien';
                    CaMois = 'rien';
                  });
                  fonctions.affciherToast('Modification effectuée', Colors.green);
                    Navigator.of(context).pop(false);
                  }else{
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

    final tbCaMensuel =TextFormField(
      controller: _tbCaMensuel,
      keyboardType: TextInputType.number,
      validator: (value){
        if(value.isEmpty || !isNumeric(value)){
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
            //On récupère uniquement le montant du chiffre d'affaires
            _confirmer(widget.monVisiteur.getId,monMois, selectedItem,int.parse(_tbCaMensuel.text), widget.index);
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blue,
        child: Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
    );

    var test = _recupCA(selectedItem);
    print (test);


    //Affichage de message et retour
    //Fonction de confirmation avant ajout



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
                    child:  Text('Modifier un chiffre d\'affaires pour : ', style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),),
                  ),



                  Container(
                    margin: EdgeInsets.only(top: 60),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<String>(
                        value: selectedItem == 'rien' ? listeMois[0].getMois : selectedItem,
                        onChanged: (String string){
                          setState(() {
                            print(CaMois);
                            selectedItem = string;
                            CaMois = _recupCA(string).toString();
                            print(CaMois);
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return listeMois.map<Widget>((caMensuel unMois) {
                            return Text(unMois.getMois);
                          }).toList();
                        },
                        items: listeMois.map((caMensuel unMois) {
                          return DropdownMenuItem<String>(
                            child: Text(unMois.getMois),
                            value: unMois.getMois,
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

