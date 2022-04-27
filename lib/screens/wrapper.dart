import 'package:flutter/material.dart';
import 'package:movie_mate/screens/home/home.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import 'authentication/authenticate.dart';


class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user == null){
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}
