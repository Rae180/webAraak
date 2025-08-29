import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';

class AddNewFabricScreen extends StatefulWidget {
  static const String routeName = '/add-new-fabric';

  const AddNewFabricScreen({super.key});

  @override
  State<AddNewFabricScreen> createState() => _AddNewFabricScreenState();
}

class _AddNewFabricScreenState extends State<AddNewFabricScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fabricNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _fabricColorController = TextEditingController();

  @override
  void dispose() {
    _fabricNameController.dispose();
    _priceController.dispose();
    _fabricColorController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final fabricName = _fabricNameController.text;
      final price = _priceController.text;
      final fabricColor = _fabricColorController.text;

      context.read<ResourcesBloc>().add(
            AddNewFabricEvent(
              fabricName: fabricName,
              price: price,
              fabricColor: fabricColor,
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
        if (state is AddNewFabricSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تمت إضافة القماش بنجاح',
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
        if (state is ResourcesError) {
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
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          title: Text(
            'إضافة قماش جديد',
            style: TextStyle(
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(AppConstants.sectionPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _fabricNameController,
                  label: 'نوع القماش',
                  hintText: 'أدخل نوع القماش',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال نوع القماش';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.elementSpacing),
                _buildTextField(
                  controller: _priceController,
                  label: 'السعر للمتر',
                  hintText: 'أدخل السعر للمتر',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال السعر للمتر';
                    }
                    if (double.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.elementSpacing),
                _buildTextField(
                  controller: _fabricColorController,
                  label: 'لون القماش',
                  hintText: 'أدخل لون القماش',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال لون القماش';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.sectionPadding),
                BlocBuilder<ResourcesBloc, ResourcesState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is ResourcesLoading ? null : _submitForm,
                        child: state is ResourcesLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                'إضافة',
                                style: TextStyle(
                                  fontFamily: AppConstants.primaryFont,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
