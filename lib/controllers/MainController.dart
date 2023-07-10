import '/exports/exports.dart';

class MainController with ChangeNotifier {
  final Set<Map<String,dynamic>> _fences = {};
  // getters and setters
  Set<Map<String,dynamic>> get fences => _fences;


  void setFences(Map<String, dynamic> map){
    _fences.add(map);
    notifyListeners();
  }
}

