import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

/// Custom image widget that loads an image as a static asset or uses
/// [CachedNetworkImage] depending on the image url.
class CustomImage extends StatelessWidget {
  const CustomImage({super.key, required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    // * For this widget to work correctly on web, we need to handle CORS:
    // * https://flutter.dev/docs/development/platform-integration/web-images
    return AspectRatio(
      aspectRatio: 1,
      child: imageUrl.startsWith('http')
          ? CachedNetworkImage(imageUrl: imageUrl)
          : Image.asset(imageUrl),
    );
  }
}

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key, required this.imageUrls});
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
      options: CarouselOptions(
        height: 400.0,
        showIndicator: true,
        slideIndicator: const CircularSlideIndicator(
            indicatorBorderColor: Colors.grey,
            currentIndicatorColor: Colors.grey),
        pageSnapping: true,
      ),
      items: imageUrls.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return AspectRatio(
              aspectRatio: 1,
              child: i.startsWith('http')
                  ? CachedNetworkImage(imageUrl: i)
                  : Image.asset(i),
            );
          },
        );
      }).toList(),
    );
  }
}
