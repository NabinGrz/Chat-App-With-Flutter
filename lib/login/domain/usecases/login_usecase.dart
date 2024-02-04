import 'package:flutter_chat_app/login/domain/repositories/login_repository.dart';

import '../../data/models/failed_login_model.dart';
import '../../data/models/successful_login_model.dart';
import '../entities/user.dart';

class LoginUseCase {
  final LoginRepository loginRepository;

  LoginUseCase({required this.loginRepository});

  Future<(SuccessfullLoginResponse?, FailedLoginResponse?)> execute(
      UserCredentials user) {
    return loginRepository.login(user);
  }
}
