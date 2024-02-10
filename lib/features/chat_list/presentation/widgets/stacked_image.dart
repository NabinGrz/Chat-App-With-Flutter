import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constants/string_constants.dart';

Widget stackedImage(List<String?>? imageUrlList) {
  return Container(
    height: 60,
    width: 60,
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
                          imageUrl: imageUrlList.first == null
                              ? AppStrings.imagePlaceHolder
                              : imageUrlList.first!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          imageBuilder: (context, provider) {
                            return Container(
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: provider),
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
                      imageUrl: imageUrlList.first,
                    )),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: ProfileCard(
                      radius: 22,
                      imageUrl: imageUrlList.last,
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
          imageUrl: imageUrl == null ? AppStrings.imagePlaceHolder : imageUrl!,
          placeholder: (context, url) => const CircularProgressIndicator(),
          imageBuilder: (context, provider) {
            return Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: provider),
              ),
            );
          },
        ));
  }
}
