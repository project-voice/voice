import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:voice/store/action/action.dart';

class FluentSpeak extends StatefulWidget {
  _FluentSpeakState createState() => _FluentSpeakState();
}

class _FluentSpeakState extends State<FluentSpeak> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Column(children: <Widget>[
        StoreConnector(converter: (store) {
          return store.state['count'];
        }, builder: (context, counter) {
          return Text('$counter');
        }),
        StoreConnector(
          converter: (store) {
            return (count) => store
                .dispatch(createActionHandler(ActionTypes.Increment, count));
          },
          builder: (BuildContext context, callback) {
            return FlatButton(
              child: Text('点击'),
              onPressed: () {
                callback(123);
              },
            );
          },
        )
      ]),
    ));
  }
}
