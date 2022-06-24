import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Provider/MainProvider.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatefulWidget {
  User? forUser;
  ResetPasswordScreen({Key? key, this.forUser}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool? loading;
  TextEditingController? _usrname = TextEditingController(text: "");
  TextEditingController? _oldpass = TextEditingController(text: "");
  TextEditingController? _newpass = TextEditingController(text: "");

  resetPass(User? u) async {
    if (_usrname!.value.text == '' ||
        _oldpass!.value.text == '' ||
        _newpass!.value.text == '') {
      showSnakeBar(context, "Enter All Fields First");
      return;
    }
    setState(() {
      loading = true;
    });

    var result = await u!.resetPassword(_newpass!.value.text);

    if (result == true) {
      showSnakeBar(context, "Password Changed Successfully");
      User? inDevice =
          Provider.of<MainProvider>(context, listen: false).getUser();
      if (u.id == inDevice!.getId()) {
        u.pass = _newpass!.value.text;
        Provider.of<MainProvider>(context, listen: false).setUser(u);
      }
    } else {
      showSnakeBar(context, "Error In Password Changing");
    }

    setState(() {
      loading = false;
      _usrname = TextEditingController(text: "");
      _oldpass = TextEditingController(text: "");
      _newpass = TextEditingController(text: "");
    });
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser;
    if (widget.forUser == null) {
      currentUser = Provider.of<MainProvider>(context, listen: false).getUser();
    } else {
      currentUser = widget.forUser;
    }
    if (currentUser != null) {
      _usrname = TextEditingController(text: currentUser.getName());
      _oldpass = TextEditingController(text: currentUser.getPass());
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Fieldcover(
            child: TextFormField(
              controller: _usrname,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "User Name",
              ),
            ),
          ),
          Fieldcover(
            child: TextFormField(
              controller: _oldpass,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Old Password",
              ),
            ),
          ),
          Fieldcover(
            child: TextFormField(
              controller: _newpass,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "New Password",
              ),
            ),
          ),
          loading == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () => resetPass(currentUser),
                  child: Text("Reset Password"),
                )
        ],
      ),
    );
  }
}
