abstract class AuthEvent {}

class AuthLoginRequset extends AuthEvent {
  String usrename;
  String password;
  AuthLoginRequset(this.usrename, this.password);
}

class AuthRegisterRequset extends AuthEvent {
  String usrename;
  String password;
  String passwordConfirm;
  AuthRegisterRequset(this.usrename, this.password, this.passwordConfirm);
}
