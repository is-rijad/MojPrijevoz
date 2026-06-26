import 'package:flutter/material.dart';

class RequestChangesProvider with ChangeNotifier {
  final selectedItems = <String, bool>{};
  final Map<String, TextEditingController> noteEditingControllers = {};

  void refresh() {
    selectedItems.clear();
    for (var it in noteEditingControllers.entries) {
      it.value.clear();
    }
    notifyListeners();
  }

  void toogleItem(String key) {
    if (selectedItems.containsKey(key)) {
      selectedItems.remove(key);
    } else {
      selectedItems[key] = true;
    }
    notifyListeners();
  }

  bool getValue(String key) {
    return selectedItems.containsKey(key) ? selectedItems[key]! : false;
  }

  void createControllers(Iterable<MapEntry<String, dynamic>> entityEntries) {
    noteEditingControllers.addEntries(
      entityEntries.map((it) => MapEntry(it.key, TextEditingController())),
    );
  }

  @override
  void dispose() {
    selectedItems.clear();
    for (final c in noteEditingControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, String> getNotes() {
    return noteEditingControllers.map((k, v) => MapEntry(k, v.text));
  }

  List<String> getSelectedItems() {
    return selectedItems.entries.map((it) => it.key).toList();
  }

  bool isEmpty() {
    return !(noteEditingControllers.values.any((it) => it.text.isNotEmpty) ||
        selectedItems.isNotEmpty);
  }
}
