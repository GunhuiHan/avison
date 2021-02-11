import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedImage(String url, {double width = 60.0, double height = 60.0, double radius = 40.0}) {
  if (url == null) return Container(width: width, height: height, child: Image.asset("assets/house/houselogo.png"),);
  return CachedNetworkImage(
      placeholder: (context, url) => Container(width: width, height: height, child: Image.asset("assets/house/houselogo.png")),
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                )),
          ),
      errorWidget: (context, url, error) => Container(width: width, height: height, child: Image.asset("assets/house/houselogo.png"),));
}
