import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:inventory_second/Helpers/FetchFormatter.dart';
import 'package:inventory_second/Helpers/dateFormatfromDataBase.dart';
import 'package:inventory_second/Models/Shade.dart';
import 'package:inventory_second/Models/Size.dart';
import 'package:inventory_second/Models/Type.dart';
import 'package:provider/provider.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Models/Admin.dart';
import 'package:inventory_second/Models/NormalUser.dart';
import 'package:inventory_second/Provider/MainProvider.dart';
import 'package:inventory_second/Screens/Dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final String reActivationNumber1 = "9373103689";
  final String reActivationNumber2 = "7276092220";
  String? usrname;
  String? pass;
  bool? loading = false;
  final _formKey = GlobalKey<FormState>();

  login() async {
    setState(() {
      this.loading = true;
    });
    _formKey.currentState!.save();
    User? _user;
    if (this.usrname == "" || this.pass == '') {
      showSnakeBar(context, "Enter All Fields");
      setState(() {
        this.loading = false;
      });
      return;
    }

    _user = User(pass: this.pass, usrname: this.usrname);
    Map<String, dynamic> result = await _user.login();
    if (result['msg'] == true) {
      _user.isadmin =
          result['data']['isadmin'] == null ? false : result['data']['isadmin'];
      _user.isblock =
          result['data']['isblock'] == null ? false : result['data']['isblock'];
      _user.id = result['data']['id'];
      if (_user.isadmin == true) {
        _user = Admin.castAdmin(_user);
      } else {
        _user = NormalUser.castNormal(_user);
      }
      Provider.of<MainProvider>(context, listen: false).setUser(_user);
      if (_user!.isblock == false) {
        Navigator.popAndPushNamed(context, Dashboard.routeName);
      } else if (_user.isblock == true) {
        showSnakeBar(context, "YOU ARE BLOCKED FROM USING APPLICATION");
        setState(() {
          this.loading = false;
        });
      } else {
        showSnakeBar(context, "Error Occured");
        setState(() {
          this.loading = false;
        });
      }
    } else if (result['msg'] == false) {
      showSnakeBar(context, "NO USER FOUND");
      setState(() {
        this.loading = false;
      });
    }
  }

  dynamic companyData;

  bool checkValidity(DateTime inputDate) {
    if (inputDate.difference(DateTime.now()).inDays <= 0) {
      return false;
    } else
      // widget.validyCheckCallback!(true); // product not expired
      return true;
  }

  int daysRemaining(DateTime inputDate) {
    int days = inputDate.difference(DateTime.now()).inDays;
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/back.jpg",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/logo.png",
                          height: 70,
                          color: Colors.black,
                        ),
                        Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.symmetric(
                            vertical: 30,
                            horizontal: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 60,
                                spreadRadius: 10,
                              )
                            ],
                          ),
                          child: FutureBuilder(
                            future: fetchQuery(query: "select * from co"),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: const Text(
                                      "Error Occured, It may be fault at the Server Side, PLease Check"),
                                );
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              late List<dynamic> data;

                              try {
                                data = snapshot.data as List<dynamic>;
                              } catch (e) {
                                if ((snapshot.data
                                        as Map<String, dynamic>)['status'] ==
                                    "faild") {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Text(
                                          (snapshot.data as Map<String,
                                              dynamic>)['statusdetails'],
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 10),
                                        // Text("Entered Id Refer to ${data[0]['Name']}",
                                        //     style: Control.onlybold),
                                      ],
                                    ),
                                  );
                                }
                              }

                              if (data.isEmpty || data[0]['expdate'] == null) {
                                return Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Error Occured While Getting Company Information\nCheck! Have you entered correct company Id ?",
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      // Text("Entered Id Refer to ${data[0]['Name']}",
                                      //     style: Control.onlybold),
                                    ],
                                  ),
                                );
                              }

                              companyData = data[0];

                              bool _isProductOpen = checkValidity(
                                  onlyDateFromDataBase(companyData['expdate']));

                              // for testing
                              // bool _isProductOpen = checkValidity(DateTime(1900));

                              if (_isProductOpen == false) {
                                return Column(
                                  children: [
                                    Chip(label: Text("Product Expired")),
                                    ListTile(
                                      title: Text(
                                        "Please Contact\n$reActivationNumber1 or $reActivationNumber2\nfor Product Reactivation",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        launch("tel://$reActivationNumber1");
                                      },
                                      icon: Icon(
                                        Icons.call,
                                      ),
                                      label: Text("Cal $reActivationNumber1"),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        launch("tel://$reActivationNumber2");
                                      },
                                      icon: Icon(
                                        Icons.call,
                                      ),
                                      label: Text("Call $reActivationNumber2"),
                                    )
                                  ],
                                );
                              } else if (_isProductOpen == true) {
                                // setting all the shade size and type name from database

                                String shadeLabel = "Shade";
                                String sizeLabel = "Size";
                                String typeLabel = "Type";

                                try {
                                  shadeLabel = companyData['shadename'];
                                  sizeLabel = companyData['sizename'];
                                  typeLabel = companyData['typename'];

                                } catch (e) {
                                  showSnakeBar(context,
                                      "Error In Setting Labels From Database");
                                }

                                Shade.setFieldName(shadeLabel);
                                Size.setFieldName(sizeLabel);
                                Type.setFieldName(typeLabel);

                                return Column(
                                  children: [
                                    // name
                                    Text(
                                      companyData['Name'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (companyData['expdate'] != null ||
                                                companyData['expdate'] != '' ||
                                                onlyDateFromDataBase(
                                                        companyData[
                                                            'expdate']) !=
                                                    DateTime(1900))
                                            // expiry info
                                            ? Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(
                                                      "Product will expire on \n${dateFormatFromDataBase(companyData['expdate'])}",
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "You Have ${daysRemaining(onlyDateFromDataBase(companyData['expdate']))} Days Remaining",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              ),
                                        Fieldcover(
                                          child: TextFormField(
                                            onSaved: (val) {
                                              setState(() {
                                                this.usrname = val;
                                              });
                                            },
                                            keyboardType: TextInputType.name,
                                            validator: RequiredValidator(
                                              errorText:
                                                  "This is required field!",
                                            ),
                                            decoration: InputDecoration(
                                              errorStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                              border: InputBorder.none,
                                              hintText: "Username",
                                            ),
                                          ),
                                        ),
                                        Fieldcover(
                                          child: TextFormField(
                                            onSaved: (val) {
                                              setState(() {
                                                this.pass = val;
                                              });
                                            },
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            obscureText: true,
                                            validator: RequiredValidator(
                                                errorText:
                                                    "This is required field!"),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Password",
                                            ),
                                          ),
                                        ),
                                        this.loading == true
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : TextButton(
                                                onPressed: login,
                                                child: Text(
                                                  "GO!",
                                                  style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                      ],
                                    )
                                  ],
                                );
                              } else {
                                return Chip(
                                    label: Text("Unable To Connect To Server"));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
