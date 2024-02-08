import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/features/chat_list/data/models/chat_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/typedef/app_typedef.dart';
import '../../domain/entities/group_data_model.dart';

abstract class ChatDataSource {
  Future<ChatListData> getAllChats();
  Future<int> createChat(String id);
  Future<int> createGroupChats(GroupDataModel data);
}

class ChatDataSourceImpl implements ChatDataSource {
  final Dio dioClient;

  ChatDataSourceImpl({required this.dioClient});
  @override
  Future<ChatListData> getAllChats() async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');
      final response = await dioClient.get(Endpoints.chatsUrl,
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));
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

  @override
  Future<int> createChat(String id) async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');

      final response = await dioClient.post("${Endpoints.chatsUrl}/c/$id",
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));
      return response.statusCode ?? 0;
    } on DioException catch (e) {
      debugPrint("${e.response?.data}");
      return e.response?.statusCode ?? 0;
    }
  }

  @override
  Future<int> createGroupChats(GroupDataModel data) async {
    try {
      final sharedPreference = await SharedPreferences.getInstance();
      String? token = sharedPreference.getString('accessToken');
      final response = await dioClient.post(Endpoints.createGroupUrl,
          data: data.toJson(),
          options: Options(headers: {
            ...{'Authorization': 'Bearer $token'}
          }));
      return response.statusCode ?? 0;
    } on DioException catch (e) {
      debugPrint("${e.response?.data}");
      return e.response?.statusCode ?? 0;
    }
  }
}
