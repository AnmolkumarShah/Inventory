import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Helpers/dateFormatfromDataBase.dart';
import 'package:inventory_second/Helpers/save_image_to_directory.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'package:universal_html/html.dart' show AnchorElement;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class CreateExcelFile extends StatefulWidget {
  CreateExcelFile({
    Key? key,
    required this.data,
    this.isStockInOut = true,
    this.isDate = true,
  }) : super(key: key);
  List<dynamic> data;
  bool isStockInOut;
  bool isDate; // weather it will have date or not
  @override
  State<CreateExcelFile> createState() => _CreateExcelFileState();
}

class _CreateExcelFileState extends State<CreateExcelFile> {
  final Workbook workbook = new Workbook();
  Worksheet? sheet;

  @override
  initState() {
    sheet = workbook.worksheets[0];
    super.initState();
  }

  double inRoll = 0, outRoll = 0, inMet = 0, outMet = 0;
  double inTo = 0, outTo = 0;
  calculate() {
    widget.data.forEach((element) {
      if (element['Trantype'] == "Stock IN") {
        this.inTo += 1;
        this.inMet += element['mtrs'];
        this.inRoll += element['rolls'];
      } else {
        this.outTo += 1;
        this.outMet += (element['mtrs']);
        this.outRoll += element['rolls'];
      }
    });
  }

  writeDate() async {
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    if (kIsWeb) {
      AnchorElement(
          href:
              'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'Output.xlsx')
        ..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName =
          Platform.isWindows ? '$path\\Output.xlsx' : '$path/Output.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      String lastName =
          widget.isStockInOut == true ? "In Out Statement" : "Stock Statement";
      String nameOfFile = "${dateFormat(DateTime.now())} ${lastName}";
      try {
        await saveFile(file, context, nameOfFile);
        showSnakeBar(context, "File Saved Successfully");
        Navigator.pop(context);
      } catch (e) {
        showSnakeBar(context, "Error in Saving File");
      }
      try {
        await OpenFile.open(fileName);
      } catch (e) {
        showSnakeBar(context, "No App Found To Open File");
      }
    }
  }

  insertRowData(List<dynamic> data, int firstIndex) {
    List<List<dynamic>> dataRows = [];
    if (widget.isDate == true) {
      data.forEach((e) {
        (e as Map<String, dynamic>)['trandate'] =
            dateFormatFromDataBase((e)['trandate']);
        dataRows.add((e).values.toList());
      });
    } else {
      data.forEach((e) {
        dataRows.add((e).values.toList());
      });
    }

    dataRows.forEach((e) {
      sheet!.importList(e, firstIndex + 1 + dataRows.indexOf(e), 1, false);
      sheet!
          .getRangeByIndex(firstIndex + 1 + dataRows.indexOf(e), 1, 1, e.length)
          .autoFitColumns();
    });

    if (widget.isStockInOut == true) {
      sheet!.importList(['Total Stock In', 'Rolls', 'Meters'],
          firstIndex + dataRows.length + 2, 1, false);
      sheet!.importList(
          [inTo, inRoll, inMet], firstIndex + dataRows.length + 3, 1, false);

      sheet!.importList(['Total Stock Out', 'Rolls', 'Meters'],
          firstIndex + dataRows.length + 5, 1, false);
      sheet!.importList(
          [outTo, outRoll, outMet], firstIndex + dataRows.length + 6, 1, false);
    }
  }

  @override
  void didChangeDependencies() {
    inRoll = 0;
    outRoll = 0;
    inMet = 0;
    outMet = 0;
    inTo = 0;
    outTo = 0;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStockInOut == true) calculate();
    return IconButton(
      onPressed: () async {
        // Navigator.pop(context);
        dynamic data = widget.data;
        List<String> heading =
            ((data[0] as Map<String, dynamic>).keys).toList();
        print(heading);

        final Style heading_style = workbook.styles.add('Style1');
        heading_style.bold = true;
        heading_style.underline = true;

        final int firstRow = 1;
        final int firstColumn = 1;
        final bool isVertical = false;
        sheet!.importList(heading, firstRow, firstColumn, isVertical);
        sheet!
            .getRangeByIndex(firstRow, firstColumn, 1, heading.length)
            .autoFitColumns();
        sheet!
            .getRangeByIndex(firstRow, firstColumn, 1, heading.length)
            .cellStyle = heading_style;
        insertRowData(data, firstRow);
        await writeDate();
      },
      icon: Icon(Icons.file_copy_rounded),
    );
  }
}
