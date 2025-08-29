import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/AllItemsModel.dart';

class EditItemScreen extends StatefulWidget {
  static const String routeName = '/edit_item';
  final Items item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with existing item data
    _nameController.text = widget.item.name ?? '';
    _descriptionController.text = widget.item.description ?? '';
    _priceController.text = widget.item.price?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'فشل في اختيار الصورة',
            style: TextStyle(fontFamily: AppConstants.primaryFont),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocListener<ResourcesBloc, ResourcesState>(
      listener: (context, state) {
        if (state is ResourcesLoading) {
          setState(() => _isLoading = true);
        } else if (state is EditItemSuccess) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تعديل العنصر بنجاح',
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
            ),
          );
          Navigator.pop(context);
        } else if (state is ResourcesError) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: _buildBody(context, textColor),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text(
        'تعديل العنصر',
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Image Picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 2,
                    ),
                  ),
                  child: _selectedImageBytes != null
                      ? ClipOval(
                          child: Image.memory(
                            _selectedImageBytes!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        )
                      : widget.item.imageUrl != null && widget.item.imageUrl!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                widget.item.imageUrl!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Theme.of(context).hintColor,
                            ),
                ),
              ),
            ),
            const SizedBox(height: AppConstants.elementSpacing),
            Center(
              child: Text(
                'تغيير الصورة',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.elementSpacing * 2),

            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'اسم العنصر',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.chair),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال اسم العنصر';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Description Field
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.description),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال وصف العنصر';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Price Field
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'السعر',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.attach_money),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال سعر العنصر';
                }
                if (double.tryParse(value) == null) {
                  return 'يرجى إدخال سعر صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing * 2),

            // Submit Button
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ResourcesBloc>().add(
                              EditItemEvent(
                                id: widget.item.id!,
                                name: _nameController.text,
                                description: _descriptionController.text,
                                price: _priceController.text,
                                image: _selectedImageBytes!,
                              ),
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                backgroundColor: _isLoading
                    ? Theme.of(context).disabledColor
                    : Theme.of(context).primaryColor,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'حفظ التعديلات',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppConstants.primaryFont,
                        color: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}