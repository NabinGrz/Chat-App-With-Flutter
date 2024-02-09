import 'package:flutter/material.dart';

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
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: imageUrlList.first == null
                        ? const NetworkImage(
                            "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png")
                        : NetworkImage(imageUrlList.first!),
                  ),
                ))
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
      child: CircleAvatar(
        radius: radius,
        backgroundImage: imageUrl == null
            ? const NetworkImage(
                "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png")
            : NetworkImage(imageUrl!),
      ),
    );
  }
}
