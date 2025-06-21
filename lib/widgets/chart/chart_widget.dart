import 'dart:math';

import 'package:flutter/material.dart';
import 'package:moneygraph/constants/app_dimensions.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  final List<bool> _selectedPeriod = [true, false]; // [월간, 주간]

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: max(200, MediaQuery.of(context).size.height * 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('한 눈에 보기', style: Theme.of(context).textTheme.titleLarge),

              const Spacer(),

              _buildPeriodToggle(),
            ],
          ),

          const SizedBox(height: AppDimensions.sm),

          // Placeholder for the chart
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Center(child: Text('차트가 여기에 표시됩니다.')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodToggle() {
    return ToggleButtons(
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedPeriod.length; i++) {
            _selectedPeriod[i] = i == index;
          }
        });
      },
      borderRadius: BorderRadius.circular(AppDimensions.sm),
      selectedBorderColor: Theme.of(context).colorScheme.primary,
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      fillColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.primary,
      constraints: const BoxConstraints(
        minHeight: AppDimensions.buttonHeightSmall,
      ),
      isSelected: _selectedPeriod,
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.sm),
          child: Text('월간'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.sm),
          child: Text('주간'),
        ),
      ],
    );
  }
}
