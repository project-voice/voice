import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:voice/api/User.dart';
import 'package:voice/model/UserModel.dart';
import 'package:voice/provider/UserProvider.dart';

const String MIN_DATETIME = '1990-01-01';

class Birthday extends StatefulWidget {
  final UserModel userModel;
  Birthday({Key key, this.userModel}) : super(key: key);
  _BirthdayState createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.now(),
      initialDateTime: DateTime.parse(widget.userModel.userBirthday),
      locale: DateTimePickerLocale.zh_cn,
      onConfirm: submitBirthday,
    );
  }

  Future<void> submitBirthday(DateTime datetime, list) async {
    try {
      String year = datetime.year.toString();
      String month;
      String day;
      if (datetime.month < 10) {
        month = '0' + datetime.month.toString();
      }
      if (datetime.day < 10) {
        day = '0' + datetime.day.toString();
      }
      String value = '$year-$month-$day';
      var result = await updateUserInfo(
        userid: widget.userModel.userid,
        key: 'user_birthday',
        value: value,
      );
      if (result['noerr'] == 0) {
        await Provider.of<UserProvider>(context, listen: false).setUserMessage(
          'birthday',
          value,
        );
      }
      Toast.show(
        result['message'],
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.CENTER,
      );
    } catch (err) {
      print(err);
    }
  }

  void updateBirthday() {
    showDatePicker();
  }

  @override
  Widget build(BuildContext context) {
    num screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: updateBirthday,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.grey[200]),
          ),
        ),
        padding: EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '生日：',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.7,
                    child: Text(
                      widget.userModel.userBirthday,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
