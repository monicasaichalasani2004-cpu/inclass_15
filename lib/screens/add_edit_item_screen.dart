import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;
  const AddEditItemScreen({super.key, this.item});

  @override
  State<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _catCtrl = TextEditingController();
  final service = FirestoreService();
  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final it = widget.item!;
      _nameCtrl.text = it.name;
      _qtyCtrl.text = it.quantity.toString();
      _priceCtrl.text = it.price.toString();
      _catCtrl.text = it.category;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    _catCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final item = Item(
      id: widget.item?.id,
      name: _nameCtrl.text.trim(),
      quantity: int.tryParse(_qtyCtrl.text.trim()) ?? 0,
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      category: _catCtrl.text.trim(),
      createdAt: widget.item?.createdAt,
    );
    if (isEdit) {
      await service.updateItem(item);
    } else {
      await service.addItem(item);
    }
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    if (!isEdit || widget.item?.id == null) return;
    await service.deleteItem(widget.item!.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Item' : 'Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Name'), validator: (v)=> (v==null||v.trim().isEmpty)?'Enter name':null),
              TextFormField(controller: _qtyCtrl, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number, validator: (v)=> (v==null||v.trim().isEmpty)?'Enter qty':null),
              TextFormField(controller: _priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: const TextInputType.numberWithOptions(decimal: true), validator: (v)=> (v==null||v.trim().isEmpty)?'Enter price':null),
              TextFormField(controller: _catCtrl, decoration: const InputDecoration(labelText: 'Category')),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: ElevatedButton(onPressed: _save, child: Text(isEdit ? 'Update' : 'Add'))),
                  if (isEdit) const SizedBox(width: 8),
                  if (isEdit)
                    ElevatedButton(
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: const Text('Delete?'),
                            content: const Text('Delete this item?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('No')),
                              TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Yes')),
                            ],
                          ),
                        );
                        if (confirm == true) _delete();
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Delete'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
