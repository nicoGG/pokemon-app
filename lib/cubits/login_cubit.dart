import 'package:bloc/bloc.dart';
import '../providers/login_provider.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginProvider _loginProvider;

  LoginCubit(this._loginProvider) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    try {
      final token = await _loginProvider.login(username, password);
      emit(LoginSuccess(token));
    } catch (e) {
      emit(LoginError("Error en el login: ${e.toString()}"));
    }
  }
}
