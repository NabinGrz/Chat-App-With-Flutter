import 'package:flutter_chat_app/features/register/data/datasources/register_data_source.dart';
import 'package:flutter_chat_app/features/register/domain/entities/register_data.dart';
import 'package:flutter_chat_app/features/register/domain/repositories/register_repository.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final RegisterDataSource registerDataSource;

  RegisterRepositoryImpl({required this.registerDataSource});
  @override
  Future<(String?, String?)> register(RegisterData data) {
    return registerDataSource.register(data);
  }
}
