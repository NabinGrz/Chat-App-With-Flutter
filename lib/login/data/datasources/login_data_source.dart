import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../domain/entities/user.dart';
import '../models/failed_login_model.dart';
import '../models/successful_login_model.dart';

abstract class LoginDataSource {
  Future<(SuccessfullLoginResponse?, FailedLoginResponse?)> login(
      UserCredentials user);
}

class LoginDataSourceImpl implements LoginDataSource {
  final Dio dioClient;

  LoginDataSourceImpl({required this.dioClient});
  @override
  Future<(SuccessfullLoginResponse?, FailedLoginResponse?)> login(
      UserCredentials user) async {
    try {
      final response = await dioClient.post(
        Endpoints.loginUrl,
        data: user.toMap(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        final sharedPreference = await SharedPreferences.getInstance();
        await sharedPreference.remove('accessToken');
        await sharedPreference.remove('id');
        await sharedPreference.setString(
            'accessToken', responseData['data']['accessToken']);
        await sharedPreference.setString(
            'id', responseData['data']['user']['_id']);
        print(responseData['data']['accessToken']);
        return (SuccessfullLoginResponse.fromJson(responseData), null);
      } else {
        return (null, FailedLoginResponse.fromJson(response.data));
      }
    } on DioException catch (e) {
      return (
        null,
        FailedLoginResponse(
          message: e.response!.data['message'],
        )
      );
    }
  }
}
