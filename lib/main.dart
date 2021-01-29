import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bulls_eye/prompt.dart';
import 'package:bulls_eye/control.dart';
import 'score.dart';
import 'gamemodel.dart';

void main() => runApp(BullsEyeApp());

class BullsEyeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'BullsEye',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GamePage(title: 'BullsEye'),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _alertIsVisible = false;
  GameModel _model;

  @override
  void initState() {
    super.initState();
    _model = GameModel(_newTargetValue()); //GameModel constructor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Prompt(targetValue: _model.target),
            Control(
              model: _model,
            ),
            FlatButton(
              child: Text('Hit Me!', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                _showAlert(context);
                this._alertIsVisible = true;
              },
            ),
            Score(
              totalScore: _model.totalScore,
              round: _model.round,
              onStartOver: _startNewGame,
            ),
          ],
        ),
      ),
    );
  }

  /* int _pointsForCurrentRound() {
    int maximumScore = 100;
    int difference;
    int sliderValue = _model.current;
    if (sliderValue > _model.target) {
      difference = sliderValue - _model.target;
    } else if (_model.target > sliderValue) {
      difference = _model.target - sliderValue;
    } else {
      difference = 0;
    }
    return maximumScore - difference;
  }*/ // long version

  int _sliderValue() => _model.current;

  int _pointsForCurrentRound() {
    var maximumScore = 100;
    var difference = _amountOff();
    var bonus = 0;
    if (difference == 0) {
      bonus = 100;
    } else if (difference == 1) {
      bonus = 50;
    }
    return maximumScore - difference + bonus;
  } // short version + bonus

  int _newTargetValue() => Random().nextInt(100) + 1;

  void _startNewGame() {
    setState(() {
      _model.totalScore = GameModel.SCORE_START;
      _model.round = GameModel.ROUND_START;
      _model.target = _newTargetValue();
      _model.current = GameModel.SLIDER_START;
    });
  }

  void _showAlert(BuildContext context) {
    Widget okButton = FlatButton(
        child: Text("Awesome!"),
        onPressed: () {
          Navigator.of(context).pop();
          this._alertIsVisible = false;
          setState(() {
            _model.totalScore += _pointsForCurrentRound();
            //   _model.totalScore = _model.totalScore + _pointsForCurrentRound();
            _model.target = _newTargetValue();
            _model.round += 1;
          });
        });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_alertTitle()),
          content: Text("The slider's value is ${_sliderValue()}.\n" +
              "You scored ${_pointsForCurrentRound()} points this round."),
          actions: <Widget>[
            okButton,
          ],
          elevation: 5,
        );
      },
    );
  }

  int _amountOff() => (_model.target - _sliderValue()).abs();

  String _alertTitle() {
    var difference = _amountOff();

    String title;
    if (difference == 0) {
      title = "Perfect!";
    } else if (difference < 5) {
      title = "You almost had it!";
    } else if (difference <= 10) {
      title = "Not bad";
    } else {
      title = "Are you even trying?";
    }

    return title;
  }
}
//TODO: add another button that says knock knock
//TODO: if you tap the button you will get a message who's there in his title
//TODO: a knock knock joke will apear in a message in dismiss button

//TODO: add a flat button below the hit me button that has the text knock knock
//TODO: write a code to display a pop up alert that is saying who's there
//TODO: copy amd paste the alert visible property and rename it to who's there is Visible
//TODO: modify the knock knock action to say who's there is visible to true
//TODO: call the alert method on the knock knock button to present an alert who's there at the state variable is true
