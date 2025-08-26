import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';

class AddNewSubManagerPage extends StatefulWidget {
  static const String routeName = '/add_new_sub_manager';

  const AddNewSubManagerPage({super.key});

  @override
  State<AddNewSubManagerPage> createState() => _AddNewSubManagerPageState();
}

class _AddNewSubManagerPageState extends State<AddNewSubManagerPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  Uint8List? _selectedImageBytes; // For web image bytes
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider(
      create: (context) => BranchesBloc(client: NetworkApiServiceHttp()),
      child: BlocConsumer<BranchesBloc, BranchesState>(
        listener: (context, state) {
          if (state is BranchesLoading) {
            setState(() => _isLoading = true);
          } else if (state is AddNewSubManagerSuccess) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إضافة المدير بنجاح',
                  style: TextStyle(fontFamily: AppConstants.primaryFont),
                ),
              ),
            );
            Navigator.pop(context);
          } else if (state is BranchesError) {
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
        builder: (context, state) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, textColor),
            body: _buildBody(context, textColor),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text(
        'إضافة مدير جديد',
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
                'إضافة صورة',
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
                labelText: 'الاسم الكامل',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال الاسم';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Email Field
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'البريد الإلكتروني',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال البريد الإلكتروني';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'يرجى إدخال بريد إلكتروني صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Phone Field
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'رقم الهاتف (اختياري)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Password Field
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'كلمة المرور',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال كلمة المرور';
                }
                if (value.length < 6) {
                  return 'كلمة المرور يجب أن تكون على الأقل 6 أحرف';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Confirm Password Field
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'تأكيد كلمة المرور',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              obscureText: _obscureConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى تأكيد كلمة المرور';
                }
                if (value != _passwordController.text) {
                  return 'كلمة المرور غير متطابقة';
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
                        // Dispatch event to add new sub manager
                        context.read<BranchesBloc>().add(
                              AddNewSubManagerEvent(
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text.isNotEmpty
                                    ? _phoneController.text
                                    : null,
                                password: _passwordController.text,
                                imageBytes: _selectedImageBytes, // Pass bytes instead of File
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
                      'إضافة المدير',
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