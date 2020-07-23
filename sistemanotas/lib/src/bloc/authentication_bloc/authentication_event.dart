import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Tres eventos:
// App Started - iniciar
// LoggedIn - Logeado
// LoggedOut - Desconectado

//eventos ententidos de AuthenticationEvent
class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
