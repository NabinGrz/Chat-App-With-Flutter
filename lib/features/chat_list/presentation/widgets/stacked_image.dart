import 'package:flutter/material.dart';

Widget stackedImage(List<String?>? imageUrlList) {
  return Stack(
    children: imageUrlList != null && imageUrlList.isNotEmpty
        ? imageUrlList
            .asMap()
            .map((index, images) {
              final widget = Container(
                margin: EdgeInsets.only(left: 15.0 * index),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: images == null
                      ? const NetworkImage(
                          "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png")
                      : NetworkImage(images),
                ),
              );
              return MapEntry(index, widget);
            })
            .values
            .toList()
        : [],
  );
}
