import 'package:care_taker/exports/exports.dart';

class FencesController extends Cubit<Set<Map<String, dynamic>>> {
  FencesController() : super(data);
  static Set<Map<String, dynamic>> data = {};

  void setFences(Map<String, dynamic> x) {
    state.add(x);
    emit(state);
  }
}
