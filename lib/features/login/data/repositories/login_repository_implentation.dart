import 'package:flutter_chat_app/features/login/data/datasources/login_data_source.dart';
import 'package:flutter_chat_app/features/login/data/models/successful_login_model.dart';
import 'package:flutter_chat_app/features/login/domain/repositories/login_repository.dart';

import '../../domain/entities/user.dart';
import '../models/failed_login_model.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginDataSource loginDataSource;

  LoginRepositoryImpl({required this.loginDataSource});
  @override
  Future<(SuccessfullLoginResponse?, FailedLoginResponse?)> login(
      UserCredentials user) {
    return loginDataSource.login(user);
  }
}
