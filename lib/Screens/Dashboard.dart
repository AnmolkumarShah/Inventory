import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:inventory_second/Interface/User_interface.dart';
import 'package:inventory_second/Provider/MainProvider.dart';
import 'package:inventory_second/Widgets/OptionTile.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    User? currentUser =
        Provider.of<MainProvider>(context, listen: false).getUser();
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: currentUser!.available_option().length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final val = currentUser.available_option();
            return OptionTile(
              title: val[index]['name'],
              next: val[index]['value'],
            );
          },
        ),
      ),
    );
  }
}


// ListView(
//         children: [
          // OptionTile(
          //   title: "Transactions",
          //   next: TransactionScreen(),
          // ),
//           OptionTile(
//             title: "Stock Statement",
//             next: StockStatement(),
//           ),
//         ],
//       )