enum ActionTypes {
  Increment,
}

Map<String, dynamic> createActionHandler(ActionTypes type, dynamic data) {
  return {'type': type, 'data': data};
}
