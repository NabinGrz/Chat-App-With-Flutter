import 'package:dio/dio.dart';
import 'package:flutter_chat_app/chat_list/data/models/chat_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/typedef/app_typedef.dart';

abstract class ChatListDataSource {
  Future<ChatListData> getAllChats();
}

class ChatListDataSourceImpl implements ChatListDataSource {
  final Dio dioClient;

  ChatListDataSourceImpl({required this.dioClient});
  @override
  Future<ChatListData> getAllChats() async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');
      print(token);
      final response = await dioClient.get(Endpoints.chatListUrl,
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));
      print("NABIN---------------------------------------------");
      print("NABIN${response.data}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        return ChatListData.success(ChatListResponse.fromJson(responseData));
      } else {
        return ChatListData.error(response.data['message']);
      }
    } on DioException catch (e) {
      return ChatListData.error(e.response?.data['message']);
    }
  }
}
