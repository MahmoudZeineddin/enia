import 'package:flutter/material.dart';

class QAScreen extends StatefulWidget {
  const QAScreen({Key? key}) : super(key: key);

  @override
  State<QAScreen> createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(" الأسئلة")),
      body: Center(child: Text(" محتوى  الأسئلة ")),
    );
  }
}
