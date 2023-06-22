import '/exports/exports.dart';

class MainController extends ChangeNotifier {
  MapType _type = MapType.normal;
  // get
  MapType get type => _type;
void setMapType(MapType value) {
    _type = value;
    notifyListeners();
  }
}

