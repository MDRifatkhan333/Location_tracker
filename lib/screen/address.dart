import 'package:flutter/material.dart';
import 'package:map_goggle/screen/addressList.dart';
import 'package:map_goggle/screen/bannar.dart';

class MyAddress extends StatelessWidget {
  const MyAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Address'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[MyBannar(), Addresslist()],
        ),
      ),
    );
  }
}
