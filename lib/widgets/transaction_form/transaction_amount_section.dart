import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneygraph/constants/app_colors.dart';
import 'package:moneygraph/constants/app_dimensions.dart';

class TransactionAmountSection extends StatelessWidget {
  final bool isIncome;
  final TextEditingController amountController;
  final ValueChanged<bool> onIncomeToggled;

  const TransactionAmountSection({
    super.key,
    required this.isIncome,
    required this.amountController,
    required this.onIncomeToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isIncome ? '소득액 *' : '지출액 *',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppDimensions.sm),
        Row(
          children: [
            Material(
              color: isIncome ? AppColors.incomeColor : AppColors.expenseColor,
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium,
              ),
              child: InkWell(
                onTap: () => onIncomeToggled(!isIncome),
                borderRadius: BorderRadius.circular(
                  AppDimensions.borderRadiusMedium,
                ),
                child: SizedBox(
                  width: AppDimensions.buttonHeightMedium,
                  height: AppDimensions.buttonHeightMedium,
                  child: Icon(
                    isIncome ? Icons.add : Icons.remove,
                    color: Colors.white,
                    size: AppDimensions.iconSizeLarge,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppDimensions.sm),
            Expanded(
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyLarge,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: '12,345',
                  hintStyle: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
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
              ),
            ),
            SizedBox(width: AppDimensions.md),
            Text(
              '₩',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(width: AppDimensions.md),
          ],
        ),
      ],
    );
  }
}
