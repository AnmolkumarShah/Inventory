import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_second/Screens/Initail%20Process/company_selection_screen.dart';
import 'package:provider/provider.dart';
import 'package:inventory_second/Helpers/Snakebar.dart';
import 'package:inventory_second/Provider/MainProvider.dart';
import 'package:inventory_second/Screens/Dashboard.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    try {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MainProvider(),
          )
        ],
        child: MaterialApp(
          title: 'Edge Band Inventory',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          // home: LoginScreen(),
          home: CompanySelectorScreen(),
          routes: {
            "/dashboard": (context) => Dashboard(),
          },
        ),
      );
    } catch (e) {
      showSnakeBar(context, e.toString());
    }
    return Center(
      child: Chip(label: Text("Error Occured")),
    );
  }
}
