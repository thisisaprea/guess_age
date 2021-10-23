import 'package:flutter/material.dart';

class pageResult extends StatelessWidget {
  static const routeName = '/pageResult';
  const pageResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var age = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.3),
        title:  Text("GUESS TEACHER'S AGE"),

      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'อายุอาจารย์',
                style: Theme.of(context).textTheme.headline5,
              ),
              Text(
                '${age['year']} ปี ${age['month']} เดือน',
                style: Theme.of(context).textTheme.headline2,
              ),
              Icon(
                Icons.check,
                size: 100,
                color: Colors.lightGreen.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
