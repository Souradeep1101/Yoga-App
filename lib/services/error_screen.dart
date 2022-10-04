import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: const Text(
            'Error! Sorry you are currently not authorized to the app. Try reinstalling it or contact the admin',
            style: TextStyle(color: Colors.redAccent, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
