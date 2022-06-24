import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/create_excel.dart';
import 'package:inventory_second/Helpers/deltaE_function.dart';
import 'package:inventory_second/Models/Rollsize.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Type.dart';
import 'package:inventory_second/Models/Stock.dart';

import 'StockStatementScreen3.dart';

// ignore: must_be_immutable
class StockStatementScreen2 extends StatefulWidget {
  final List<int>? selectedRGB;
  Stock? stock;
  StockStatementScreen2({Key? key, this.stock, this.selectedRGB})
      : super(key: key);

  @override
  State<StockStatementScreen2> createState() => _StockStatementScreen2State();
}

class _StockStatementScreen2State extends State<StockStatementScreen2> {
  static int count = 0;

  List<dynamic>? list;
  List<Shade>? shadeItems;
  List<Size>? sizeItems;
  List<Type>? typeItems;
  List<Rollsize>? rollItems;

  Future init() async {
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Type> typeItems = await fetch(Type());
    List<Rollsize> rollItems = await fetch(Rollsize());

    List<dynamic> result = await fetch(widget.stock!);

    result.forEach((e) {
      e['rgb'] = deltaE(widget.selectedRGB!, [
        e['rvalue'],
        e['gvalue'],
        e['bvalue'],
      ]);
    });

    // if (widget.selectedRGB![0] != 0 &&
    //     widget.selectedRGB![1] != 0 &&
    //     widget.selectedRGB![2] != 0)
    result.sort((a, b) => rbgSorting(a['rgb'], b['rgb']));

    setState(() {
      this.list = result;
      this.shadeItems = shadeItems;
      this.sizeItems = sizeItems;
      this.typeItems = typeItems;
      this.rollItems = rollItems;
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Statements"),
        actions: [
          CreateExcelFile(
            data: list == null ? [] : list!,
            isStockInOut: false,
            isDate: false,
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
            child: ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockStatementScreen3(
                          shade: shadeItems!.firstWhere(
                              (e) => e.desc == list![index]['shade']),
                          size: sizeItems!.firstWhere(
                              (e) => e.desc == list![index]['size']),
                          type: typeItems!.firstWhere(
                              (e) => e.desc == list![index]['type']),
                          rollsize: rollItems!.firstWhere((e) =>
                              e.desc == list![index]['roll_size'].toString()),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              " ${Size.getFieldName()} : ${list![index]['size']}",
                              style: style,
                            ),
                            Text(
                              " Rollsize : ${list![index]['roll_size']}",
                              style: style,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    " ${Shade.getFieldName()} : ${list![index]['shade']}",
                                    style: style,
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      color: Color.fromRGBO(
                                          list![index]['rvalue'],
                                          list![index]['gvalue'],
                                          list![index]['bvalue'],
                                          1),
                                      // color: Colors.amber,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                              " Rolls : ${list![index]['rolls']}",
                              style: list![index]['rolls'] < 0
                                  ? minusvalue
                                  : style,
                            ),
                            Spacer(),
                            Text(
                              " Meters : ${list![index]['mtrs']}",
                              style: (list![index]['mtrs']) < 0
                                  ? minusvalue
                                  : style,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              " deltaE : ${list![index]['rgb']}",
                              style: style,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("R : ${list![index]['rvalue']}", style: style),
                            Text("G : ${list![index]['gvalue']}", style: style),
                            Text("B : ${list![index]['bvalue']}", style: style),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
