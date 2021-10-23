import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:guess_age/api/api.dart';

class Guess_Age extends StatefulWidget {
  static const routeName = '/GuessPage';

  const Guess_Age({Key? key}) : super(key: key);

  @override
  _Guess_AgeState createState() => _Guess_AgeState();
}

class _Guess_AgeState extends State<Guess_Age> {
  @override
  int y = 0;
  int m = 0;
  bool checkAge = false;
  var _isLoading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GUESS TEACHER'S AGE"),
        backgroundColor: Colors.indigo.shade400,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.deepOrangeAccent.shade100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'อายุอาจารย์',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 8.0,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          child: SpinBox(
                            min: 1,
                            max: 60,
                            value: 0,
                            decoration: InputDecoration(
                              labelText: 'ปี',
                              labelStyle: Theme.of(context).textTheme.headline2,
                            ),
                            onChanged: (year) {
                              setState(() {
                                print(year);
                                y = year as int;
                              });
                            },
                          ),
                          padding: const EdgeInsets.all(16),
                        ),
                        Padding(
                          child: SpinBox(
                              min: 1,
                              max: 12,
                              value: 0,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: 'เดือน',
                                labelStyle:
                                    Theme.of(context).textTheme.headline2,
                              ),
                              onChanged: (month) {
                                setState(() {
                                  print(month);
                                  m = month as int;
                                });
                              }),
                          padding: const EdgeInsets.all(16),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _handleClickButton,
                              child: Text(
                                'ทาย',
                                style: TextStyle(
                                    fontSize: 24.0, color: Colors.white60),
                              ),
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(150.0, 50.0),
                                primary: Colors.indigo.shade400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if(_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: SizedBox(
                    width: 100.0,
                    height: 100.0,
                    child: CircularProgressIndicator(color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }

  _handleClickButton() async {
    var guest = await _loading(y, m);

    if (guest['value'] == true) {
      Navigator.pushReplacementNamed(
        context,
        '/pageResult',
        arguments: {'year': y, 'month': m},
      );
    } else {
      _showMaterialDialog('ผลการทาย', '${guest['text']}');
    }
  }

  void _showMaterialDialog(String str, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(str),
          content: Text(text, style: Theme.of(context).textTheme.headline2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white60,
                ),
              ),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _guessAge() async {
    var data =
        (await Api().submit("guess_teacher_age", {'year': y, 'month': m}))
            as Map<String, dynamic>;
    if (data == null) {
      return;
    } else {
      String text = data['text'];
      bool value = data['value'];
      if (value) {
        setState(() {
          checkAge = true;
        });
      } else {
        _showMaterialDialog("ผลการทาย", text);
      }
    }
  }

  Future<dynamic> _loading(int y, int m) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var isLogin =
          (await Api().submit('guess_teacher_age', {'year': y, 'month': m}));
      print('Loading: $isLogin');
      return isLogin;
    } catch (e) {
      print(e);
      _showMaterialDialog('ERROR', e.toString());
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
