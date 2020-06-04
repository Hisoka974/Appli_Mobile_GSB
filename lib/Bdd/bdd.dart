import 'package:path_provider/path_provider.dart';
import 'package:ppe/Mod%C3%A8les/Date.dart';
import 'package:ppe/Mod%C3%A8les/Visiteur.dart';
import 'package:ppe/Mod%C3%A8les/caMensuel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:ppe/Modèles/Collections.dart';


class BaseDeDonnees {
  //Les variables et les noms de fonction commençants par _, sont privées.

// Définition des variables :
  static final _dbName = 'gsbandroid.db';
  static final _dbVersion = 1;
  static Database _database;

  //Constructeur
  BaseDeDonnees._constructor();
  static final BaseDeDonnees OuvrirConnexion = BaseDeDonnees._constructor();

//Initialisation de la Base de données
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initBdd();
    return _database;
  }

//Initialisation de la Base de données
  _initBdd() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

//Fonction pour créer la base de données
  Future _onCreate(Database bdd, int version) {
    bdd.execute('''
    CREATE TABLE IF NOT EXISTS mois(
    NumMois INTERGER PRIMARY KEY,
    mois TEXT NOR NULL
    );
    ''');

    bdd.execute('''
    INSERT INTO mois VALUES
        (1, 'Janvier'),
        (2, 'Fevrier'),
        (3, 'Mars'),
        (4, 'Avril'),
        (5, 'Mai'),
        (6, 'Juin'),
        (7, 'Juillet'),
        (8, 'Aout'),
        (9, 'Septembre'),
        (10, 'Octobre'),
        (11, 'Novembre'),
        (12, 'Decembre');
      ''');

    bdd.execute('''
    CREATE TABLE IF NOT EXISTS visiteurMedical(
    id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    telephone TEXT NOT NULL,
    adresse TEXT NOT NULL,
    dateNaissance TEXT NOT NULL,
    mail TEXT NOT NULL,
    ObjAnnuel INTEGER NOT NULL
    );
      ''');

    bdd.execute('''
       CREATE TABLE IF NOT EXISTS realiserCA(
    idVisiteur INTEGER,
    numMois INTEGER,
    CAMensuel TEXT NOT NULL,
    PRIMARY KEY (idVisiteur, numMois),   
    FOREIGN KEY (idVisiteur) REFERENCES visiteurMedical (id) 
			ON DELETE CASCADE ON UPDATE CASCADE,
   FOREIGN KEY (numMois) REFERENCES mois (NumMois) 
			ON DELETE CASCADE ON UPDATE CASCADE
    );
      ''');

    bdd.execute('''
    CREATE TABLE IF NOT EXISTS admin(
    id INTEGER PRIMARY KEY,
    login TEXT NOT NULL,
    mdp TEXT NOT NULL
    )
      ''');

    bdd.execute('''
   INSERT INTO admin VALUES (1,'admin','admin');
    ''');
  }

  //On test si les identifiants de connexion sont corrects.
  //On renvoie vrai si c'est ok sinon faux

  Future<bool> testConnexion(String login, String mdp) async {
    final bdd = await database;
    var res =
        await bdd.query('admin', where: "login = ? and mdp = ? ", whereArgs: [
      login,
      mdp,
    ]);

    if (res.length > 0) {
      return true;
    }
    return false;
  }
  
  Future<bool> suppVisiteur(int id, int index) async{
    
    bool success = true;
    final bdd = await database;
    var ReelIndex;
    
    //Supprimer dans la base de données et dans la collection
    try{

      await bdd.delete(
        'realiserCA',
        where: "idVisiteur = ?",
        whereArgs: [id],
      );

     await bdd.delete(
       'visiteurMedical',
       where: "id = ?",
       whereArgs: [id],
     );

     for(var i = 0;i <= collection.collectionVisiteurs.length -1; i++){
       if(collection.collectionVisiteurs[i].getId == id){
         ReelIndex = i;
       }
     }

     collection.collectionVisiteurs.removeAt(ReelIndex);


   /*  collection.collectionVisiteurs.forEach((monVisiteur){
       if(monVisiteur.getId == id){
         collection.collectionVisiteurs.remove(monVisiteur);
       }
     });*/

  // collection.collectionVisiteurs.removeWhere((monVisiteur){
  //   monVisiteur.getId == id;
  // });
    }catch(e){
      success = false;
      print(e);
    }
    
    return success;
  }


  //Ajouter un visiteur dans la collection et dans la bdd
  Future AjouterVisiteur(String nom, String prenom, String tel, String adr, String Bod, String mail, int Obj ) async{
    List mesCa = <caMensuel>[];
    final bdd = await database;
    var success = 'OK';
    int lastId = 0;
    print('process = Début');
    //On insert le visiteur dans la base de données

    try{
      print('process = ajout bdd');
      lastId = await bdd.rawInsert("INSERT INTO visiteurMedical(nom, prenom, telephone, adresse, dateNaissance, mail, ObjAnnuel) VALUES(?,?,?,?,?,?,?)",
     [nom, prenom, tel, adr, Bod, mail, Obj]);
    }catch(e){
      print('process = ajout bdd echec');
      success ="Erreur : "+e;
      return success;
    }

    //On test que l'id renvoyé n'est pas égal à 0 et on créer un nouveau visiteur qu'on ajoute dans la collection
    if(lastId != 0){

      try{
        var monVisiteur = new Visiteur(lastId, nom, prenom, tel, adr, Bod, mail, Obj, mesCa);
        collection.collectionVisiteurs.add(monVisiteur);
        print('process = ajout collection');
      }catch(e){
        print('process = ajout collection echec');
        success ="Erreur : "+e;
        return success;
      }

    }else{
      success = 'id = 0';
      return success;
    }


    //Tous s'est bien passé
    print('process = ajout effectué');
    return success;

  }

  //Modifier visiteur
  Future ModifierVisiteur(int id, String nom, String prenom, String tel, String adr, String Bod, String mail, int Obj, int index)async{
    
    final bdd = await database;
    final monVisiteur = collection.collectionVisiteurs.elementAt(index);
    var success = 'OK';
    
    try{
      
      await bdd.rawUpdate('''
      
        UPDATE visiteurMedical 
        SET nom = ?, prenom = ?, telephone = ?, adresse = ?, dateNaissance = ?, mail = ?, ObjAnnuel =?   
        WHERE id = ?
        ''',
          [nom, prenom, tel, adr, Bod, mail, Obj, id]
      );


      monVisiteur.setNom(nom);
      monVisiteur.setPrenom(prenom);
      monVisiteur.setAdr(adr);
      monVisiteur.setTel(tel);
      monVisiteur.setDateNaiss(Bod);
      monVisiteur.setMail(mail);
      monVisiteur.setObjAnnuel(Obj);
      
    }catch(e){
      success = 'Erreur: '+e;
    }
    
    return success;
  }


  //Récupérer tous les visiteurs dans la bdd
  Future getAllVisiteur() async{

    final bdd = await database;
    var res = await bdd.query('visiteurMedical');
    return res;
  }


  Future getCa() async{

    final bdd = await database;
    var res = await bdd.query('realiserCA');
    return res;
  }

  //Remplir les collections
  Future remplirCollection() async{
    collection.collectionVisiteurs.clear();
    collection.collectionMois.clear();

    // Remplir la collection de visiteurs
    var res = await getAllVisiteur();
try{
  //On parcourt la liste des visiteur et on remplit la collection
  res.forEach((ligne) async {
    List mesCa = <caMensuel>[];
    var CaMensuel = await getCaByVisiteur(ligne['id']);

    //Si un chiffre d'affaire est retourné
    if (CaMensuel.length > 0) {
      CaMensuel.forEach((ca) {
        var monCaMensuel = new caMensuel(
            ca['idVisiteur'], ca['numMois'], ca['mois'], int.parse(ca['CAMensuel']));
        mesCa.add(monCaMensuel);
      });
    }


    //On créer un visiteur
    var monVisiteur = new Visiteur(
        ligne["id"],
        ligne["nom"],
        ligne["prenom"],
        ligne["telephone"],
        ligne["adresse"],
        ligne["dateNaissance"],
        ligne["mail"],
        ligne["ObjAnnuel"],
        mesCa
    );
    collection.collectionVisiteurs.add(monVisiteur);
    print("Collection visiteur"+collection.collectionVisiteurs.length.toString());
  });



  //Remplir la collection de mois
  var resMois = await getAllmois();
  resMois.forEach((ligne){
    var monMois = new Mois(ligne['NumMois'],ligne['mois']);
    collection.collectionMois.add(monMois);
  });
}catch(e){
  print (e);
}


  }

  //Récupérer tous les mois de la bdd
  Future getAllmois() async{
    final bdd = await database;
    var res = await bdd.query('mois');
    return res;
  }


  //On récupère le CA par visiteur
  Future getCaByVisiteur(int id) async{

    var bdd = await database;
    var res = bdd.rawQuery(
      "Select idVisiteur, realiserCA.numMois, mois, CAMensuel  From realiserCA "
          "INNER JOIN mois ON realiserCA.numMois = mois.NumMois "
          "WHERE idVisiteur = ?",
      [id]
    );

    return res;

  }


  Future ajouterCaMensuel(int idVisiteur, int idMois, String mois, int ca, int index) async{

    final bdd = await database;
    var monVisiteur = collection.collectionVisiteurs.elementAt(index);
    var success = 'OK';


    try{
      await bdd.rawInsert("INSERT INTO realiserCA(idVisiteur, numMois, CAMensuel) VALUES(?,?,?)",
          [idVisiteur, idMois, ca]);

      var monCa = new caMensuel(idVisiteur, idMois, mois, ca);
      monVisiteur.setCaMensuel(monCa);
    }catch(e){
      success = 'Erreur : '+e.toString();
      print('Erreur :'+e.toString());
    }

    return success;

  }

  Future uptCaMensuel(int idVisiteur, int idMois, String mois, int ca, int index) async{

    final bdd = await database;
    var monVisiteur = collection.collectionVisiteurs.elementAt(index);
    var success = 'OK';


    try{

      await bdd.rawUpdate('''
      
        UPDATE realiserCA 
        SET CAMensuel = ?   
        WHERE idVisiteur = ? AND numMois = ?
        ''',
          [ca, idVisiteur, idMois]
      );

      monVisiteur.getListCa.forEach((monCa){
        if(monCa.getIdVisiteur == idVisiteur && monCa.getNumMois == idMois){
          monCa.setCa(ca);
        }
      });


    }catch(e){
      success = 'Erreur : '+e.toString();
      print('Erreur :'+e.toString());
    }

    return success;

  }


  Future resetObjAnnuel() async{

    final bdd = await database;
    var success = 'OK';


    try{
      collection.collectionVisiteurs.forEach((monVisiteur) async {
        await bdd.rawUpdate('''
        UPDATE visiteurMedical 
        SET ObjAnnuel = 0   
        WHERE id = ?
        ''',
            [monVisiteur.getId]
        );

      });
      collection.collectionVisiteurs.forEach((monVisiteur)  {
        monVisiteur.setObjAnnuel(0);
      });

    }catch(e){
      success = 'Erreur : '+e.toString();
      print('Erreur :'+e.toString());
    }

    return success;

  }


  Future viderCaMensuel() async{

    final bdd = await database;
    var success = 'OK';

    try{
      collection.collectionVisiteurs.forEach((monVisiteur)  {

        if( monVisiteur.getListCa!=null && monVisiteur.getListCa.length >= 1 ){
          monVisiteur.clearCaMensuel();
        }

        bdd.execute('DELETE FROM realiserCA');

      });

    }catch(e){
      success = 'Erreur : '+e.toString();
      print('Erreur :'+e.toString());
    }

    return success;

  }





  //Fermer la connexion à la base de données
  Future fermerConnexion() async{
    final bdd = await database;
     return bdd.close();
  }

}
