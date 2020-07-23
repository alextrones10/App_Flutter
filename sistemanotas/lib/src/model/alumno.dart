import 'package:firebase_database/firebase_database.dart';

class Alumno {
  String _id;
  String _name;
  String _codigo;
  String _nota1;
  String _nota2;
  String _examenfinal;
  String _alumnoImage;

  Alumno(this._id, this._name, this._codigo, this._nota1, this._nota2,
      this._examenfinal, this._alumnoImage);

  Alumno.map(dynamic obj) {
    this._name = obj['name'];
    this._codigo = obj['codigo'];
    this._nota1 = obj['nota1'];
    this._nota2 = obj['nota2'];
    this._examenfinal = obj['examenfinal'];
    this._alumnoImage = obj['AlumnoImage'];
  }

  String get id => _id;
  String get name => _name;
  String get codigo => _codigo;
  String get nota1 => _nota1;
  String get nota2 => _nota2;
  String get examenfinal => _examenfinal;
  String get alumnoImage => _alumnoImage;

  Alumno.fromSnapShot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _name = snapshot.value['name'];
    _codigo = snapshot.value['codigo'];
    _nota1 = snapshot.value['nota1'];
    _nota2 = snapshot.value['nota2'];
    _examenfinal = snapshot.value['examenfinal'];
    _alumnoImage = snapshot.value['AlumnoImage'];
  }
}
