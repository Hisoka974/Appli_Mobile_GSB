
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppe/vues/modifierVisiteur.dart';
import '../Bdd/bdd.dart';

import 'package:ppe/Mod%C3%A8les/Visiteur.dart';
import 'Connexion.dart';
import '../Modèles/fonctions.dart';
import 'ajouterVisiteur.dart';
import '../Modèles/Collections.dart';
import '../vues/consulterInfo.dart';

class Menu extends StatefulWidget {
  @override
  _Menu createState() => _Menu();
}

class _Menu extends State {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SnackBar snackBar = const SnackBar(content: Text('Showing Snackbar'));
  //Instance de la bdd
  static BaseDeDonnees bdd = BaseDeDonnees.OuvrirConnexion;
  List<Visiteur> visiteurs = List();
  List<Visiteur> visiteursFiltre = List();



// Liste des actions que peut effectuer l'utilisateur sur un visiteur
  void _actions(Visiteur unVisiteur, int index) {
     showDialog(
        context: context ,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title:  Text(unVisiteur.getNom+" "+unVisiteur.getPrenom),
            children: <Widget>[
              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.info, color: Colors.blue),
                    Text(' Afficher les informations',
                      style: TextStyle(
                        color: Colors.blue,
                      ),)
                  ],
                ),
                onPressed: (){
                  Navigator.of(context).pop(false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new infoVisiteur(monVisiteur: unVisiteur)),
                  );

                },
              ),

              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.edit, color: Colors.blue),
                    Text(' Modifier les informations',
                      style: TextStyle(
                        color: Colors.blue,
                      ),)
                  ],
                ),
                onPressed: (){
                  Navigator.of(context).pop(false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new ModifierVisiteur(monVisiteur: unVisiteur, index: index),
                  )
                  );
                },
              ),

              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.attach_money, color: Colors.blue),
                    Text(' Ajouter un CA mensuel',
                      style: TextStyle(
                        color: Colors.blue,
                      ),)
                  ],
                ),
                onPressed: (){
                  print('info');
                },
              ),

              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.attach_money, color: Colors.blue),
                    Text(' Modifier un CA mensuel',
                      style: TextStyle(
                        color: Colors.blue,
                      ),)
                  ],
                ),
                onPressed: (){
                  print('info');
                },
              ),

              SimpleDialogOption(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete, color: Colors.red),
                    Text(' Supprimer le visiteur',
                      style: TextStyle(
                        color: Colors.red,
                      ),)
                  ],
                ),
                onPressed: (){
                  Navigator.of(context).pop(false);
                  _SuppressionVisiteur(unVisiteur, index);
                },
              ),
            ],
          );
        });
  }

  //Fonction demande confirmation déconnexion
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
            collection.collectionVisiteurs.clear();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => new Connexion()),
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


  //Fonction de confirmation de suppression
  Future<bool> _SuppressionVisiteur(Visiteur monVisiteur, int index) {

    return showDialog(context: context, builder:
        (context) => AlertDialog(
      title: Text('Etes vous sur ?'),
      content: Text('Vous allez supprimer le visiteur '+monVisiteur.getNom+" "+monVisiteur.getPrenom),
      actions: <Widget>[
        FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          child: Text('Oui'),
          onPressed: (){
            //Appel de la fonction de suppresion
            var res = bdd.suppVisiteur(monVisiteur.getId, index);

            //On test si la suppression s'est bien effectuée
            res.then((onValue){
              if(onValue==true)
              {
                fonctions.affciherToast('Suppression', Colors.green);
                setState(() {
                  visiteurs = collection.collectionVisiteurs;
                  visiteursFiltre = visiteurs;
                });
                Navigator.of(context).pop(false);
              } else{
                fonctions.affciherToast("Une erreur est survenue lors de la suppression", Colors.red);
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


  @override
  void initState(){
    super.initState();
    setState(() {
      visiteurs = collection.collectionVisiteurs;
      visiteursFiltre = visiteurs;
    });
  }


  @override
  Widget build(BuildContext context) {

    String dropdownValue = 'One';

    return WillPopScope(child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('GSB Mobile - Visiteurs'),
        actions: <Widget>[


        ],
      ),
      body:
      Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15.0),
                hintText: 'Rechercher une personne'
            ),
            onChanged: (chaine){
              setState(() {
                visiteursFiltre = visiteurs.where((unVisiteur) =>(
                    unVisiteur.getNom.toLowerCase().contains(chaine.toLowerCase()) ||
                        unVisiteur.getPrenom.toLowerCase().contains(chaine.toLowerCase()))).toList();
              });
            },
          ),

          Expanded(
            child: Container(
              child: FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  return ListView.builder(
                      itemCount: visiteursFiltre.length,
                      itemBuilder: (BuildContext context, int index){
                        return Card(
                          child: ListTile(
                            title: Text(visiteursFiltre[index].getNom+" "+visiteursFiltre[index].getPrenom),
                            subtitle: Text('Objectif annuel : '+visiteursFiltre[index].getObjAnnuel.toString()+" €"),
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(visiteursFiltre[index].getNom[0]),
                            ),
                            trailing: Wrap(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.more_vert, color: Colors.black,),
                                  iconSize: 24,
                                  onPressed:() => _actions(visiteursFiltre[index], index),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
          )

        ],

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => new AjouterVisiteur()),
          );
        },
      ),
    ), onWillPop: (){
      _Deconnexion();
    },
    );
  }
}