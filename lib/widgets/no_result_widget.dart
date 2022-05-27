import 'package:flutter/material.dart';

class NoResultWidget extends StatelessWidget {
  const NoResultWidget({
    Key? key,
    required this.onRetry,
    required this.noResultText,
    required this.retryButtonText,
  }) : super(key: key);

  final void Function() onRetry;
  final String noResultText;
  final String retryButtonText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(noResultText),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: onRetry,
              child: Text(retryButtonText),
            ),
          ),
        ],
      ),
    );
  }
}