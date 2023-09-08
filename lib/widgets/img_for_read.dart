import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// 用于阅读页面的图片组件
class ImgForRead extends StatelessWidget {
  const ImgForRead({Key? key, required this.url}) : super(key: key);

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null) {
      return const SizedBox.shrink();
    }
    return Image.network(
      url!,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  strokeWidth: 3,
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.loading),
              ],
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.broken_image_outlined),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)!.imgLoadingFailed),
              ],
            ),
          ),
        );
      },
    );
  }
}
