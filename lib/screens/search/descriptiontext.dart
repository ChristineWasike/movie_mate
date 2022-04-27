import 'package:flutter/material.dart';

/// ADAPTED FROM: https://stackoverflow.com/questions/49572747/flutter-how-to-hide-or-show-more-text-within-certain-length
/// ORIGINAL AUTHOR: User Ajay Kumar (https://stackoverflow.com/users/2868455/ajay-kumar)
class DescriptionTextWidget extends StatefulWidget {
  final String text;
  final int maxlength;

  DescriptionTextWidget({Key? key, required this.text, required this.maxlength})
      : super(key: key);

  @override
  _DescriptionTextWidgetState createState() => _DescriptionTextWidgetState();
}

class _DescriptionTextWidgetState extends State<DescriptionTextWidget> {
  String firstHalf = '';
  String secondHalf = '';

  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > widget.maxlength) {
      firstHalf = widget.text.substring(0, widget.maxlength);
      secondHalf = widget.text.substring(widget.maxlength, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return secondHalf.isEmpty
        ? Text(firstHalf, style: TextStyle(color: Colors.white))
        : Column(
            children: <Widget>[
              Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                  style: TextStyle(color: Colors.white)),
              InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      flag ? "show more" : "show less",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    flag = !flag;
                  });
                },
              ),
            ],
          );
  }
}
