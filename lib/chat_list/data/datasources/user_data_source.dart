import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';

abstract class UserDataSource {
  Future<UserModel> getUsers();
}

class UserDataSourceImpl implements UserDataSource {
  final Dio dioClient;

  UserDataSourceImpl({required this.dioClient});
  @override
  Future<UserModel> getUsers() async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');
      final response = await dioClient.get(Endpoints.chatUsersUrl,
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        print("${UserModel.fromJson(responseData)}");
        return UserModel.fromJson(responseData);
      } else {
        return UserModel(error: response.data['message']);
      }
    } on DioException catch (e) {
      return UserModel(error: e.response?.data['message']);
    }
  }
}
