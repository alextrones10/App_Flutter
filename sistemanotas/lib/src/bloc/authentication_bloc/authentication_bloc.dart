import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:sistemanotas/src/bloc/authentication_bloc/bloc.dart';
import 'package:sistemanotas/src/repository/user_repository.dart';
import 'package:meta/meta.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState(); //funcion, que retorna el estado retornado autenticado
    }
    if (event is LoggedIn) {
      yield* _mapLoggedInToState(); //estado no auntenticado
    }
    if (event is LoggedOut) {
      yield* _mapLoggedOutToState(); //estado de salida
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        final user = await _userRepository.getUser();
        yield await Future.delayed(Duration(seconds: 5), () {
          return Authenticated(user);
        });
      } else {
        yield await Future.delayed(Duration(seconds: 5), () {
          return Unauthenticated();
        });
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}