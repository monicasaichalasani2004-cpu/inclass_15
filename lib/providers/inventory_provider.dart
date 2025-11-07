import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class InventoryProvider extends ChangeNotifier {
  final _service = FirestoreService();
  List<Item> _items = [];
  bool _isLoading = true;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;

  InventoryProvider() {
    fetchItems();
  }

  void fetchItems() {
    _service.getItems().listen((snapshot) {
      _items = snapshot;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> addItem(Item item) async {
    await _service.addItem(item);
  }

  Future<void> updateItem(Item item) async {
    await _service.updateItem(item);
  }

  Future<void> deleteItem(String id) async {
    await _service.deleteItem(id);
  }

  // ✅ Getter for total inventory value
  double get totalInventoryValue {
    return _items.fold(0.0, (sum, item) => sum + item.totalValue);
  }
}
