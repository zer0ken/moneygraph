import 'package:flutter/material.dart';
import 'package:moneygraph/constants/app_dimensions.dart';
import 'package:moneygraph/widgets/add_transaction_fab.dart';
import 'package:moneygraph/widgets/chart_widget.dart';
import 'package:moneygraph/widgets/transaction_list_widget.dart';
import 'package:moneygraph/widgets/scroll_to_top_fab.dart';
import 'package:provider/provider.dart';
import 'package:moneygraph/viewmodels/transaction_view_model.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // 화면이 처음 로드될 때 트랜잭션 데이터를 로드합니다
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionViewModel>().loadTransactions();
    });
  }

  void _onScroll() {
    if (_scrollController.offset > 1000 && !_showScrollToTop) {
      setState(() => _showScrollToTop = true);
    } else if (_scrollController.offset <= 1000 && _showScrollToTop) {
      setState(() => _showScrollToTop = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimensions.md),
                    const ChartWidget(),
                    const SizedBox(height: AppDimensions.md),
                    Text(
                      '총 자산 ₩123,456',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppDimensions.md),
                    const TransactionListWidget(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            if (_showScrollToTop)
              ScrollToTopFAB(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
          ],
        ),
      ),
      floatingActionButton: const AddTransactionFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
