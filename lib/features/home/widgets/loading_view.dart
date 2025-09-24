import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator.adaptive(
            backgroundColor: Theme.of(context).primaryColor,
          ),
          const SizedBox(height: 16),
          Text('Loading...', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
