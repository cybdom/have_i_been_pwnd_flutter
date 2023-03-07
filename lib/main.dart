import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController passwordInput = TextEditingController();
  String finalResult =
      "Input your password then click search to find out if your password has been pwnd.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: passwordInput,
              obscureText: true,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () async {
                finalResult = await work();
                setState(() {});
              },
              child: const Text("Search"),
            ),
            const SizedBox(
              height: 25,
            ),
            Text(
              finalResult,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<String> work() async {
    String finalResult = "Your password hasn't been pwnd!";
    final encodedPassword = utf8.encode(passwordInput.text);
    String sha1Password =
        sha1.convert(encodedPassword).toString().toUpperCase();
    Uri uri = Uri.https(
        "api.pwnedpasswords.com", "/range/${sha1Password.substring(0, 5)}");

    final req = await http.get(uri);
    const LineSplitter splitter = LineSplitter();
    final List<String> results = splitter.convert(req.body);
    for (var line in results) {
      if (line.split(":").first.compareTo(sha1Password.substring(5)) == 0) {
        finalResult =
            "We have a match!\n Your password has been pwnd: ${line.split(':').last} times.";
      }
    }
    return finalResult;
  }
}
