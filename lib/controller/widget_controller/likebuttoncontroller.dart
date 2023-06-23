import 'package:flutter/material.dart';

class LikeButtonController extends ChangeNotifier {
  static final LikeButtonController _instance =
      LikeButtonController._internal();
  int likes = 0;
  bool isLiked = false;
  LikeButtonController._internal();

  factory LikeButtonController() {
    return _instance;
  }

  void like() {
    likes += isLiked ? -1 : 1;
    isLiked = !isLiked;
    notifyListeners();
  }

  void setLike(Map<String, dynamic> data) {
    likes = data['likes'];
    isLiked = data['isLiked'];
    notifyListeners();
  }
}
