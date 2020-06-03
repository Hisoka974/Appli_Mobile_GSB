

class caMensuel{

  //Attributs privés
  int _idVisiteur ;
  int _numMois;
  String _mois;
  int _caMensuel;




  //Constructeur
  caMensuel(int id,int numMois, String mois, int caMensuel){
    this._idVisiteur = id;
    this._numMois = numMois;
    this._mois = mois;
    this._caMensuel = caMensuel;

  }


  //Méthodes get
  int get getIdVisiteur => _idVisiteur;
  int get getNumMois =>_numMois;
  String get getMois =>_mois;
  int get getCaMensuel =>_caMensuel;

  void setCa(int ca){
    this._caMensuel = ca;
  }


}