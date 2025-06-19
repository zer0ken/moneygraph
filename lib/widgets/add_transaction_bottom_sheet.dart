import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'package:moneygraph/constants/app_dimensions.dart';
import 'package:moneygraph/viewmodels/transaction_view_model.dart';
import 'package:provider/provider.dart';
import 'package:moneygraph/widgets/transaction/transaction_amount_section.dart';
import 'package:moneygraph/widgets/transaction/transaction_datetime_section.dart';
import 'package:moneygraph/widgets/transaction/transaction_memo_section.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  bool _isIncome = false;
  final _amountController = TextEditingController();
  final _memoController = TextEditingController();
  String _rawAmount = '';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_updateAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _updateAmount() {
    final text = _amountController.text;
    if (text.isEmpty) {
      _rawAmount = '';
      return;
    }

    // 쉼표를 모두 제거하여 실제 숫자값 저장
    _rawAmount = text.replaceAll(RegExp(r'[^0-9]'), '');

    // 쉼표가 포함된 형식으로 변환
    final formattedText = NumberFormat('#,###').format(int.parse(_rawAmount));

    // 현재 커서 위치 저장
    final cursorPosition = _amountController.selection;

    // 이전 텍스트에서 제거된 쉼표 수
    final previousCommaCount =
        text.substring(0, cursorPosition.start).split(',').length - 1;

    // 새로운 텍스트에서 커서 이전의 쉼표 수
    final newCommaCount =
        formattedText
            .substring(0, math.min(cursorPosition.start, formattedText.length))
            .split(',')
            .length -
        1;

    // 커서 위치 조정
    final newCursorPosition =
        cursorPosition.start + (newCommaCount - previousCommaCount);

    setState(() {
      _amountController.value = TextEditingValue(
        text: formattedText,
        selection: TextSelection.collapsed(
          offset: math.max(
            0,
            math.min(newCursorPosition, formattedText.length),
          ),
        ),
      );
    });
  }

  Future<void> _saveTransaction() async {
    if (_rawAmount.isEmpty) return;
    
    final viewModel = context.read<TransactionViewModel>();
    final amount = double.parse(_rawAmount);
    
    try {
      await viewModel.addTransaction(
        timestamp: _selectedDate,
        amount: amount,
        memo: _memoController.text.trim(),
        isIncome: _isIncome,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_isIncome ? "수입" : "지출"}이 저장되었습니다.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('저장 중 오류가 발생했습니다. 다시 시도해주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.borderRadiusMedium),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: AppDimensions.elevationHigh,
            spreadRadius: AppDimensions.xs,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목과 닫기 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('거래 내역 추가', style: Theme.of(context).textTheme.headlineMedium),
                  IconButton(
                    icon: Icon(Icons.close, size: AppDimensions.iconSizeMedium),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),

              SizedBox(height: AppDimensions.lg),

              // 금액 입력 섹션
              TransactionAmountSection(
                isIncome: _isIncome,
                amountController: _amountController,
                onIncomeToggled: (value) => setState(() => _isIncome = value),
              ),

              SizedBox(height: AppDimensions.lg),

              // 시간 선택 섹션
              TransactionDateTimeSection(
                selectedDate: _selectedDate,
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),

              SizedBox(height: AppDimensions.lg),

              // 메모 섹션
              TransactionMemoSection(
                memoController: _memoController,
              ),

              SizedBox(height: AppDimensions.lg * 2),

              // 저장하기 버튼
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightLarge,
                child: FilledButton.tonal(
                  onPressed: _rawAmount.isEmpty
                      ? null
                      : _saveTransaction,
                  child: Text(
                    '저장하기',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
