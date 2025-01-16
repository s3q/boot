import 'package:flutter/material.dart';
import 'package:web/screens/commandLineScreen.dart';
import 'package:web/screens/homeScreen.dart';
import 'package:web/screens/miningScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start Bot',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.

        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Colors.white70)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2, color: Color(0xFFF2AE40)),
                      ),
          //  border: OutlineInputBorder(borderSide: BorderSide(width: 2, color: Colors.orange)),
      filled: true,
      fillColor: Color.fromARGB(255, 0, 0, 0),
      contentPadding: EdgeInsets.all(10),
      labelStyle: TextStyle(color: Colors.white70),
      helperStyle: TextStyle(color: Colors.white70)
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          // primary: Colors.black,
          primary: Color(0xFFF2AE40),
          // primary: Color(0xFFF2AE40),
          onPrimary: Colors.black,
          secondary: Colors.black,
          // secondary: ColorsHelper.green,
          onSecondary: Colors.white70,
          error: Color(0xFFF28482),
          onError: Colors.white70,
          background: Colors.black,
          onBackground: Colors.white70,
          surface: Colors.black,
          onSurface: Colors.white70,
          
        ),
        backgroundColor: Theme.of(context).hintColor,

        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 34,
            //   fontWeight:
          ),
          displayMedium: TextStyle(
            fontSize: 28,
          ),
          displaySmall: TextStyle(
            fontSize: 20,
          ),
          headlineSmall: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white70,
          ),
          headlineLarge: TextStyle(
            //   fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: Colors.white70, // Colors.gray[800]
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.white, // Colors.gray[800]
          ),
          bodySmall: TextStyle(
            //   fontSize: 12,
            fontSize: 13,
            color: Colors.white, // Colors.gray[800]
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            color: Colors.white70, // Colors.gray[800]
          ),
          titleMedium: TextStyle(
            //   fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white70, // Colors.gray[800]
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            color: Colors.white70, // Colors.gray[800]
          ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.white,
                // foregroundColor: Colors.black, // !!!!!!!!!
                textStyle: TextStyle(
                  // fontFamily: AppHelper.returnText(context, "", "Vazirmatn"),
                  fontSize: 16,
                ))
            // style: ButtonStyle(
            //   elevation: MaterialStateProperty.all(0),
            //   textStyle: MaterialStateProperty.all(
            //     const TextStyle(
            //       fontSize: 18,
            //     ),

            ),
        // inputDecorationTheme: InputDecorationTheme(labelStyle: TextStyle(color: Colors.white70)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            //   padding: MaterialStateProperty.all(
            //       EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
            elevation: MaterialStateProperty.all(0),
            textStyle: MaterialStateProperty.all(TextStyle(
              // fontFamily: AppHelper.returnText(context, "", "Vazirmatn"),
              fontSize: 16,
            )),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            //   padding:
            //       EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            elevation: 0,
            foregroundColor: Colors.white70,
            textStyle: TextStyle(
              // fontFamily: AppHelper.returnText(context, "", "Vazirmatn"),
              color: Colors.white70,
              fontSize: 16,
              // fontWeight: FontWeight.bold,
            ),
            side: BorderSide(width: 2, color: Colors.black54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              // side: BorderSide(color: Colors.black54, width: 2),
            ),
          ),
        ),
      ),
      initialRoute: HomeScreen.router,
      routes: {
HomeScreen.router:(context) => HomeScreen(),
CommandLineScreen.router:(context) => CommandLineScreen(),
MiningScreen.router:(context) => MiningScreen(),

      },
            debugShowCheckedModeBanner: false,

    );
  }
}
