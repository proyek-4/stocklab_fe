import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageLoader extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const ImageLoader({
    Key? key,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.fit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => _buildSkeletonShimmer(),
      errorWidget: (context, url, error) => _buildSkeletonShimmer(),
    );
  }

  Widget _buildSkeletonShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: this.width,
        height: this.height,
        color: Colors.white,
      ),
    );
  }
}
