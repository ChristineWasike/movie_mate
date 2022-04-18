import 'package:flutter/material.dart';
import 'authentication/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Authenticate();
  }
}
