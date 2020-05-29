import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';

class BaseDeDonnees {
  //Les variables et les noms de fonction commençants par _, sont privées.

// Définition des variables :
  static final _dbName = 'gsbandroid.db';
  static final _dbVersion = 1;
  static Database _database;

  //Constructeur
  BaseDeDonnees._constructor();
  static final BaseDeDonnees instance = BaseDeDonnees._constructor();

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
    dateNaissance DATE NOT NULL,
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
}
