import 'dart:ffi';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class SizeConfig{
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth -
        _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight -
        _safeAreaVertical) / 100;
  }
}

class SteadiEvent extends StatefulWidget{
  SteadiEvent({Key key, this.eventName}) : super(key: key);

  final String eventName;

  @override
  _SteadiEventState createState() => _SteadiEventState();
}

class _SteadiEventState extends State<SteadiEvent>{

  String _eventType;                   // Event Type
  String _taskDescription;             // User Description of Task
  DateTime _taskCreated;               // Creation Date for Task
  DateTime _taskEnd;                   // End Date for Task
  double _taskDifficulty;                 // Int 0 to 5 rep User Task Difficulty
  List <SteadiEvent> _subEvents;       // Sub Steadi Events
  bool _done;                          // Successful Completion Bool
  bool _taskElapsed;                   // Time Elapsed, Task Failed

  DateTime _defMaxTime = DateTime(2099,1,1);
  DateTime _defMinTime = DateTime(2019,1,1);

  DateTime _selectedStartTime;
  String _formattedStartDate;
  DateTime _selectedEndTime;
  String _formattedEndDate;

  @override
  void initState(){
    super.initState();

    _eventType = "Not Yet Set";
    _taskDescription = "Please write a task description for yourself";
    _taskCreated = _taskEnd = DateTime.now();
    _taskDifficulty = 2;               // Default Value...
    _done = false;
    _taskElapsed = false;

    _selectedStartTime = DateTime.now();
    _formattedStartDate = DateFormat('EEE, MMM d, ''HH:mm').format(_selectedStartTime);
    _selectedEndTime = DateTime.now();
    _formattedEndDate = DateFormat('EEE, MMM d, ''HH:mm').format(_selectedEndTime);
  }

  void taskDone(){
    setState(() {
      _done = true;
    });
  }

  void taskElapsed(){
    setState(() {
      _taskElapsed = true;
    });
  }

