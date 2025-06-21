import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_colors.dart';
import '../../viewmodels/transaction_view_model.dart';

class TransactionListWidget extends StatelessWidget {
  const TransactionListWidget({super.key});
  String _getDateString(DateTime date) {
    final now = DateTime.now();
    final diffDays = now.difference(date).inDays;

    if (diffDays == 0) {
      return '오늘';
    } else if (diffDays == 1) {
      return '어제';
    } else {
      return DateFormat('yyyy년 MM월 dd일').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.error != null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(viewModel.error!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.loadTransactions(),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        if (viewModel.transactions.isEmpty) {
          return const Center(child: Text('거래 내역이 없습니다.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.transactions.length,
          itemBuilder: (context, index) {
            final transactions = viewModel.transactions;
            final transaction = transactions[index];
            final showDateHeader =
                index == 0 ||
                DateTime(
                      transactions[index - 1].timestamp.year,
                      transactions[index - 1].timestamp.month,
                      transactions[index - 1].timestamp.day,
                    ) !=
                    DateTime(
                      transaction.timestamp.year,
                      transaction.timestamp.month,
                      transaction.timestamp.day,
                    );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showDateHeader) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.md,
                      bottom: AppDimensions.sm,
                    ),
                    child: Text(
                      _getDateString(transaction.timestamp),
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: AppDimensions.iconSizeExtraLarge / 2,
                    backgroundColor: transaction.amount > 0
                        ? AppColors.incomeColor
                        : AppColors.expenseColor,
                    child: Icon(
                      transaction.amount > 0 ? Icons.add : Icons.remove,
                      color: Colors.white,
                      size: AppDimensions.iconSizeMedium,
                    ),
                  ),
                  title: Text(
                    transaction.memo,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat('HH:mm').format(transaction.timestamp),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text(
                    '₩ ${NumberFormat('#,###').format(transaction.amount.abs())}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: transaction.amount > 0
                          ? AppColors.incomeColor
                          : AppColors.expenseColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
