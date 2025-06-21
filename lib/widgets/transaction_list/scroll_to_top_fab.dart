import 'package:flutter/material.dart';

class ScrollToTopFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const ScrollToTopFAB({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0), // 메인 FAB 위에 위치하도록 간격 조정
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          heroTag: 'scrollToTopFAB',
          mini: true,
          onPressed: onPressed,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}
