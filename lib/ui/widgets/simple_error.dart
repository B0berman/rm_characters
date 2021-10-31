import 'package:flutter/material.dart';

class SimpleError extends StatelessWidget {
  final String message;
  final VoidCallback onRetryTap;

  const SimpleError({Key? key, this.message = "Something went wrong", required this.onRetryTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          const Icon(Icons.error),
          Text(
            message,
            style: const TextStyle(fontWeight: FontWeight.bold),
            textDirection: TextDirection.ltr,
          ),
          TextButton.icon(
              onPressed: onRetryTap,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"))
        ],
      ),
    );
  }
}