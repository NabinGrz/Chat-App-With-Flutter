import 'package:flutter_chat_app/login/data/models/failed_login_model.dart';

import '../../data/models/successful_login_model.dart';
import '../entities/user.dart';

abstract class LoginRepository {
  Future<(SuccessfullLoginResponse?, FailedLoginResponse?)> login(
      UserCredentials user);
}
