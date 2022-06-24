import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/create_excel.dart';
import 'package:inventory_second/Helpers/dateFormatfromDataBase.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/StockInOut.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Type.dart';

// ignore: must_be_immutable
class StockInOutScreen2 extends StatefulWidget {
  StockInOut? stockinout;
  StockInOutScreen2({Key? key, this.stockinout}) : super(key: key);

  @override
  State<StockInOutScreen2> createState() => _StockInOutScreen2State();
}

class _StockInOutScreen2State extends State<StockInOutScreen2> {
  static int count = 0;
  List<dynamic>? list;

  Future init() async {
    final result = await fetch(widget.stockinout!);
    setState(() {
      this.list = result;
    });
  }

  Future _fetch() async {
    if (count > 0) return;
    await init();
    count += 1;
  }

  @override
  void didChangeDependencies() {
    count = 0;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    TextStyle? minusvalue = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.red,
    );

    TextStyle? instyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );

    TextStyle? outstyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.orange,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock InOut Statements"),
        actions: [
          CreateExcelFile(
            data: list == null ? [] : list!,
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (this.list!.length == 0) {
            return Center(
              child: Chip(
                label: Text("No Data"),
              ),
            );
          }
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                InfoTop(this.list),
                Expanded(
                  child: ListView.builder(
                    itemCount: list!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " ${Size.getFieldName()} : ${list![index]['size']}",
                                  style: style,
                                ),
                                Spacer(),
                                Text(
                                  " Rollsize : ${list![index]['rollsize']}",
                                  style: list![index]['rollsize'] < 0
                                      ? minusvalue
                                      : style,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " ${Shade.getFieldName()} : ${list![index]['shade']}",
                                  style: style,
                                ),
                                Spacer(),
                                Text(
                                  " ${Type.getFieldName()} : ${list![index]['type']}",
                                  style: style,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " Tranref : ${list![index]['tranref']}",
                                  style: style,
                                ),
                                Spacer(),
                                Text(
                                  " Trantype : ${list![index]['Trantype']}",
                                  style: style,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " Rolls : ${list![index]['rolls']}",
                                  style: (list![index]['Trantype'] as String)
                                          .toLowerCase()
                                          .contains('in')
                                      ? instyle
                                      : outstyle,
                                ),
                                Spacer(),
                                Text(
                                  " Meters : ${list![index]['mtrs']}",
                                  style: (list![index]['Trantype'] as String)
                                          .toLowerCase()
                                          .contains('in')
                                      ? instyle
                                      : outstyle,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " Trandate : ${dateFormatFromDataBase(list![index]['trandate'])}",
                                  style: style,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class InfoTop extends StatelessWidget {
  List<dynamic>? list;
  double inRoll = 0, outRoll = 0, inMet = 0, outMet = 0;
  double inTo = 0, outTo = 0;
  InfoTop(this.list) {
    this.list = list;
    this.calculate();
  }

  calculate() {
    this.list!.forEach((element) {
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

  @override
  Widget build(BuildContext context) {
    TextStyle? style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Total Stock In  :  ${this.inTo}",
            style: style,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rolls : ${this.inRoll}",
                style: style,
              ),
              Text(
                "Meters : ${this.inMet}",
                style: style,
              ),
            ],
          ),
          Divider(
            color: Colors.black,
          ),
          Text(
            "Total Stock Out  :  ${this.outTo}",
            style: style,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rolls : ${this.outRoll}",
                style: style,
              ),
              Text(
                "Meters : ${this.outMet}",
                style: style,
              ),
            ],
          ),
        ],
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
