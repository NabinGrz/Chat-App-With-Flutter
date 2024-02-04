import 'package:flutter/material.dart';

Widget stackedImage(List<String>? imageUrlList) {
  return Stack(
    children: imageUrlList != null && imageUrlList.isNotEmpty
        ? imageUrlList.map((e) => Image.network(e)).toList()
        : [],
  );
}
