import 'package:flutter_chat_app/register/domain/repositories/register_repository.dart';

import '../entities/register_data.dart';

class RegisterUseCase {
  final RegisterRepository registerRepository;

  RegisterUseCase({required this.registerRepository});

  Future<(String?, String?)> execute(RegisterData data) {
    return registerRepository.register(data);
  }
}
