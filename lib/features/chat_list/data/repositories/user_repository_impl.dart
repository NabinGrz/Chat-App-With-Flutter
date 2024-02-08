import 'package:flutter_chat_app/features/chat_list/data/datasources/user_data_source.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/user_model.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDataSource userDataSource;

  UserRepositoryImpl({required this.userDataSource});
  @override
  Future<UserModel> getUsers() async {
    return await userDataSource.getUsers();
  }
}
