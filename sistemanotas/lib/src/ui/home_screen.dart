import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistemanotas/src/bloc/authentication_bloc/bloc.dart';
import 'package:sistemanotas/src/ui/listview_alumno.dart';

class HomeScreen extends StatelessWidget {
  final String name;

  HomeScreen({Key key, @required this.name}) : super(key: key);

  int _currentIndex = 0;
  Widget callPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return ListViewAlumno();
      case 1:
        //return Pagetwo();
        break;
      default:
        return ListViewAlumno();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido $name!'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          )
        ],
      ),
      body: callPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) {
          _currentIndex = value;
          setState() {}
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box), title: Text('Alumnos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle), title: Text('Cursos')),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_comment), title: Text('Acerca De'))
        ],
      ),
    );
  }
}
