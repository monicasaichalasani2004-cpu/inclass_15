import 'package:flutter/material.dart';
import '../models/item.dart';
import '../screens/add_edit_item_screen.dart';
import 'package:provider/provider.dart';
import '../providers/inventory_provider.dart';

class ItemTile extends StatelessWidget {
  final Item item;
  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<InventoryProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(
          "Category: ${item.category}\nQty: ${item.quantity}, Price: \$${item.price.toStringAsFixed(2)}",
        ),
        isThreeLine: true,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => provider.deleteItem(item.id!),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditItemScreen(item: item)),
          );
        },
      ),
    );
  }
}
