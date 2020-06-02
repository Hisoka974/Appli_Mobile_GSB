import 'package:path_provider/path_provider.dart';
import 'package:ppe/Mod%C3%A8les/Visiteur.dart';
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
    MOIS TEXT NOR NULL
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
    
    //Supprimer dans la base de données et dans la collection
    try{
     await bdd.delete(
       'visiteurMedical',
       where: "id = ?",
       whereArgs: [id],
     );
     collection.collectionVisiteurs.removeAt(index);
    }catch(e){
      success = false;
      print(e);
    }
    
    return success;
  }


  //Ajouter un visiteur dans la collection et dans la bdd
  Future AjouterVisiteur(String nom, String prenom, String tel, String adr, String Bod, String mail, int Obj ) async{

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
        var monVisiteur = new Visiteur(lastId, nom, prenom, tel, adr, Bod, mail, Obj);
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


  //Récupérer tous les visiteurs dans la bdd
  Future getAllVisiteur() async{

    final bdd = await database;
    var res = await bdd.query('visiteurMedical');
    return res;
  }

  //Remplir les collections
  Future remplirCollection() async{
    final bdd = await database;
    var res = await getAllVisiteur();

    //On parcourt la liste des visiteur et on remplit la collection
    res.forEach((ligne){
      //On créer un visiteur
      var monVisiteur = new Visiteur(ligne["id"], ligne["nom"], ligne["prenom"], ligne["telephone"], ligne["adresse"], ligne["dateNaissance"], ligne["mail"], ligne["ObjAnnuel"]);
      collection.collectionVisiteurs.add(monVisiteur);
    });
  }

  //Fermer la connexion à la base de données
  Future fermerConnexion() async{
    final bdd = await database;
     return bdd.close();
  }

}
