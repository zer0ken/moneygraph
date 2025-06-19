import 'package:flutter/material.dart';
import 'package:moneygraph/views/overview_screen.dart';

class ResponsiveScreen extends StatelessWidget {
  // 태블릿이나 데스크톱에서 콘텐츠의 최대 너비
  static const double maxContentWidth = 600.0;

  const ResponsiveScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final padding = EdgeInsets.symmetric(
          // 화면이 작을 때는 좁은 패딩, 클 때는 넓은 패딩
          horizontal: constraints.maxWidth <= maxContentWidth
              ? 0.0
              : (constraints.maxWidth - maxContentWidth) / 2,
        );

        return Padding(padding: padding, child: const OverviewScreen());
      },
    );
  }
}
