import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/create_excel.dart';
import 'package:inventory_second/Helpers/dateFormatfromDataBase.dart';
import 'package:inventory_second/Models/Rollsize.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Type.dart';

// ignore: must_be_immutable
class StockStatementScreen3 extends StatefulWidget {
  Size? size;
  Shade? shade;
  Type? type;
  Rollsize? rollsize;
  StockStatementScreen3({
    Key? key,
    this.shade,
    this.size,
    this.type,
    this.rollsize,
  }) : super(key: key);

  @override
  State<StockStatementScreen3> createState() => _StockStatementScreen3State();
}

class _StockStatementScreen3State extends State<StockStatementScreen3> {
  static int count = 0;
  List<dynamic>? list;
  Future init() async {
    final result = await fetchQuery(query: '''
    select tranref,trandate,party,b.Trantype,c.rollsize,rolls,mtrs
    from transactions a
    left join
    trantype b on a.trantype = b.id
    left join  rollsize c on a.rollsize = c.id
    where a.size = ${widget.size!.id}  and a.shade = ${widget.shade!.id} and a.type = ${widget.type!.id} and a.rollsize = ${widget.rollsize!.id}
    ''');
    setState(() {
      this.list = result;
    });
  }

  Future _fetch() async {
    if (count > 0) {
      return;
    }
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
        title: Text("Transaction Report"),
        actions: [
          CreateExcelFile(
            data: list == null ? [] : list!,
            isStockInOut: false,
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
          return ListView.builder(
            itemCount: list!.length,
            itemBuilder: (context, index) {
              return Container(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          " Tranref : ${list![index]['tranref']}",
                          style: style,
                        ),
                        Spacer(),
                        Text(
                          " Rollsize : ${list![index]['rollsize']}",
                          style:
                              list![index]['rollsize'] < 0 ? minusvalue : style,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          " Party : ${list![index]['party']}",
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
                          style: list![index]['rolls'] < 0 ? minusvalue : style,
                        ),
                        Spacer(),
                        Text(
                          " Meters : ${list![index]['mtrs']}",
                          style:
                              (list![index]['mtrs']) < 0 ? minusvalue : style,
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
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
