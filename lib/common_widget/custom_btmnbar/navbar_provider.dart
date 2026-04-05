import 'package:flutter/foundation.dart';

class AppProvider with ChangeNotifier {
  // Carousel state
  int _carouselIndex = 0;
  int get carouselIndex => _carouselIndex;

  void setCarouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }

  // Navigation state
  int _navigationIndex = 0;
  int get navigationIndex => _navigationIndex;

  void setNavigationIndex(int index) {
    _navigationIndex = index;
    notifyListeners();
  }
}