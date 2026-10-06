import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: AppTypography.heading1),
            const SizedBox(height: AppSpacing.sm),
            Text('Ready for slicing', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
