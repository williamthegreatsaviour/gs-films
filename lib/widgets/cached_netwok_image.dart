import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

cachedImageNetwort(String imageURL) => CachedNetworkImage(
      imageUrl: imageURL,
      fit: BoxFit.cover,
      placeholder: (context, url) {
        return Center(
          child: Image.asset('assets/images/splash.png'),
        );
      },
      errorWidget: (context, url, error) {
        return Center(
          child: Image.network(
            "https://i.gifer.com/origin/34/34338d26023e5515f6cc8969aa027bca.gif",
          ),
        );
      },
    );
