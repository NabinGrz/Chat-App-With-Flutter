import 'package:dio/dio.dart';
import 'package:flutter_chat_app/register/domain/entities/register_data.dart';

import '../../../core/constants/api_endpoints.dart';

abstract class RegisterDataSource {
  Future<(String?, String?)> register(RegisterData data);
}

class RegisterDataSourceImpl extends RegisterDataSource {
  final Dio dioClient;

  RegisterDataSourceImpl({required this.dioClient});
  @override
  Future<(String?, String?)> register(RegisterData data) async {
    try {
      final response = await dioClient.post(
        Endpoints.registerUrl,
        data: data.toMap(),
      );
      final responseData = response.data;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return (responseData['message'] as String, null);
      } else {
        return (null, responseData['message'] as String);
      }
    } on DioException catch (e) {
      return (null, e.response!.data['message'] as String);
    }
  }
}
