import 'package:flutter_chat_app/login/data/models/failed_login_model.dart';
import 'package:flutter_chat_app/login/data/models/successful_login_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@freezed
abstract class AppState with _$AppState {
  const factory AppState.initial() = Initial;
  const factory AppState.loading() = Loading;
  const factory AppState.failure(String failedAppStateResponse) = Failure;
  const factory AppState.success(String successfullAppStateResponse) = Success;
}
