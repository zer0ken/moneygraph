import 'package:flutter/material.dart';
import 'package:moneygraph/constants/app_dimensions.dart';

class TransactionMemoSection extends StatelessWidget {
  final TextEditingController memoController;

  const TransactionMemoSection({
    super.key,
    required this.memoController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('메모', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: AppDimensions.sm),
        TextField(
          controller: memoController,
          decoration: InputDecoration(
            hintText: '메모를 입력하세요',
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.md,
              vertical: AppDimensions.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium,
              ),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          maxLines: 1,
        ),
      ],
    );
  }
}
