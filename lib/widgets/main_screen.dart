import 'package:flutter/material.dart';
import 'package:s3t/core/constants/constants.dart';
import 'package:s3t/core/routes/routes.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.splash,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Welcome!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "S3T!!! X/O\n""(Alpha 1.5)",
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.bold,
              color: AppColor.white
            ),
            textAlign: TextAlign.center,
          ),
          Column(
            children: [
              tName(context),
              startBtn(context),
            ],
          ),
          Container(),
        ],
      ),
    );
  }

  Widget tName(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: TextField(
        decoration: InputDecoration(
          filled: true, // Enable background fill
          fillColor: Colors.grey[200], // Light grey background
          hintText: 'Enter your name...', // Placeholder text
          hintStyle:
              TextStyle(color: Colors.grey[600]), // Placeholder text color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            borderSide: BorderSide.none, // Remove the default border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Rounded corners when focused
            borderSide: BorderSide(
                color: Colors.blue, width: 2.0), // Blue border when focused
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 14.0), // Inner padding
        ),
        style: TextStyle(color: Colors.black, fontSize: 16.0), // Text style
        cursorColor: Colors.blue, // Cursor color
      ),
    );
  }

  startBtn(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.xColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
        child: InkWell(
      child: Container(
        margin: const EdgeInsets.fromLTRB(32,0,32,0),
        child: Text(
          "Start",
          style: TextStyle(fontSize: 35,
           color: AppColor.white)
        ),
      ),
      onTap: () {
        Navigator.pushReplacementNamed(context, RoutesName.game);
      },
    ));
  }
}
