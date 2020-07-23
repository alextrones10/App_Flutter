import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sistemanotas/src/model/alumno.dart';

class AlumnoInformation extends StatefulWidget {
  final Alumno alumno;
  AlumnoInformation(this.alumno);
  @override
  _AlumnoInformationState createState() => _AlumnoInformationState();
}

final alumnoReference = FirebaseDatabase.instance.reference().child('alumno');

class _AlumnoInformationState extends State<AlumnoInformation> {
  List<Alumno> items;

  String alumnoImage; //nuevo

  @override
  void initState() {
    super.initState();
    alumnoImage = widget.alumno.alumnoImage; //nuevo
    print(alumnoImage); //nuevo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumno Information y Foto'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Container(
        height: 800.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text(
                  "Name : ${widget.alumno.name}",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                new Text(
                  "Codigo : ${widget.alumno.codigo}",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                new Text(
                  "Nota1 : ${widget.alumno.nota1}",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                new Text(
                  "Nota2 : ${widget.alumno.nota2}",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                new Text(
                  "Examenfinal : ${widget.alumno.examenfinal}",
                  style: TextStyle(fontSize: 18.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                Container(
                  height: 300.0,
                  width: 300.0,
                  child: Center(
                    child: alumnoImage == ''
                        ? Text('No Image')
                        : Image.network(alumnoImage +
                            '?alt=media'), //nuevo para traer la imagen de firestore
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
