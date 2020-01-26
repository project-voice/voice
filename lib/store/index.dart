import 'package:redux/redux.dart';
import 'package:voice/store/reducer/reducer.dart';
import 'package:voice/store/state/index.dart';

Store<Map<String, dynamic>> store = Store(rootReducer, initialState: state);
