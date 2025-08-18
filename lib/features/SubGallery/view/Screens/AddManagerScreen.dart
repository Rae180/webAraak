import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddManagerScreen extends StatefulWidget {
  final Map<String, dynamic>? existingManager;

  const AddManagerScreen({super.key, this.existingManager});

  @override
  State<AddManagerScreen> createState() => _AddManagerScreenState();
}

class _AddManagerScreenState extends State<AddManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  File? _imageFile;
  String? _existingImagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingManager?['name']);
    _phoneController = TextEditingController(text: widget.existingManager?['phone']);
    _emailController = TextEditingController(text: widget.existingManager?['email']);
    _addressController = TextEditingController(text: widget.existingManager?['address']);
    _existingImagePath = widget.existingManager?['imagePath'];
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _existingImagePath = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingManager == null ? 'إضافة مدير جديد' : 'تعديل المدير'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _getBackgroundImage(),
                    child: _showPlaceholderIcon(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل *'),
                validator: (val) => val!.isEmpty ? 'حقل مطلوب' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'العنوان'),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveManager,
                child: const Text('حفظ البيانات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getBackgroundImage() {
    if (_imageFile != null) return FileImage(_imageFile!);
    if (_existingImagePath != null) return FileImage(File(_existingImagePath!));
    return null;
  }

  Widget? _showPlaceholderIcon() {
    if (_imageFile == null && _existingImagePath == null) {
      return const Icon(Icons.person_add, size: 40, color: Colors.grey);
    }
    return null;
  }

  void _saveManager() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'address': _addressController.text,
        'imagePath': _imageFile?.path ?? _existingImagePath,
      });
    }
  }
}