import './user.dart';
import './videoData.dart';
import './englishCorner.dart';

const String RECOMMEND_INDEX = '推荐';
const String FOLLOW_INDEX = '关注';

Map<String, dynamic> state = {
  'isLogin': false,
  'user': user,
  'vediosData': vediosData,
  'englishCorner': englishCorner,
  'homeSelectedTab': RECOMMEND_INDEX
};
