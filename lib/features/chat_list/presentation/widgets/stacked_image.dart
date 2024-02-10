import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/string_constants.dart';
import 'package:collection/collection.dart';

import '../../data/models/chat_list_response.dart';

Widget stackedImage(List<Avatar?>? imageUrlList, double size, String myID) {
  Avatar? avatar =
      imageUrlList?.firstWhereOrNull((element) => element?.id == myID);
  bool hasNoAvatar = avatar == null;
  String? url = avatar?.url;
  return Container(
    height: size + 8,
    width: size + 8,
    margin: const EdgeInsets.only(right: 10),
    child: Stack(
      children: imageUrlList != null && imageUrlList.isNotEmpty
          ? [
              if (imageUrlList.length == 2) ...{
                Center(
                    child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CachedNetworkImage(
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                          imageUrl:
                              hasNoAvatar ? AppStrings.imagePlaceHolder : url!,
                          placeholder: (context, url) => CircleAvatar(
                            radius: size / 2,
                            backgroundImage: const AssetImage(
                                "assets/images/image_error.jpeg"),
                          ),
                          imageBuilder: (context, provider) {
                            return Container(
                              height: size,
                              width: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: provider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        )))
              },
              if (imageUrlList.length > 2) ...{
                Align(
                    alignment: Alignment.topRight,
                    child: ProfileCard(
                      radius: 20,
                      imageUrl: imageUrlList.first?.url,
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: ProfileCard(
                      radius: 22,
                      imageUrl: imageUrlList.last?.url,
                    ))
              }
            ]
          : [],
    ),
  );
}

class ProfileCard extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  const ProfileCard({
    super.key,
    this.imageUrl,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CachedNetworkImage(
          height: 40,
          width: 40,
          fit: BoxFit.cover,
          imageUrl: imageUrl == null ? AppStrings.imagePlaceHolder : imageUrl!,
          placeholder: (context, url) => const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage("assets/images/image_error.jpeg"),
          ),
          imageBuilder: (context, provider) {
            return Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: provider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ));
  }
}
