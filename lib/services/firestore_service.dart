import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item.dart';

class FirestoreService {
  final _items = FirebaseFirestore.instance.collection('items');

  Stream<List<Item>> getItems() {
    return _items.orderBy('createdAt', descending: true).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Item.fromDoc(doc)).toList();
      },
    );
  }

  Future<void> addItem(Item item) async {
    try {
      await _items.add(item.toMap());
      print("✅ Item added successfully!");
    } catch (e) {
      print("❌ Error adding item: $e");
    }
  }

  Future<void> updateItem(Item item) async {
    try {
      await _items.doc(item.id).update(item.toMap());
      print("✅ Item updated successfully!");
    } catch (e) {
      print("❌ Error updating item: $e");
    }
  }

  Future<void> deleteItem(String id) async {
    try {
      await _items.doc(id).delete();
      print("🗑️ Item deleted successfully!");
    } catch (e) {
      print("❌ Error deleting item: $e");
    }
  }

  Future<Item?> getItemById(String id) async {
    try {
      final doc = await _items.doc(id).get();
      if (doc.exists) {
        return Item.fromDoc(doc);
      }
      return null;
    } catch (e) {
      print("❌ Error fetching item: $e");
      return null;
    }
  }
}
