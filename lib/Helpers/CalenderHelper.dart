import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';

class CalenderHelper {
  Function? fun;
  Function? cancel;
  String? label;
  BuildContext? context;
  DateTime? selectedDate;
  CalenderHelper({
    this.fun,
    this.context,
    this.label,
    this.selectedDate,
    this.cancel,
  });

  selectdate(BuildContext context) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    return date;
  }

  build() {
    return Fieldcover(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            this.label!,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          selectedDate == null
              ? IconButton(
                  onPressed: () async {
                    DateTime date = await selectdate(this.context!);
                    this.fun!(date);
                  },
                  icon: Icon(Icons.calendar_today_outlined),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat.yMMMEd().format(
                        this.selectedDate!,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        this.cancel!();
                      },
                      icon: Icon(Icons.cancel_outlined),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
