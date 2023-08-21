import 'package:flutter/material.dart';

class MyBannar extends StatelessWidget {
  const MyBannar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person_2_outlined)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              child: const Icon(Icons.cancel),
            )
          ],
        )
      ],
    );
  }
}
