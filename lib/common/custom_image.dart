import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  const CustomImage({Key key, this.url = "", this.fit = BoxFit.cover})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return url.length > 10
        ? Image.network(
            url,
            // cacheHeight: 300,
            // cacheWidth: 200,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset("assets/images/bdog.png");
            },
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.white.withAlpha(10),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                ),
              );
            },
          )
        : Image.asset("assets/images/bdog.png");
  }
}
