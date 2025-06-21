import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneygraph/constants/app_dimensions.dart';

class TransactionDateTimeSection extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const TransactionDateTimeSection({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  State<TransactionDateTimeSection> createState() =>
      _TransactionDateTimeSectionState();
}

class _TransactionDateTimeSectionState
    extends State<TransactionDateTimeSection> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _updateTextFieldValue();
    _focusNode.addListener(_handleFocus);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TransactionDateTimeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _updateTextFieldValue();
    }
  }

  void _updateTextFieldValue() {
    _controller.text = DateFormat(
      'yyyy년 MM월 dd일 HH:mm',
    ).format(widget.selectedDate);
  }

  void _handleFocus() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
      _selectDate(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!context.mounted) return;

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      if (!context.mounted) return;

      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.selectedDate),
      );

      if (pickedTime != null) {
        widget.onDateChanged(
          DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('날짜 및 시간', style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: AppDimensions.sm),
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          readOnly: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.calendar_today,
              size: AppDimensions.iconSizeSmall,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.sm,
              vertical: AppDimensions.sm,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.borderRadiusMedium,
              ),
            ),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
