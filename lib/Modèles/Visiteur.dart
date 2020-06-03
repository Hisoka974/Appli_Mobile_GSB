
import 'package:ppe/Mod%C3%A8les/caMensuel.dart';

class Visiteur{

  //Attributs privés
  int _id ;
  String _nom;
  String _prenom;
  String _tel;
  String _adr;
  String _dateNaiss;
  String _mail;
  int _objAnnuel;
  List<caMensuel> _listCaMensuel;


  //Constructeur
  // ignore: non_constant_identifier_names
  Visiteur(int id, String nom, String prenom, String tel, String adr, String dateNaiss, String mail, int objAnnuel,[List listeCaMensuels = const <caMensuel>[]] ){
    this._id = id;
    this._nom = nom;
    this._prenom = prenom;
    this._tel = tel;
    this._adr = adr;
    this._dateNaiss = dateNaiss;
    this._mail = mail;
    this._objAnnuel = objAnnuel;
    this._listCaMensuel = listeCaMensuels;
  }


  //Méthodes get
int get getId => _id;
String get getNom => _nom;
String get getPrenom => _prenom;
String get getTel => _tel;
String get getAdr => _adr;
String get getDatNaiss => _dateNaiss;
String get getMail => _mail;
int get getObjAnnuel => _objAnnuel;
List<caMensuel> get getListCa => _listCaMensuel;


//Retourne une liste de tous les mois ou un chiffre d'affaires est renseigné
 getMoisCA(){
  List<String> listeMois=[];
  this._listCaMensuel.forEach((monCa){

    listeMois.add(monCa.getMois);

  });

  return listeMois;
}

//Retourne le chiffre d'affaires annuel
  getCaAnnuel(){
   var CaMensuel = 0;

   this._listCaMensuel.forEach((monCa){

    CaMensuel+=monCa.getCaMensuel;

   });

   return CaMensuel;

  }


//Méthodes set

  void setNom(String nom){
    this._nom = nom;
  }

  void setPrenom(String prenom){
    this._prenom = prenom;
  }


  void setTel(String tel){
    this._tel = tel;
  }

  void setAdr(String adr){
    this._adr = adr;
  }

  void setDateNaiss(String date){
    this._dateNaiss = date;
  }

  void setMail(String mail){
    this._mail = mail;
  }

  void setObjAnnuel(int obj){
    this._objAnnuel = obj;
  }

  void setCaMensuel(caMensuel ca){
    this._listCaMensuel.add(ca);
  }


}