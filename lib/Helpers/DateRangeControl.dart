// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'dateFormatfromDataBase.dart';

class DateRangeFull extends StatefulWidget {
  Function? fun;
  DateTimeRange? rangeDate;
  DateRangeFull({Key? key, this.fun, this.rangeDate}) : super(key: key);

  @override
  _DateRangeFullState createState() => _DateRangeFullState();
}

class _DateRangeFullState extends State<DateRangeFull> {
  TextStyle style = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  @override
  Widget build(BuildContext context) {
    return widget.rangeDate != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "From Date : ${dateFormat(widget.rangeDate!.start)}",
                    style: style,
                  ),
                  Text(
                    "To Date : ${dateFormat(widget.rangeDate!.end)}",
                    style: style,
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  widget.rangeDate = null;
                  widget.fun!(null);
                },
                icon: Icon(Icons.cancel),
              )
            ],
          )
        : ElevatedButton.icon(
            onPressed: () async {
              DateTimeRange? rangeDate = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(Duration(days: 1)),
              );
              widget.fun!(rangeDate);
              widget.rangeDate = rangeDate;
            },
            icon: Icon(Icons.date_range),
            label: Text("Date Range"),
          );
  }
}
