import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/CategoryModel.dart';
import 'package:start/features/Resources/Models/AllWoodModel.dart';
import 'package:start/features/Resources/Models/AllFabricModel.dart';

class AddRoomScreen extends StatefulWidget {
  static const String routeName = '/add-room';
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _selectedCategoryId;
  String? _selectedCategoryName;

  int? _selectedWoodId;
  int? _selectedWoodColorId;
  String? _selectedWoodName;

  int? _selectedFabricId;
  int? _selectedFabricColorId;
  String? _selectedFabricName;

  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();

  // Track which data has been loaded
  bool _categoriesLoaded = false;
  bool _woodsLoaded = false;
  bool _fabricsLoaded = false;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        // Read image as bytes for web
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

  void _loadCategories() {
    if (!_categoriesLoaded) {
      context.read<ResourcesBloc>().add(GetCaategoriesEvent());
      _categoriesLoaded = true;
    }
  }

  void _loadWoods() {
    if (!_woodsLoaded) {
      context.read<ResourcesBloc>().add(GetAllWoodEvent());
      _woodsLoaded = true;
    }
  }

  void _loadFabrics() {
    if (!_fabricsLoaded) {
      context.read<ResourcesBloc>().add(GetAllFabricEvent());
      _fabricsLoaded = true;
    }
  }

