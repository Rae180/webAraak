import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/SubGallery/Models/SubManagersModel.dart';

class EditSubManagerScreen extends StatefulWidget {
  static const String routeName = '/edit_sub_manager';
  final Managers manager;

  const EditSubManagerScreen({super.key, required this.manager});

  @override
  State<EditSubManagerScreen> createState() => _EditSubManagerScreenState();
}

class _EditSubManagerScreenState extends State<EditSubManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with existing manager data
    _nameController.text = widget.manager.name ?? '';
    _emailController.text = widget.manager.email ?? '';
    _phoneController.text = widget.manager.phone ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
          } else if (state is EditSubManagerSuccess) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم تعديل المدير بنجاح',
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
        'تعديل المدير',
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
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
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
                labelText: 'رقم الهاتف',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال رقم الهاتف';
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
                        // Dispatch event to edit sub manager
                        context.read<BranchesBloc>().add(
                              EditSubManagerEvent(
                                id: widget.manager.id!,
                                name: _nameController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                // Note: The image update would need a separate API call
                                // as your current bloc event doesn't support image updates
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