  Widget cardTitle(var in_text_size, var in_l_p_size){
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: in_l_p_size,),
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "Give your task a title",
              style: TextStyle(
                color: Colors.black54,
                fontSize: in_text_size,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget namingTask(var in_text_size, var in_l_p_size,  var in_w_size){
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: in_l_p_size,),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: in_w_size,
            height: in_w_size / 7.5,
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: -1),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(6),
                  borderSide: new BorderSide(),
                ),
                fillColor: Colors.black12,
                hintText: "Eg. Brainstorming",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget startTime(var in_text_size, var in_l_p_size, var in_w_size){
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: in_l_p_size,), //20.0
              child: Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                    text: "Start",
                    style: TextStyle(fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        fontSize: in_text_size),
                  ),
                ),
              ),
            )
        ),
        Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(right: in_l_p_size,),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black54)
                  ),
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: _defMinTime,
                        maxTime: _defMaxTime,
                        onConfirm: (date) {
                          setState(() {
                            _selectedStartTime = date;
                            //_formattedDate = DateFormat.MMMMEEEEd().add_Hm().format(_selectedTime);
                            _formattedStartDate = DateFormat('EEE, MMM d, ''HH:mm').format(_selectedStartTime);
                          });
                        },
                        currentTime: _selectedStartTime, locale: LocaleType.en);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: _formattedStartDate,
                      style: TextStyle(fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        fontSize: in_text_size,),
                    ),
                  ),
                ),
              ),
            )
        ),
      ],
    );
  }

  Widget endTime(var in_text_size, var in_l_p_size, var in_w_size){
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: in_l_p_size, top: in_l_p_size,),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: RichText(
                  text: TextSpan(
                    text: "End",
                    style: TextStyle(fontWeight: FontWeight.normal,
                        color: Colors.black54,
                        fontSize: in_text_size),
                  ),
                ),
              ),
            )
        ),
        Expanded(
          flex: 3,
            child: Padding(
              padding: EdgeInsets.only(right: in_l_p_size, top: in_l_p_size,),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black54)
                  ),
                    onPressed: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          minTime: _defMinTime,
                          maxTime: _defMaxTime,
                          onConfirm: (date) {
                            setState(() {
                              _selectedEndTime = date;
                              //_formattedDate = DateFormat.MMMMEEEEd().add_Hm().format(_selectedTime);
                              _formattedEndDate = DateFormat('EEE, MMM d, ''HH:mm').format(_selectedEndTime);
                            });
                          },
                          currentTime: _selectedEndTime, locale: LocaleType.en);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: _formattedEndDate,
                        style: TextStyle(fontWeight: FontWeight.normal,
                            color: Colors.black54,
                            fontSize: in_text_size,),
                      ),
                    ),
                ),
              ),
            )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    var mPV = SizeConfig.blockSizeVertical * 2.3;
    var mPH = SizeConfig.blockSizeHorizontal * 2.7;
    var sPV = SizeConfig.blockSizeVertical * 1;

    return Container(
        padding: EdgeInsets.fromLTRB(mPH, mPV , mPH, mPV),
        //height: 640,
        height: SizeConfig.blockSizeVertical * 85,
        //width: double.maxFinite,
        width: SizeConfig.blockSizeHorizontal * 100,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Stack(children: <Widget>[
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height: sPV * 25),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            color: Colors.black12),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Column(
                          children: <Widget>[
                            customSpacer(sPV * 3),
                            Row(
                              children: <Widget>[
                                cardTitle(sPV * 2.8, mPH * 1.8),
                              ],
                            ),
                            customSpacer(sPV * 5),
                            Row(
                              children: <Widget>[
                                namingTask( sPV * 1.55, 0.0, mPH * 27),
                              ],
                            ),
                            customSpacer(sPV * 3.3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.info_outline,
                                  color: Colors.black45,
                                  size: sPV * 2.2,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: " Frequently done tasks will appear as suggestions here.",
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: sPV * 1.55,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            customSpacer(sPV * 6.5),
                            startTime(sPV * 2.45, mPH * 1.8, mPH),
                            customSpacer(sPV * 0.8),
                            endTime(sPV * 2.45, mPH * 1.8, mPH),
                            customSpacer(sPV * 4.8),
                           Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: mPH * 30,
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: "How difficult do you expect this task to be?",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: sPV * 2.6,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            customSpacer(sPV * 3.5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: RichText(
                                      text: TextSpan(
                                        text: "0",
                                        style: TextStyle(fontWeight: FontWeight.normal,
                                            color: Colors.black54,
                                            fontSize: sPV * 2.8),
                                      ),
                                    ),
                                  ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: sPV * 37,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        activeTrackColor: Color.fromRGBO(161, 199, 255, 100),
                                        inactiveTrackColor: Color.fromRGBO(161, 199, 255, 100),
                                        activeTickMarkColor: Colors.white,
                                        inactiveTickMarkColor: Colors.white,
                                        thumbColor: Colors.grey,
                                        overlayColor: Color.fromRGBO(161, 199, 255, 100),
                                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.5),
                                      ),
                                      child: Slider.adaptive(
                                        value: _taskDifficulty,
                                        onChanged: (newTaskDifficulty){
                                          setState(() => _taskDifficulty = newTaskDifficulty);
                                        },
                                        label: "$_taskDifficulty",
                                        divisions: 4,
                                        min: 0,
                                        max: 4,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "4",
                                      style: TextStyle(fontWeight: FontWeight.normal,
                                          color: Colors.black54,
                                          fontSize: sPV * 2.8),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            customSpacer(sPV * 4.45),
                            RaisedButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: Colors.black54),
                              ),
                              onPressed: () {
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: "Add Task",
                                  style: TextStyle(fontWeight: FontWeight.normal,
                                    color: Colors.black54,
                                    fontSize: sPV * 2.5,),
                                ),
                              ),
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

  Widget customSpacer(in_height){
    return Container(
      height: in_height,
    );
  }
}