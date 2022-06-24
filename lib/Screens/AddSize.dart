import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/SaveFormatter.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Models/Size.dart';

class AddSize extends StatefulWidget {
  const AddSize({Key? key}) : super(key: key);

  @override
  _AddSizeState createState() => _AddSizeState();
}

class _AddSizeState extends State<AddSize> {
  TextEditingController? _sizeLabel = TextEditingController(text: "");
  bool loading = false;

  Future save() async {
    if (_sizeLabel!.value.text == "") {
      showSnakeBar(context, "Enter ${Size.getFieldName()} Label");
      return;
    }
    setState(() {
      this.loading = true;
    });

    dynamic resut = await saveFormatter("""

    insert into size(size)
    values('${_sizeLabel!.value.text}')

    """);

    if (resut['status'] == "success") {
      showSnakeBar(context, "New ${Size.getFieldName()} Added Successfully");
    } else {
      showSnakeBar(context, "Error In Saving New ${Size.getFieldName()}");
    }

    setState(() {
      this.loading = false;
      _sizeLabel = TextEditingController(text: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add ${Size.getFieldName()}"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Chip(
            label: Text(
              "Swipe Down To Refresh",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: fetch(Size()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data as List<dynamic>;

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {});
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  title: Text(
                                    (data[index] as Size).desc!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  tileColor:
                                      Theme.of(context).colorScheme.primary,
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
            ),
          ),
          Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Fieldcover(
                      child: TextFormField(
                        controller: _sizeLabel,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "${Size.getFieldName()} Label",
                        ),
                      ),
                    ),
                    this.loading == false
                        ? TextButton(
                            onPressed: this.save,
                            child: Text("Add ${Size.getFieldName()}"),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
