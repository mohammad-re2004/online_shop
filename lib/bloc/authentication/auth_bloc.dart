import 'package:apple_shop/bloc/authentication/auth_event.dart';
import 'package:apple_shop/bloc/authentication/auth_state.dart';
import 'package:apple_shop/data/repository/authentication_repository.dart';
import 'package:apple_shop/di/di.dart';
import 'package:bloc/bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _repository = locator.get();
  AuthBloc() : super(AuthinitState()) {
    on<AuthLoginRequset>(
      (event, emit) async {
        emit(AuthLoadingState());
        var response = await _repository.login(event.usrename, event.password);
        emit(AuthResponseState(response));
      },
    );
    on<AuthRegisterRequset>(
      (event, emit) async {
        emit(AuthLoadingState());
        var response = await _repository.register(
            event.usrename, event.password, event.passwordConfirm);
        emit(AuthResponseState(response));
      },
    );
  }
}
