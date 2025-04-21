import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:demo_project/widgets/bonss_imagebox.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

List<Color> colors = [
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.orange,
  Colors.deepOrange,
];

Color getDeeperColor(Color color) {
  return Color.fromARGB(
    color.alpha,
    max(color.red - 22, 0),
    max(color.green - 22, 0),
    max(color.blue - 22, 0),
  );
}

Gradient getRandomGradient(String seed) {
  int random = Random(seed.hashCode).nextInt(colors.length);
  return LinearGradient(
    colors: [colors[random], getDeeperColor(colors[random])],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class Avatar extends StatelessWidget {
  final String url;
  final String? name;
  final Function? onTap;
  final double size; // Add size parameter

  const Avatar(
    this.url, {
    super.key,
    this.name,
    this.onTap,
    this.size = 50.0, // Default size if not provided
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Widget content;
        if (url == '') {
          content = Container(
            width: size, // Use size for width
            height: size, // Use size for height
            decoration: BoxDecoration(
              gradient: getRandomGradient(name ?? ''),
              borderRadius: BorderRadius.circular(size * 0.16),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(size * 0.12),
                child: AutoSizeText(
                  maxLines: 1,
                  minFontSize: 0,
                  maxFontSize: 666,
                  name == null
                      ? ''
                      : name!.length > 2
                      ? name!.substring(name!.length - 2, name!.length)
                      : name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1,
                    fontSize: size * 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        } else {
          content = Container(
            width: size, // Use size for width
            height: size, // Use size for height
            child:
                onTap != null
                    ? ExtendedImage.network(url)
                    : ImageBox(
                      url,
                      images: [
                        {'url': url + '_original', 'tag': url},
                      ],
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size * 0.16),
                      ),
                    ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(size * 0.16),
            ),
          );
        }
        return onTap == null
            ? content
            : GestureDetector(
              child: content,
              onTap: () {
                onTap!();
              },
            );
      },
    );
  }
}
