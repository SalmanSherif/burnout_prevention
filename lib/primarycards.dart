import 'package:flutter/material.dart';
import 'taskData.dart';
import 'customEvent.dart';

class PrimaryCards extends StatefulWidget {

  var taskData = TaskData.getData;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  Widget textCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 200,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 0, top: 22.5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              taskName(taskData[0]),
                              taskDate(taskData[0]),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              taskExtras(taskData[0]),
                              taskIntensity(taskData[0]),
                            ],
                          ),
                        ],
                      )
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget textCard2(CustomEvent myEvent) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 200,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 0, top: 22.5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              taskName(myEvent.eventType),
                              taskDate(myEvent.startDate),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              taskExtras(myEvent.subEvents),
                              taskIntensity(myEvent.taskDifficulty),
                            ],
                          ),
                        ],
                      )
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget taskName(data) {
    return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(left: 14.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: RichText(
              text: TextSpan(
                text: data['name'],
                style: TextStyle(fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 20),
              ),
            ),
          ),
        )
    );
  }

  Widget taskDate(data) {
    return Flexible(
        child: Padding(
          padding: const EdgeInsets.only(top: 2.5, right: 20.0),
          child: Align(
            alignment: Alignment.topRight,
            child: RichText(
              text: TextSpan(
                text: data['time'],
                style: TextStyle(fontWeight: FontWeight.normal,
                    color: Colors.red,
                    fontSize: 15),
              ),
            ),
          ),
        )
    );
  }

  Widget taskExtras(data) {
    return Container(
        child: Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, top: 40.0, right: 14.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    text: "Sketching\nDiscussion\nRe-scheduling",
                    style: TextStyle(fontWeight: FontWeight.normal,
                        color: Colors.red,
                        fontSize: 15),
                  ),
                ),
              ),
            )
        )
    );
  }

  Widget taskIntensity(data) {
    return Container(
        child: Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 14.0, top: 40.0, right: 20.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "2",
                    style: TextStyle(fontWeight: FontWeight.normal,
                        color: Colors.red,
                        fontSize: 32),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\nTask Intensity",
                        style: TextStyle(fontWeight: FontWeight.normal,
                            color: Colors.red,
                            fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }
}