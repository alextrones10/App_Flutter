import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sistemanotas/src/model/alumno.dart';
//nuevo para imagenes
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart';

File image;
String filename;

class AlumnoScreen extends StatefulWidget {
  final Alumno alumno;
  AlumnoScreen(this.alumno);
  @override
  _AlumnoScreenState createState() => _AlumnoScreenState();
}

final alumnoReference = FirebaseDatabase.instance.reference().child('alumno');

class _AlumnoScreenState extends State<AlumnoScreen> {
  List<Alumno> items;

  TextEditingController _nameController;
  TextEditingController _codigoController;
  TextEditingController _nota1Controller;
  TextEditingController _nota2Controller;
  TextEditingController _examenfinalController;

  //nuevo imagen
  String alumnoImage;

  pickerCam() async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  pickerGallery() async {
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    // File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }
  //fin nuevo imagen

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = new TextEditingController(text: widget.alumno.name);
    _codigoController = new TextEditingController(text: widget.alumno.codigo);
    _nota1Controller = new TextEditingController(text: widget.alumno.nota1);
    _nota2Controller = new TextEditingController(text: widget.alumno.nota2);
    _examenfinalController =
        new TextEditingController(text: widget.alumno.examenfinal);
    alumnoImage = widget.alumno.alumnoImage;
    print(alumnoImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Alumnos'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        //height: 570.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    new Container(
                      height: 100.0,
                      width: 100.0,
                      decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.blueAccent)),
                      padding: new EdgeInsets.all(5.0),
                      child: image == null ? Text('Add') : Image.file(image),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.2),
                      child: new Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: new BoxDecoration(
                            border: new Border.all(color: Colors.blueAccent)),
                        padding: new EdgeInsets.all(5.0),
                        child: alumnoImage == ''
                            ? Text('Edit')
                            : Image.network(alumnoImage + '?alt=media'),
                      ),
                    ),
                    Divider(),
                    //nuevo para llamar imagen de la galeria o capturarla con la camara
                    new IconButton(
                        icon: new Icon(Icons.camera_alt), onPressed: pickerCam),
                    Divider(),
                    new IconButton(
                        icon: new Icon(Icons.image), onPressed: pickerGallery),
                  ],
                ),
                TextField(
                  controller: _nameController,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'Name'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _codigoController,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.person), labelText: 'codigo'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _nota1Controller,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.assignment), labelText: 'Nota1'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                ),
                Divider(),
                TextField(
                  controller: _nota2Controller,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.assignment), labelText: 'Nota2'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                TextField(
                  controller: _examenfinalController,
                  style:
                      TextStyle(fontSize: 17.0, color: Colors.deepOrangeAccent),
                  decoration: InputDecoration(
                      icon: Icon(Icons.assignment), labelText: 'Examenfinal'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 1.0),
                ),
                Divider(),
                FlatButton(
                    onPressed: () {
                      //nuevo imagen
                      if (widget.alumno.id != null) {
                        var now = formatDate(
                            new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                        var fullImageName =
                            '${_nameController.text}-$now' + '.jpg';
                        var fullImageName2 =
                            '${_nameController.text}-$now' + '.jpg';

                        final StorageReference ref =
                            FirebaseStorage.instance.ref().child(fullImageName);
                        final StorageUploadTask task = ref.putFile(image);

                        var part1 =
                            'https://firebasestorage.googleapis.com/v0/b/flutterimagen.appspot.com/o/'; //esto cambia segun su firestore

                        var fullPathImage = part1 + fullImageName2;

                        alumnoReference.child(widget.alumno.id).set({
                          'name': _nameController.text,
                          'codigo': _codigoController.text,
                          'nota1': _nota1Controller.text,
                          'nota2': _nota2Controller.text,
                          'examenfinal': _examenfinalController.text,
                          'AlumnoImage': '$fullPathImage'
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        //nuevo imagen
                        var now = formatDate(
                            new DateTime.now(), [yyyy, '-', mm, '-', dd]);
                        var fullImageName =
                            '${_nameController.text}-$now' + '.jpg';
                        var fullImageName2 =
                            '${_nameController.text}-$now' + '.jpg';

                        final StorageReference ref =
                            FirebaseStorage.instance.ref().child(fullImageName);
                        final StorageUploadTask task = ref.putFile(image);

                        var part1 =
                            'https://firebasestorage.googleapis.com/v0/b/flutterimagen.appspot.com/o/'; //esto cambia segun su firestore

                        var fullPathImage = part1 + fullImageName2;

                        alumnoReference.push().set({
                          'name': _nameController.text,
                          'codigo': _codigoController.text,
                          'nota1': _nota1Controller.text,
                          'nota2': _nota2Controller.text,
                          'examenfinal': _examenfinalController.text,
                          'AlumnoImage': '$fullPathImage' //nuevo imagen
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: (widget.alumno.id != null)
                        ? Text('Update')
                        : Text('Add')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
