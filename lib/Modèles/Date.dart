
class Mois{

  //Attributs privés
  int _id ;
  String _libelle;




  //Constructeur
  Mois(int id,String libelle){
    this._id = id;
    this._libelle = libelle;
  }


  //Méthodes get
  int get getId => _id;
  String get getLibelle =>_libelle;


}