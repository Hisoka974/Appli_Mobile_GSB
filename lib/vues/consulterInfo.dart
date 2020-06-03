import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ppe/Mod%C3%A8les/caMensuel.dart';
import '../Modèles/Visiteur.dart';





class infoVisiteur extends StatefulWidget {

  final Visiteur monVisiteur;


  _infoVisiteur createState() => new _infoVisiteur();
  infoVisiteur({Key key, @required this.monVisiteur}) : super(key: key);

}








class _infoVisiteur extends State<infoVisiteur> {


  static List<caMensuel> listeMois;

  //Fonction pour remplir la liste des mois à afficher
  Future _remplirListeMois() {
    listeMois= widget.monVisiteur.getListCa;
    //On parcourt la collection de tous les mois
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

  String selectedItem = 'rien';
  String CaMois = 'rien';



  // receive data from the FirstScreen as a parameter


  @override
  Widget build(BuildContext context) {
    _remplirListeMois();
    return Scaffold(
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
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child:
                  Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(widget.monVisiteur.getNom[0]+widget.monVisiteur.getPrenom[0],
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
                        Text("   Nom : "+widget.monVisiteur.getNom,
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
                      Text("   Prénom : "+widget.monVisiteur.getPrenom,
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
                        child: Text("   Adresse : "+widget.monVisiteur.getAdr,
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
                      Text("   Téléphone : "+widget.monVisiteur.getTel,
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
                      Text("   E-mail : "+widget.monVisiteur.getMail,
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
                      Text("   Date de naissance : "+widget.monVisiteur.getDatNaiss,
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
                      Text("   Objectif annuel: "+widget.monVisiteur.getObjAnnuel.toString()+" €",
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
                      Icon(Icons.euro_symbol),
                      Text("   Chiffre d'affaires annuel: "+widget.monVisiteur.getCaAnnuel().toString()+" €",
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
                      Icon(Icons.euro_symbol),
                      Text("   Chiffre d'affaires mensuel: ",
                        style: TextStyle(
                          fontSize: 17,
                        ),),
                    ],
                  )
              ),


              Container(
                  child:
                  Row(
                    children: <Widget>[
                          Container(
                            child:  Text(
                              (CaMois == "rien")?listeMois[0].getCaMensuel.toString():CaMois+" € en : ",
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                            margin: EdgeInsets.only(left: 80),
                          ),


                          Spacer(),

                          Container(
                            margin: EdgeInsets.only(top: 15),
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
                        ],
                      ),

                  )
                ]
              ),

          )
        ),
    );
  }
}