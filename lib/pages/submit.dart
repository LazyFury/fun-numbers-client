import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funnumbers/api.dart';
import 'package:funnumbers/pages/home.dart';
import 'package:funnumbers/widgets/touchView.dart';
import 'package:google_fonts/google_fonts.dart';

class Submit extends StatefulWidget {
  final int num;
  final String type;
  Submit({this.num, this.type = ""}) : super();

  @override
  State<StatefulWidget> createState() => SubmitState();
}

class SubmitState extends State<Submit> {
  String comment = "";
  String type = "";
  int num = 0;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    num = widget.num;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Submit a func fact.",
              style: GoogleFonts.aBeeZee(fontSize: 24, color: Colors.black)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              TypeButtonGroup(type, (_type) {
                setState(() {
                  type = _type;
                });
              }),
              showNumber(num, (_num) {
                setState(() {
                  num = _num;
                });
              }),
              Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "place input...", border: InputBorder.none),
                  keyboardType: TextInputType.multiline,
                  minLines: 6,
                  maxLines: 12,
                  onChanged: (val) {
                    setState(() {
                      comment = val;
                    });
                  },
                ),
              ),
              TouchView(
                onTap: () {
                  API.instance
                      .post("/submit",
                          data: {"text": comment, "number": num, "type": type},
                          options: Options(headers: {
                            "Content-Type": "application/x-www-form-urlencoded"
                          }))
                      .then((value) => {Navigator.pop(context)});
                },
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black),
                  child: Text(
                    "Submit",
                    style:
                        GoogleFonts.aBeeZee(fontSize: 24, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
