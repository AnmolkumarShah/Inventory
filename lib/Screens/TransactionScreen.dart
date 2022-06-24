import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/CalenderHelper.dart';
import 'package:inventory_second/Helpers/DropdownHelper.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Models/Rollsize.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Transaction.dart';
import 'package:inventory_second/Models/Trantype.dart';
import 'package:inventory_second/Models/Type.dart';

// ignore: must_be_immutable
class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Rollsize>? rollsize_items;
  List<Shade>? shade_items;
  List<Size>? size_items;
  List<Type>? type_items;
  List<Trantype>? trantype_items;

  Rollsize? selected_rollsize;
  Shade? selected_shade;
  Size? selected_size;
  Type? selected_type;
  Trantype? selected_trantype;
  DateTime? date = DateTime.now();

  TextEditingController _rolls = TextEditingController(text: "");
  TextEditingController _mtrs = TextEditingController(text: "");

  TextEditingController _party = TextEditingController(text: "");
  TextEditingController _refNum = TextEditingController(text: "");

  static int count = 0;

  Future init() async {
    List<Rollsize> rollsizeItems = await fetch(Rollsize());
    List<Shade> shadeItems = await fetch(Shade());
    List<Size> sizeItems = await fetch(Size());
    List<Type> typeItems = await fetch(Type());
    List<Trantype> trantypeItems = await fetch(Trantype());

    rollsizeItems.insert(0, Rollsize(id: -1, desc: "Default"));
    shadeItems.insert(0, Shade(id: -1, desc: "Default"));
    sizeItems.insert(0, Size(id: -1, desc: "Default"));
    typeItems.insert(0, Type(id: -1, desc: "Default"));
    trantypeItems.insert(0, Trantype(id: -1, desc: "Default"));

    setState(() {
      this.rollsize_items = rollsizeItems;
      this.shade_items = shadeItems;
      this.size_items = sizeItems;
      this.type_items = typeItems;
      this.trantype_items = trantypeItems;

      this.selected_rollsize = rollsizeItems.first;
      this.selected_trantype = trantypeItems.first;
      this.selected_shade = shadeItems.first;
      this.selected_size = sizeItems.first;
      this.selected_type = typeItems.first;
    });

    return;
  }

  _fetchData() async {
    if (count > 0) return;
    await init();
    count += 1;
  }

  bool? loading;

  reset() {
    setState(() {
      selected_rollsize = rollsize_items![0];
      selected_shade = shade_items![0];
      selected_size = size_items![0];
      selected_trantype = trantype_items![0];
      selected_type = type_items![0];
      // date = null;
      _rolls = TextEditingController(text: "");
      _mtrs = TextEditingController(text: "");
      // _refNum = TextEditingController(text: "");
      // _party = TextEditingController(text: "");
    });
  }

  bool check() {
    if (date == null) {
      return false;
    } else if (this._rolls.value.text == "") {
      return false;
    } else if (this._mtrs.value.text == "") {
      return false;
    } else if (selected_rollsize!.id == -1 ||
        selected_shade!.id == -1 ||
        selected_size!.id == -1 ||
        selected_trantype!.id == -1 ||
        selected_type!.id == -1) {
      return false;
    }
    return true;
  }

  save() async {
    if (!check()) {
      showSnakeBar(context, "Fill All Fields Properly");
      return;
    }
    setState(() {
      loading = true;
    });

    Transaction tra = Transaction(
      date: this.date,
      mtrs: this._mtrs.value.text,
      party: this._party.value.text,
      refno: this._refNum.value.text,
      rolls: this._rolls.value.text,
      rollsize: this.selected_rollsize,
      shade: this.selected_shade,
      size: this.selected_size,
      trantype: this.selected_trantype,
      type: this.selected_type,
    );

    final result = await tra.save();

    if (result['message'] == 'success') {
      reset();
      showSnakeBar(context, "Transaction Saved Successfully");
    }

    setState(() {
      loading = false;
    });
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
        title: Text("Transactions"),
      ),
      body: FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              CalenderHelper(
                selectedDate: this.date,
                cancel: () {
                  setState(() {
                    this.date = null;
                  });
                },
                context: context,
                fun: (val) {
                  setState(() {
                    this.date = val;
                  });
                },
                label: "Date",
              ).build(),
              Fieldcover(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Referance Number",
                    border: InputBorder.none,
                  ),
                  controller: _refNum,
                ),
              ),
              Fieldcover(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Party Name",
                    border: InputBorder.none,
                  ),
                  controller: _party,
                ),
              ),
              Dropdown(
                label: "TranType",
                items: this.trantype_items,
                fun: (val) {
                  setState(() {
                    this.selected_trantype = val;
                  });
                },
                selected: this.selected_trantype,
              ).build(),
              Dropdown(
                label: Size.getFieldName(),
                items: this.size_items,
                fun: (val) {
                  setState(() {
                    this.selected_size = val;
                  });
                },
                selected: this.selected_size,
              ).build(),
              Dropdown(
                label: Shade.getFieldName(),
                items: this.shade_items,
                fun: (val) {
                  setState(() {
                    this.selected_shade = val;
                  });
                },
                selected: this.selected_shade,
              ).build(),
              Dropdown(
                label: Type.getFieldName(),
                items: this.type_items,
                fun: (val) {
                  setState(() {
                    this.selected_type = val;
                  });
                },
                selected: this.selected_type,
              ).build(),
              Dropdown(
                label: "Rollsize",
                items: this.rollsize_items,
                fun: (val) {
                  String value;
                  try {
                    value = (double.parse(this._rolls.value.text) *
                            double.parse(val!.desc!))
                        .toString();
                  } catch (e) {
                    value = '0';
                  }
                  setState(() {
                    this._mtrs = TextEditingController(text: value);
                    this.selected_rollsize = val;
                  });
                },
                selected: this.selected_rollsize,
              ).build(),
              Fieldcover(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Rolls",
                    border: InputBorder.none,
                  ),
                  controller: _rolls,
                  onChanged: (val) {
                    String value;
                    try {
                      value = (double.parse(this._rolls.value.text) *
                              double.parse(this.selected_rollsize!.desc!))
                          .toString();
                    } catch (e) {
                      value = '0';
                    }
                    setState(() {
                      this._mtrs = TextEditingController(text: value);
                    });
                  },
                ),
              ),
              Fieldcover(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Meters",
                    border: InputBorder.none,
                  ),
                  controller: _mtrs,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: loading == true
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          save();
                        },
                        child: Text("Save Transaction"),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
