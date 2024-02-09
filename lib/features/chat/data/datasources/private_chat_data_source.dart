import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../models/message_send_model.dart';
import '../models/private_chat_model.dart';

abstract class PrivateChatDataSource {
  Future<PrivateChatModel> getMessages(String userID);
  Future<MessageSendResponse> sendMessage(FormData data, String userID);
}

class PrivateChatDataSourceImpl extends PrivateChatDataSource {
  final Dio dioClient;

  PrivateChatDataSourceImpl({required this.dioClient});
  @override
  Future<PrivateChatModel> getMessages(String userID) async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');
      final response = await dioClient.get("${Endpoints.messagesUrl}/$userID",
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        return PrivateChatModel.fromJson(responseData);
      } else {
        return PrivateChatModel(error: response.data['message']);
      }
    } on DioException catch (e) {
      return PrivateChatModel(error: e.response?.data['message']);
    }
  }

  @override
  Future<MessageSendResponse> sendMessage(FormData data, String userID) async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');
      final response = await dioClient.post("${Endpoints.messagesUrl}/$userID",
          data: data,
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));

      return MessageSendResponse.fromJson(response.data);
    } on DioException catch (e) {
      return e.response?.data['message'];
    }
  }
}
