import 'package:flutter_chat_app/register/domain/entities/register_data.dart';

abstract class RegisterRepository {
  Future<(String?, String?)> register(RegisterData data);
}
