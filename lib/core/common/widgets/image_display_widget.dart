import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class ImageUrlWidget extends StatelessWidget {
  const ImageUrlWidget(
      {required this.borderRadius,
      required this.height,
      required this.imgUrl,
      required this.width,
      super.key});
  final double height;
  final double width;
  final String imgUrl;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: CachedNetworkImage(
          height: height,
          width: width,
          fit: BoxFit.cover, 
          placeholder: (context, url) => const Shimmer(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEBEBF4),
                    Color(0xFFF4F4F4),
                    Color(0xFFEBEBF4),
                  ],
                  stops: [
                    0.1,
                    0.3,
                    0.4,
                  ],
                  begin: Alignment(-1, -0.3),
                  end: Alignment(1, 0.3),
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              ),
          errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.home),
              ),
          imageUrl: imgUrl),
    );
  }
}

class ImageUrlCircleWidget extends StatelessWidget {
  const ImageUrlCircleWidget(
      {required this.height,
      required this.imgUrl,
      required this.width,
      super.key});
  final double height;
  final double width;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
          height: height,
          width: width,
          fit: BoxFit.fill,
          placeholder: (context, url) => const Shimmer(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFEBEBF4),
                    Color(0xFFF4F4F4),
                    Color(0xFFEBEBF4),
                  ],
                  stops: [
                    0.1,
                    0.3,
                    0.4,
                  ],
                  begin: Alignment(-1, -0.3),
                  end: Alignment(1, 0.3),
                ),
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 202, 201, 201)),
                ),
              ),
          errorWidget: (context, url, error) => const Center(
                child: Icon(Icons.home),
              ),
          imageUrl: imgUrl),
    );
  }
}
