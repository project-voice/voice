import 'package:voice/store/action/action.dart';

typedef DispatchCallback = Map<String, dynamic> Function();

Map<String, dynamic> rootReducer(Map<String, dynamic> state, dynamic action) {
  switch (action['type']) {
    case ActionTypes.UpdateHomeSelectedTab:
      state['homeSelectedTab'] = action['data'];
      return state;
    case ActionTypes.VideoSupport:
      List vediosData = state['vediosData'];
      for (num i = 0, len = vediosData.length; i < len; i++) {
        if (vediosData[i]['id'] == action['data']) {
          Map videoData = vediosData[i];
          videoData['support']['count']++;
          videoData['support']['action'] = true;
          break;
        }
      }
      return state;
    case ActionTypes.VideoShare:
      List vediosData = state['vediosData'];
      for (num i = 0, len = vediosData.length; i < len; i++) {
        if (vediosData[i]['id'] == action['data']) {
          Map videoData = vediosData[i];
          videoData['share']++;
          break;
        }
      }
      return state;

    // englishCorner
    case ActionTypes.EnglishCornerRefresh:
      state['englishCorner'] = action['data'];
      return state;
    case ActionTypes.EnglishCornerLoad:
      Map englishCorner = state['englishCorner'];
      List topicContent = englishCorner['topicContent'];
      Map loadData = action['data'];
      num index = loadData['index'];
      List data = loadData['topicContent'];
      topicContent[index].addAll(data);
      return state;
    default:
      return state;
  }
}
