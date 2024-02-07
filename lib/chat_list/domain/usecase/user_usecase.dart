import '../../data/models/user_model.dart';
import '../repositories/user_repository.dart';

class UserUseCase {
  final UserRepository userRepository;

  UserUseCase({required this.userRepository});

  Future<UserModel> getAllUsers() async {
    return await userRepository.getUsers();
  }
}
