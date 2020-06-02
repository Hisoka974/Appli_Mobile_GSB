import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Modèles/Visiteur.dart';

class infoVisiteur extends StatelessWidget {
  final Visiteur monVisiteur;

  // receive data from the FirstScreen as a parameter
  infoVisiteur({Key key, @required this.monVisiteur}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(monVisiteur.getNom+" "+monVisiteur.getPrenom),
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
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(monVisiteur.getNom[0]+monVisiteur.getPrenom[0],
                        style: TextStyle(
                          color: Colors.white,
                        ),),
                      )
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child:
                    Row(
                      children: <Widget>[
                        Icon(Icons.person),
                        Text("   Nom : "+monVisiteur.getNom,
                          style: TextStyle(
                            fontSize: 17,
                          ),),
                      ],
                    )
              ),

              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      Icon(Icons.person),
                      Text("   Prénom : "+monVisiteur.getPrenom,
                        style: TextStyle(
                          fontSize: 17,
                        ),),
                    ],
                  )
              ),

              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.houseUser),
                      Flexible(
                        child: Text("   Adresse : "+monVisiteur.getAdr,
                          style: TextStyle(
                            fontSize: 17,
                          ),),
                      )

                    ],
                  )
              ),

              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      Icon(Icons.phone_android),
                      Text("   Téléphone : "+monVisiteur.getTel,
                        style: TextStyle(
                          fontSize: 17,
                        ),),
                    ],
                  )
              ),

              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      Icon(Icons.mail),
                      Text("   E-mail : "+monVisiteur.getMail,
                        style: TextStyle(
                          fontSize: 17,
                        ),),
                    ],
                  )
              ),


              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.birthdayCake),
                      Text("   Date de naissance : "+monVisiteur.getDatNaiss,
                        style: TextStyle(
                          fontSize: 17,
                        ),),
                    ],
                  )
              ),

              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      Icon(Icons.assessment),
                      Text("   Objectif annuel: "+monVisiteur.getObjAnnuel.toString()+" €",
                        style: TextStyle(
                          fontSize: 17,
                        ),),
                    ],
                  )
              ),

            ],
          ),
        ),
      ),
    );
  }
}