import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:sistemanotas/src/ui/alumno_screen.dart';
import 'package:sistemanotas/src/ui/alumno_information.dart';
import 'package:sistemanotas/src/model/alumno.dart';

class ListViewAlumno extends StatefulWidget {
  @override
  _ListViewAlumnoState createState() => _ListViewAlumnoState();
}

final alumnoReference = FirebaseDatabase.instance.reference().child('alumno');

class _ListViewAlumnoState extends State<ListViewAlumno> {
  List<Alumno> items;
  StreamSubscription<Event> _onAlumnoAddedSubscription;
  StreamSubscription<Event> _onAlumnoChangedSubscription;

  @override
  void initState() {
    super.initState();
    items = new List();
    _onAlumnoAddedSubscription =
        alumnoReference.onChildAdded.listen(_onAlumnoAdded);
    _onAlumnoChangedSubscription =
        alumnoReference.onChildChanged.listen(_onAlumnoUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _onAlumnoAddedSubscription.cancel();
    _onAlumnoChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Listado de Alumnos'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.only(top: 3.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                    ),
                    Container(
                      padding: new EdgeInsets.all(3.0),
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            //nuevo imagen
                            new Container(
                              padding: new EdgeInsets.all(5.0),
                              child: '${items[position].alumnoImage}' == ''
                                  ? Text('No image')
                                  : Image.network(
                                      '${items[position].alumnoImage}' +
                                          '?alt=media',
                                      fit: BoxFit.fill,
                                      height: 57.0,
                                      width: 57.0,
                                    ),
                            ),
                            Expanded(
                              child: ListTile(
                                  title: Text(
                                    '${items[position].name}',
                                    style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${items[position].nota1}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToAlumnoInformation(
                                      context, items[position])),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(context, position),
                            ),

                            //onPressed: () => _deleteAlumno(context, items[position],position)),
                            IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _navigateToAlumno(
                                    context, items[position])),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          onPressed: () => _createNewAlumno(context),
        ),
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.purple,
              ),
              onPressed: () => _deleteAlumno(
                context,
                items[position],
                position,
              ),
            ),
            new FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onAlumnoAdded(Event event) {
    setState(() {
      items.add(new Alumno.fromSnapShot(event.snapshot));
    });
  }

  void _onAlumnoUpdate(Event event) {
    var oldAlumnoValue =
        items.singleWhere((alumno) => alumno.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldAlumnoValue)] =
          new Alumno.fromSnapShot(event.snapshot);
    });
  }

  void _deleteAlumno(BuildContext context, Alumno alumno, int position) async {
    await alumnoReference.child(alumno.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
        Navigator.of(context).pop();
      });
    });
  }

  void _navigateToAlumnoInformation(BuildContext context, Alumno alumno) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlumnoScreen(alumno)),
    );
  }

  void _navigateToAlumno(BuildContext context, Alumno alumno) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlumnoInformation(alumno)),
    );
  }

  void _createNewAlumno(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AlumnoScreen(Alumno(null, '', '', '', '', '', ''))),
    );
  }
}
