import 'package:voice/store/action/action.dart';

typedef DispatchCallback = Map<String, dynamic> Function();

Map<String, dynamic> rootReducer(Map<String, dynamic> state, dynamic action) {
  switch (action['type']) {
    case ActionTypes.Increment:
      state['count'] = state['count'] + action['data'];
      return state;
    default:
      return state;
  }
}
