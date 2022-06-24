import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Models/NormalUser.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  TextEditingController? _usrname = TextEditingController(text: "");
  TextEditingController? _pwd = TextEditingController(text: "");
  bool loading = false;

  Future save() async {
    if (_usrname!.value.text == '' || _pwd!.value.text == "") {
      showSnakeBar(context, "Enter Name And Password");
      return;
    }
    setState(() {
      this.loading = true;
    });

    User? user = User(
      usrname: _usrname!.value.text.trim(),
      pass: _pwd!.value.text.trim(),
    );

    var res = await user.login();
    if (res['msg'] == true) {
      showSnakeBar(context, "Already A User With This UserName & Password");
    } else {
      var result = await user.addUser();
      if (result['status'] == 'success') {
        showSnakeBar(context, "New User Addeed Successfully");
      }
    }

    setState(() {
      this.loading = false;
      _usrname = TextEditingController(text: "");
      _pwd = TextEditingController(text: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add User"),
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
                future: fetchUser(),
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
                              return (data[index] as User).display(context);
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
                        controller: _usrname,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "User Name",
                        ),
                      ),
                    ),
                    Fieldcover(
                      child: TextFormField(
                        controller: _pwd,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                        ),
                      ),
                    ),
                    this.loading == false
                        ? TextButton(
                            onPressed: this.save,
                            child: Text("Add User"),
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

// ignore: must_be_immutable
class NormalUserTile extends StatelessWidget {
  NormalUser? user;
  NormalUserTile({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(this.user!.usrname!),
    );
  }
}
