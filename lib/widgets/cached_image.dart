import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({super.key, this.imageUrl, this.radius = 0});
  final String? imageUrl;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      child: CachedNetworkImage(
        imageUrl: imageUrl ??
            "http://startflutter.ir/api/files/f5pm8kntkfuwbn1/kskhxikdjeuyuyr/rectangle_65_QkdeVfx8EA.png",
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: Colors.grey,
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.red[100],
        ),
      ),
    );
  }
}
