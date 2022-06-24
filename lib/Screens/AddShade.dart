import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/SaveFormatter.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Models/Shade.dart';

import 'color_selector.dart';

class AddShade extends StatefulWidget {
  final String? name;
  final String? rvalue;
  final String? gvalue;
  final String? bvalue;
  final int? id;
  final bool? isUpdating;

  const AddShade(
      {Key? key,
      this.name,
      this.bvalue,
      this.gvalue,
      this.rvalue,
      this.id,
      this.isUpdating = false})
      : super(key: key);

  @override
  State<AddShade> createState() => _AddShadeState();
}

class _AddShadeState extends State<AddShade> {
  bool? loading;

  TextEditingController? _shade;
  TextEditingController? _rvalue;
  TextEditingController? _bvalue;
  TextEditingController? _gvalue;

  initState() {
    _shade =
        TextEditingController(text: widget.name != null ? widget.name : "");
    _rvalue =
        TextEditingController(text: widget.rvalue != null ? widget.rvalue : "");
    _bvalue =
        TextEditingController(text: widget.bvalue != null ? widget.bvalue : "");
    _gvalue =
        TextEditingController(text: widget.gvalue != null ? widget.gvalue : "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Fieldcover(
          child: TextFormField(
            controller: _shade,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "${Shade.getFieldName()} Name",
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            List<int> selectedValue = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ColorSelector(),
              ),
            );
            setState(() {
              _rvalue =
                  TextEditingController(text: selectedValue[0].toString());
              _gvalue =
                  TextEditingController(text: selectedValue[1].toString());
              _bvalue =
                  TextEditingController(text: selectedValue[2].toString());
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
                    hintText: "R Value",
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
                    hintText: "B Value",
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
                    hintText: "G Value",
                  ),
                ),
              ),
            ),
          ],
        ),
        loading == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ElevatedButton(
                onPressed: () async {
                  if (_shade!.value.text == '') {
                    showSnakeBar(
                        context, "Enter ${Shade.getFieldName()} Value First");
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
                  setState(() {
                    loading = true;
                  });

                  String? query = '''
                insert into shade(shade,rvalue,bvalue,gvalue)
                values('${_shade!.value.text}',${_rvalue!.value.text},${_bvalue!.value.text},${_gvalue!.value.text})
              ''';

                  String? updateQuery = """
                update shade set shade = '${_shade!.value.text}',
                rvalue = ${_rvalue!.value.text},bvalue = ${_bvalue!.value.text},gvalue = ${_gvalue!.value.text}
                where id = ${widget.id}
                """;

                  var result = widget.isUpdating == true
                      ? await saveFormatter(updateQuery)
                      : await saveFormatter(query);
                  if (result['status'] == 'success') {
                    showSnakeBar(
                        context,
                        widget.isUpdating == true
                            ? "${Shade.getFieldName()} Updated Successfully"
                            : "${Shade.getFieldName()} Entered Successfully");
                  }
                  setState(() {
                    loading = false;
                    _shade = TextEditingController(text: "");
                  });
                  Navigator.pop(context);
                },
                child: Text(widget.isUpdating == true
                    ? "Update ${Shade.getFieldName()}"
                    : "Add ${Shade.getFieldName()}"),
              )
      ],
    );
  }
}

class AllShade extends StatefulWidget {
  const AllShade({Key? key}) : super(key: key);

  @override
  State<AllShade> createState() => _AllShadeState();
}

class _AllShadeState extends State<AllShade> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add ${Shade.getFieldName()}"),
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: FutureBuilder(
                  future: fetch(Shade()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    }
                    List<dynamic> data = snapshot.data as List<dynamic>;
                    return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: data.length,
                      itemBuilder: (context, index) => ListTile(
                        title: Text((data[index] as Shade).desc!),
                        subtitle: Text(
                            "R : ${(data[index] as Shade).rvalue!}, G : ${(data[index] as Shade).gvalue!}, B : ${(data[index] as Shade).bvalue!}"),
                        trailing: CircleAvatar(
                          backgroundColor: Color.fromRGBO(
                              (data[index] as Shade).rvalue!,
                              (data[index] as Shade).gvalue!,
                              (data[index] as Shade).bvalue!,
                              1),
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text("Update Shade"),
                                ),
                                body: Center(
                                  child: AddShade(
                                    isUpdating: true,
                                    name: (data[index] as Shade).desc!,
                                    rvalue: (data[index] as Shade)
                                        .rvalue!
                                        .toString(),
                                    gvalue: (data[index] as Shade)
                                        .gvalue!
                                        .toString(),
                                    bvalue: (data[index] as Shade)
                                        .bvalue!
                                        .toString(),
                                    id: (data[index] as Shade).id,
                                  ),
                                ),
                              ),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 250,
                child: AddShade(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
