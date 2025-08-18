import 'package:flutter/material.dart';

class AddBranchDetailsScreen extends StatefulWidget {
  final String selectedManager;

  const AddBranchDetailsScreen({super.key, required this.selectedManager});

  @override
  State<AddBranchDetailsScreen> createState() => _AddBranchDetailsScreenState();
}

class _AddBranchDetailsScreenState extends State<AddBranchDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _workingHoursController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الفرع الجديد')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('مدير الفرع: ${widget.selectedManager}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'اسم الفرع *'),
                validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال اسم الفرع' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'الموقع *'),
                validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال الموقع' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'العنوان التفصيلي *'),
                validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال العنوان التفصيلي' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workingHoursController,
                decoration: const InputDecoration(labelText: 'ساعات العمل *'),
                validator: (value) =>
                value == null || value.isEmpty ? 'يرجى إدخال ساعات العمل' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
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
                      'manager': widget.selectedManager,
                    });
                  }
                },
                child: const Text('حفظ الفرع'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}