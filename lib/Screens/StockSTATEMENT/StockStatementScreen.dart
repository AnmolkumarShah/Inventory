import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/DropdownHelper.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Stock.dart';
import 'package:inventory_second/Models/Type.dart';
import 'package:inventory_second/Screens/StockSTATEMENT/StockStatementScreen2.dart';
import 'package:inventory_second/Screens/color_selector.dart';

class StockStatement extends StatefulWidget {
  const StockStatement({Key? key}) : super(key: key);

  @override
  State<StockStatement> createState() => _StockStatementState();
}

class _StockStatementState extends State<StockStatement> {
  static int count = 0;
  List<Shade>? shade_items;
  List<Size>? size_items;
  List<Type>? type_items;

  Shade? selected_shade;
  Size? selected_size;
  Type? selected_type;

  TextEditingController? _rvalue = TextEditingController(text: "0");
  TextEditingController? _bvalue = TextEditingController(text: "0");
  TextEditingController? _gvalue = TextEditingController(text: "0");

  Future init() async {
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Type> typeItems = await fetch(Type());

    shadeItems.insert(0, Shade(id: -1, desc: "Default"));
    sizeItems.insert(0, Size(id: -1, desc: "Default"));
    typeItems.insert(0, Type(id: -1, desc: "Default"));

    setState(() {
      this.shade_items = shadeItems;
      this.size_items = sizeItems;
      this.type_items = typeItems;

      this.selected_shade = shadeItems.first;
      this.selected_size = sizeItems.first;
      this.selected_type = typeItems.first;
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock Statement"),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Dropdown(
                  items: size_items,
                  label: "Select ${Size.getFieldName()}",
                  selected: selected_size,
                  fun: (val) {
                    setState(() {
                      selected_size = val;
                    });
                  }).build(),
              Dropdown(
                  items: shade_items,
                  label: "Select ${Shade.getFieldName()}",
                  selected: selected_shade,
                  fun: (val) {
                    setState(() {
                      selected_shade = val;
                    });
                  }).build(),
              Dropdown(
                  items: type_items,
                  label: "Select ${Type.getFieldName()}",
                  selected: selected_type,
                  fun: (val) {
                    setState(() {
                      selected_type = val;
                    });
                  }).build(),
              ElevatedButton(
                onPressed: () async {
                  List<int> selectedValue = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ColorSelector(),
                    ),
                  );
                  setState(() {
                    _rvalue = TextEditingController(
                        text: selectedValue[0].toString());
                    _bvalue = TextEditingController(
                        text: selectedValue[1].toString());
                    _gvalue = TextEditingController(
                        text: selectedValue[2].toString());
                  });
                },
                child: const Text("Select From Image"),
              ),
              Row(
                children: [
                  Expanded(
                    child: Fieldcover(
                      child: TextFormField(
                        controller: _rvalue,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          helperText: "R Value",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Fieldcover(
                      child: TextFormField(
                        controller: _gvalue,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          helperText: "G Value",
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Fieldcover(
                      child: TextFormField(
                        controller: _bvalue,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          helperText: "B Value",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  if (selected_shade!.id == -1 &&
                      selected_size!.id == -1 &&
                      selected_type!.id == -1) {
                    showSnakeBar(context, "Select Atleast One");
                    return;
                  }

                  if (_rvalue!.value.text == '') {
                    showSnakeBar(context, "Enter R Value First");
                    return;
                  }
                  if (_gvalue!.value.text == '') {
                    showSnakeBar(context, "Enter G Value First");
                    return;
                  }
                  if (_bvalue!.value.text == '') {
                    showSnakeBar(context, "Enter B Value First");
                    return;
                  }
                  Stock selectedStock = Stock(
                    s: selected_size,
                    shade: selected_shade,
                    t: selected_type,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StockStatementScreen2(
                        stock: selectedStock,
                        selectedRGB: [
                          int.parse(_rvalue!.value.text),
                          int.parse(_gvalue!.value.text),
                          int.parse(_bvalue!.value.text),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  "GO!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
