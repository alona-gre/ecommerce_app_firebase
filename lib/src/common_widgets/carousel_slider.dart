import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:riverpod_ecommerce_app_firebase/src/features/products_admin/presentation/image_picker.dart';

class CarouselSliderEdit extends StatefulWidget {
  const CarouselSliderEdit({
    super.key,
    required this.imageUrls,
    required this.onPreviewedImages,
  });
  final List<String> imageUrls;
  final Function(List<File> image) onPreviewedImages;

  @override
  State<CarouselSliderEdit> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSliderEdit> {
  List<File> addedImages = [];

  void _deleteImage(int index) {
    setState(() {
      if (index < widget.imageUrls.length) {
        // Delete from original images
        widget.imageUrls.removeAt(index);
      } else {
        // Delete from addedImages
        addedImages.removeAt(index - widget.imageUrls.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
        options: CarouselOptions(
          height: 270.0,
          showIndicator: true,
          slideIndicator: const CircularSlideIndicator(

              // indicatorBorderColor: Colors.grey,
              // currentIndicatorColor: Colors.grey,
              ),
          pageSnapping: true,
        ),
        items: [
          // Display images from widget.imageUrls
          ...widget.imageUrls.map((imageUrl) => Builder(
                builder: (context) => Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: imageUrl.startsWith('http')
                          ? CachedNetworkImage(imageUrl: imageUrl)
                          : Image.asset(imageUrl),
                    ),
                    Positioned(
                      top: 1.0,
                      right: 1.0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            _deleteImage(widget.imageUrls.indexOf(imageUrl)),
                      ),
                    ),
                  ],
                ),
              )),

          // Display images from addedImages
          ...addedImages.map((image) => Builder(
                builder: (context) => Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(image),
                    ),
                    Positioned(
                      top: 10.0,
                      right: 10.0,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => _deleteImage(widget.imageUrls.length +
                            addedImages.indexOf(image)),
                      ),
                    ),
                  ],
                ),
              )),

          // Display ProductImagePicker as the last item
          ProductImagePicker(
            onPickImage: (image) {
              setState(() {
                addedImages.add(image);
              });
              // Call the callback function with updated images
              widget.onPreviewedImages(addedImages);
            },
          ),
        ]);
  }
}

class CarouselSlider extends StatelessWidget {
  const CarouselSlider({
    super.key,
    required this.imageUrls,
  });
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return FlutterCarousel(
      options: CarouselOptions(
        showIndicator: true,
        viewportFraction: 1,
        slideIndicator: const CircularSlideIndicator(
            // indicatorRadius: 4,
            // indicatorBorderColor: Colors.grey,
            // currentIndicatorColor: Colors.grey,
            ),
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