  void _showCategoriesDialog(List<Categories> categories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر التصنيف',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.primaryFont,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(
                          category.name ?? 'No Name',
                          style: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedCategoryId = category.id;
                            _selectedCategoryName = category.name;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: AppConstants.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showWoodsDialog(List<Wood> woods) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر نوع الخشب',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.primaryFont,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: woods.length,
                    itemBuilder: (context, index) {
                      final wood = woods[index];
                      return ListTile(
                        title: Text(
                          '${wood.type} - ${wood.color}',
                          style: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                        subtitle: Text(
                          'السعر: ${wood.pricePerMeter ?? 'N/A'}',
                          style: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedWoodId = wood.woodTypeId;
                            _selectedWoodColorId = wood.woodColorId;
                            _selectedWoodName = '${wood.type} - ${wood.color}';
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: AppConstants.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFabricsDialog(List<Fabric> fabrics) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر نوع القماش',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.primaryFont,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: fabrics.length,
                    itemBuilder: (context, index) {
                      final fabric = fabrics[index];
                      return ListTile(
                        title: Text(
                          '${fabric.type} - ${fabric.color}',
                          style: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                        subtitle: Text(
                          'السعر: ${fabric.pricePerMeter ?? 'N/A'}',
                          style: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedFabricId = fabric.fabricTypeId;
                            _selectedFabricColorId = fabric.fabricColorId;
                            _selectedFabricName =
                                '${fabric.type} - ${fabric.color}';
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      fontFamily: AppConstants.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    print(' the selected category id is : ${_selectedCategoryId}');
    print(' the selected wood id is : ${_selectedWoodId}');
    print(' the selected wood color id is : ${_selectedWoodColorId}');
    print(' the selected fabric id is : ${_selectedFabricId}');
    print(' the selected fabric color id is : ${_selectedFabricColorId}');
    print(' the image is : ${_selectedImageBytes}');
    print(' the name is : ${_nameController.text}');
    print(' the descrption is : ${_descriptionController.text}');
    if (_formKey.currentState!.validate() &&
        _selectedCategoryId != null &&
        _selectedWoodId != null &&
        _selectedWoodColorId != null &&
        _selectedFabricId != null &&
        _selectedFabricColorId != null &&
        _selectedImageBytes != null) {
      context.read<ResourcesBloc>().add(AddNewRoomEvent(
            name: _nameController.text,
            description: _descriptionController.text,
            Catid: _selectedCategoryId!,
            woodId: _selectedWoodId!,
            woodColorId: _selectedWoodColorId!,
            fabricId: _selectedFabricId!,
            faabricColorId: _selectedFabricColorId!,
            imageUrl: _selectedImageBytes!,
          ));
    }
  }

  Widget _buildSelectionField(String title, String? selectedValue,
      VoidCallback onTap, bool isRequired, bool isLoading) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isLoading)
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'جاري التحميل...',
                          style: TextStyle(
                            color: textColor.withOpacity(0.7),
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      selectedValue ?? title,
                      style: TextStyle(
                        color: selectedValue != null
                            ? textColor
                            : textColor.withOpacity(0.5),
                        fontFamily: AppConstants.primaryFont,
                      ),
                    ),
                  ),
                Icon(
                  Icons.arrow_drop_down,
                  color: textColor,
                ),
              ],
            ),
          ),
        ),
        if (isRequired && selectedValue == null && !isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              'يرجى اختيار $title',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontFamily: AppConstants.primaryFont,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إضافة غرفة جديدة',
          style: TextStyle(
            fontFamily: AppConstants.primaryFont,
            color: textColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ResourcesBloc, ResourcesState>(
        listener: (context, state) {
          if (state is AddNewRoomSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تمت إضافة الغرفة بنجاح',
                  style: TextStyle(fontFamily: AppConstants.primaryFont),
                ),
              ),
            );
            Navigator.pop(context);
          }

          if (state is ResourcesError) {
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
        builder: (context, state) {
          // Get the available data from the state
          List<Categories> categories = [];
          List<Wood> woods = [];
          List<Fabric> fabrics = [];

          bool isLoadingCategories = false;
          bool isLoadingWoods = false;
          bool isLoadingFabrics = false;

          if (state is GetCategoriesSuccess) {
            categories = state.model.categories ?? [];
          } else if (state is ResourcesLoading && _categoriesLoaded) {
            isLoadingCategories = true;
          }

          if (state is GetAllWoodSuccess) {
            woods = state.woods.wood ?? [];
          } else if (state is ResourcesLoading && _woodsLoaded) {
            isLoadingWoods = true;
          }

          if (state is GetAllFabricSuccess) {
            fabrics = state.fabric.fabric ?? [];
          } else if (state is ResourcesLoading && _fabricsLoaded) {
            isLoadingFabrics = true;
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.sectionPadding),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Image Picker
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius),
                        border: Border.all(
                          color: theme.dividerColor.withOpacity(0.2),
                        ),
                      ),
                      child: _selectedImageBytes != null
                          ? Image.memory(_selectedImageBytes!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: theme.primaryColor,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'إضافة صورة',
                                  style: TextStyle(
                                    color: textColor,
                                    fontFamily: AppConstants.primaryFont,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم الغرفة',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال اسم الغرفة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'وصف الغرفة',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius),
                      ),
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال وصف الغرفة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Category Field
                  _buildSelectionField(
                    'اختر التصنيف',
                    _selectedCategoryName,
                    () {
                      _loadCategories();
                      if (categories.isNotEmpty) {
                        _showCategoriesDialog(categories);
                      }
                    },
                    true,
                    isLoadingCategories,
                  ),
                  const SizedBox(height: 16),

                  // Wood Field
                  _buildSelectionField(
                    'اختر نوع الخشب',
                    _selectedWoodName,
                    () {
                      _loadWoods();
                      if (woods.isNotEmpty) {
                        _showWoodsDialog(woods);
                      }
                    },
                    true,
                    isLoadingWoods,
                  ),
                  const SizedBox(height: 16),

                  // Fabric Field
                  _buildSelectionField(
                    'اختر نوع القماش',
                    _selectedFabricName,
                    () {
                      _loadFabrics();
                      if (fabrics.isNotEmpty) {
                        _showFabricsDialog(fabrics);
                      }
                    },
                    true,
                    isLoadingFabrics,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: state is ResourcesLoading ? null : _submitForm,
                    child: state is ResourcesLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            'إضافة الغرفة',
                            style: TextStyle(
                              fontFamily: AppConstants.primaryFont,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
