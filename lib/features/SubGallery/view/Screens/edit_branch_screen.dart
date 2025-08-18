// edit_branch_screen.dart
import 'package:flutter/material.dart';

class EditBranchScreen extends StatefulWidget {
  final Map<String, dynamic> branch;

  const EditBranchScreen({super.key, required this.branch});

  @override
  State<EditBranchScreen> createState() => _EditBranchScreenState();
}

class _EditBranchScreenState extends State<EditBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _addressController;
  late TextEditingController _workingHoursController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.branch['name']);
    _locationController = TextEditingController(text: widget.branch['location']);
    _addressController = TextEditingController(text: widget.branch['address']);
    _workingHoursController = TextEditingController(text: widget.branch['workingHours']);
    _emailController = TextEditingController(text: widget.branch['email']);
    _phoneController = TextEditingController(text: widget.branch['phone']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الفرع')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم الفرع *'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'الموقع *'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'العنوان التفصيلي *'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _workingHoursController,
                decoration: const InputDecoration(labelText: 'ساعات العمل *'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم الهاتف'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'name': _nameController.text,
                      'location': _locationController.text,
                      'address': _addressController.text,
                      'workingHours': _workingHoursController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                      'manager': widget.branch['manager'],
                    });
                  }
                },
                child: const Text('حفظ التعديلات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}