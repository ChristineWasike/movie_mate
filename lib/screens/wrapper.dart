import 'package:flutter/material.dart';
import 'package:movie_mate/screens/search/search.dart';
import 'authentication/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Search();
  }
}
