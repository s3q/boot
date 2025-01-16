import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:web/screens/homeScreen.dart';

class MainScreenWidget extends StatelessWidget {
  List<Widget> body;
   MainScreenWidget({super.key, required this.body});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Boots 🥾"),
        actions: [
          ElevatedButton(onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router, (p ) => true);
          }, child: Text("Home")),
          ElevatedButton(onPressed: () {}, child: Text("Services")),
          ElevatedButton(onPressed: () {}, child: Text("Statistics")),

          IconButton(onPressed: () {}, icon: Icon(Icons.login_rounded)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          IconButton(onPressed: () {}, icon: Icon(Icons.help_rounded))

        ],
      ),
      body: Container(
          margin: EdgeInsets.only(top: 10),
          height: double.infinity,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/img/b3.jpg"), fit: BoxFit.fill, opacity: 0.5)),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children:  body  ),
            ) )),
      );
  }
}