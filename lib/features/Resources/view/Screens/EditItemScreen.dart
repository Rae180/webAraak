import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/AllItemsModel.dart';

class EditItemScreen extends StatefulWidget {
  static const String routeName = '/edit_item_screen';
  final Items? item;

  const EditItemScreen({super.key, this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Image picking variables
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descController =
        TextEditingController(text: widget.item?.description ?? '');
    _priceController =
        TextEditingController(text: widget.item?.price?.toString() ?? '');
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    if (widget.item == null) {
      return Scaffold(
          appBar: AppBar(), body: Center(child: Text('Item not found')));
    }

    return BlocListener<ResourcesBloc, ResourcesState>(
      listener: (context, state) {
        if (state is ResourcesLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is EditItemSuccess) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم تحديث العنصر بنجاح',
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state is ResourcesError) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text(
            'تعديل العنصر',
            style: TextStyle(
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _isLoading ? null : _saveItem,
            ),
          ],
        ),
        body: _isLoading
            ? _buildLoadingIndicator()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.sectionPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Image Picker Section
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
                              child: ClipOval(
                                child: Image.memory(
                                  _selectedImageBytes!,
                                  fit: BoxFit.cover,
                                  width: 120,
                                  height: 120,
                                ),
                              )),
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
                          labelStyle: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                            color: textColor.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: AppConstants.primaryFont,
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
                        controller: _descController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'الوصف',
                          labelStyle: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                            color: textColor.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: AppConstants.primaryFont,
                        ),
                      ),
                      const SizedBox(height: AppConstants.elementSpacing),

                      // Price Field
                      TextFormField(
                        controller: _priceController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'السعر',
                          labelStyle: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                            color: textColor.withOpacity(0.7),
                          ),
                          prefixText: '\$ ',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
                          ),
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontFamily: AppConstants.primaryFont,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجى إدخال السعر';
                          }
                          if (double.tryParse(value) == null) {
                            return 'يرجى إدخال سعر صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.elementSpacing * 2),

                      // Save Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveItem,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.cardRadius),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'حفظ التغييرات',
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
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'جاري التحديث...',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descController.text;
      final price = _priceController.text;

      // Dispatch the EditItemEvent
      context.read<ResourcesBloc>().add(
            EditItemEvent(
              id: widget.item!.id!,
              name: name,
              description: description,
              price: price,
              image: _selectedImageBytes!, // Pass the selected image bytes
            ),
          );
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
