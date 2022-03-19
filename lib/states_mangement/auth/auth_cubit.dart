import 'package:auth/auth.dart';
import 'package:cubit/cubit.dart';
import '../../chache/local_store_contract.dart';
import '../../models/user.dart';
import './auth_state.dart';
import 'package:async/async.dart';

class AuthCubit extends Cubit<AuthState> {
  final ILocalStore localStore;
  AuthCubit(this.localStore) : super(InitialState());

  signin(IAuthService authService) async {
    _startLoading();
    final result = await authService.signIn();
    print('result = '+result.toString());
    _setResultToAuthState(result);
  }

  signup(ISignUpService signUpService, User user) async {
    _startLoading();
    final result =
        await signUpService.signUp(user.name!,
            user.email!,
            user.password!);

    _setResultToAuthState(result);
  }

  signout(IAuthService authService) async {
    _startLoading();
    final token = await localStore.fetch();
    final result = await authService.signOut(token);
    if (result.asValue!.value) {
      localStore.delete(token);
      emit(SignOutSuccessState());
    } else {
      emit(ErrorState('Error signing out'));
    }
  }

  void _setResultToAuthState(Result<Token> result) {
    if (result.asError != null) {
      print('null');
      emit(ErrorState(result.asError!.error.toString()));
      return;
    }
    print('not null');
    emit(AuthSuccessState(result.asValue!.value));
  }

  void _startLoading() => emit(LoadingState());
}
