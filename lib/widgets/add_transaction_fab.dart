import 'package:flutter/material.dart';
import 'add_transaction_bottom_sheet.dart';

class AddTransactionFab extends StatefulWidget {
  const AddTransactionFab({super.key});

  @override
  State<AddTransactionFab> createState() => _AddTransactionFabState();
}

class _AddTransactionFabState extends State<AddTransactionFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    _controller.forward(); // FAB 숨기기 애니메이션 시작

    Scaffold.of(context)
        .showBottomSheet(
          (context) => const AddTransactionBottomSheet(),
          enableDrag: true,
          backgroundColor: Colors.transparent,
        )
        .closed
        .then((_) {
      // 바텀시트가 닫힐 때 FAB 보이기 애니메이션 시작
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _showBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('거래 내역 추가'),
      ),
    );
  }
}
