import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int>? onSelect;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(count, (index) {
        final isActive = index <= currentIndex;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onSelect != null ? () => onSelect!(index) : null,
            child: Container(
              margin: EdgeInsets.only(
                right: index == count - 1 ? 0 : 8.0,
              ),
              height: 3.0,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
          ),
        );
      }),
    );
  }
}
