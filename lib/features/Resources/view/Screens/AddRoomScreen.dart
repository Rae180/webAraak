import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddRoomScreen extends StatefulWidget {
  static const String routeName = '/add_room_screen';
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  List<Color> selectedColors = [];
  String? _glbPath;
  List<String> selectedItems = []; // Selected item IDs
  List<Map<String, dynamic>> availableItems = [
    // Sample items data
    {'id': 'item1', 'name': 'Modern Sofa', 'price': 499.99},
    {'id': 'item2', 'name': 'Coffee Table', 'price': 199.99},
    {'id': 'item3', 'name': 'Floor Lamp', 'price': 89.99},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Room'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Room Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),

              // 3D Model Upload
              _buildModelUploadSection(),
              const SizedBox(height: 24),

              // Color Selection
              _buildColorSelection(),
              const SizedBox(height: 24),

              // Included Items
              _buildItemSelection(),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Save Room'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModelUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('3D Model (.glb only)',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _glbPath == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_upload, size: 40),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _pickGlbFile,
                        child: const Text('Upload GLB File'),
                      ),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    // 3D preview placeholder
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.view_in_ar,
                              size: 60, color: Theme.of(context).primaryColor),
                          const SizedBox(height: 8),
                          Text(
                            File(_glbPath!).uri.pathSegments.last,
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() => _glbPath = null),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildColorSelection() {
    // Predefined color options
    final List<Color> colorOptions = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.amber,
      Colors.brown,
      Colors.grey,
      Colors.black,
      Colors.white,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Available Colors',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colorOptions.map((color) {
            bool isSelected = selectedColors.contains(color);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedColors.remove(color);
                  } else {
                    selectedColors.add(color);
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (selectedColors.isNotEmpty) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: selectedColors.map((color) {
              return Chip(
                label: Text(
                  '#${color.value.toRadixString(16).substring(2)}',
                  style: TextStyle(
                      color: color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white),
                ),
                backgroundColor: color,
                onDeleted: () {
                  setState(() => selectedColors.remove(color));
                },
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildItemSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Included Items',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...availableItems.map((item) {
          bool isSelected = selectedItems.contains(item['id']);
          return CheckboxListTile(
            title: Text(item['name']),
            subtitle: Text('\$${item['price']}'),
            value: isSelected,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  selectedItems.add(item['id']);
                } else {
                  selectedItems.remove(item['id']);
                }
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Future<void> _pickGlbFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['glb'],
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _glbPath = result.files.first.path;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Create room object
      final room = {
        'name': _nameController.text,
        'description': _descController.text,
        'price': double.parse(_priceController.text),
        'colors': selectedColors.map((c) => c.value).toList(),
        'glbPath': _glbPath,
        'items': selectedItems,
      };

      // Save room logic would go here (API call, database insert, etc.)
      print('Saving room: $room');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room saved successfully')),
      );

      // Close screen after saving
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
