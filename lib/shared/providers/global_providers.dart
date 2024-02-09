import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../usecase/chat_socket_usecase.dart';
import '../usecase/image_compress.dart';
import '../usecase/image_usecase.dart';
import '../usecase/socket_usecase.dart';

final dioClientProvider = Provider<Dio>((ref) => Dio());
final sharedPrefencesProvider = Provider((ref) => SharedPreferences);
final socketUseCaseProvider = Provider.autoDispose<SocketUseCase>((ref) {
  return SocketUseCase();
});
final chatSocketUseCaseProvider =
    Provider.autoDispose<ChatSocketUseCase>((ref) {
  return ChatSocketUseCase(socketUseCase: ref.read(socketUseCaseProvider));
});

final imageUseCaseCompressProvider =
    Provider<ImageCompressUseCase>((ref) => ImageCompressUseCase());
final imageUseCaseProvider = Provider<ImageUseCase>((ref) =>
    ImageUseCase(imageCompressUseCase: ref.read(imageUseCaseCompressProvider)));
