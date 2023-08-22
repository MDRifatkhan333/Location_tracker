import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class screenBackground extends StatelessWidget {
  final Widget child;
  const screenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SvgPicture.asset(
            'assets/images/background.svg',
            fit: BoxFit.fill,
          ),
        ),
        child,
      ],
    );
  }
}
