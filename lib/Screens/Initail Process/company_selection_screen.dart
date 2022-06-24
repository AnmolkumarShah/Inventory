import 'package:flutter/material.dart';
import 'package:inventory_second/Helpers/FieldCover.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Provider/compony_selector_singleton.dart';
import 'package:inventory_second/Screens/LoginScreen.dart';

class CompanySelectorScreen extends StatelessWidget {
  CompanySelectorScreen({Key? key}) : super(key: key);
  final TextEditingController _company = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    color: Colors.black,
                    height: 100,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Softflow Systems CRM",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Fieldcover(
                    child: TextFormField(
                      controller: _company,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        helperText: "Company Id",
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_company.value.text != "") {
                        CompanySelector first = CompanySelector();
                        first.pid = _company.value.text;
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else {
                        showSnakeBar(context, "Please Enter Your Company Id");
                      }
                    },
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
