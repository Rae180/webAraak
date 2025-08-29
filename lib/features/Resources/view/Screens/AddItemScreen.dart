import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/view/Screens/PickItemTypeScreen.dart';
import 'package:start/features/Resources/view/Screens/PickRoomScreen.dart';

class AddItemScreen extends StatefulWidget {
  static const String routeName = '/add_item_screen';
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _roomIdController = TextEditingController();
  final _itemTypeIdController = TextEditingController();
  final _woodLengthController = TextEditingController();
  final _woodWidthController = TextEditingController();
  final _woodHeightController = TextEditingController();
  final _fabricLengthController = TextEditingController();
  final _fabricWidthController = TextEditingController();

  Future<void> _selectRoom() async {
    final roomId = await Navigator.pushNamed(context, PickRoomScreen.routeName);
    if (roomId != null) {
      setState(() {
        _roomIdController.text = roomId.toString();
      });
    }
  }

  // Placeholder for item type selection (implement similarly to room selection)
  Future<void> _selectItemType() async {
    final itemTypeId =
        await Navigator.pushNamed(context, PickItemTypeScreen.routeName);
    if (itemTypeId != null) {
      setState(() {
        _itemTypeIdController.text = itemTypeId.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResourcesBloc, ResourcesState>(
      listener: (context, state) {
        if (state is ResourcesLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Saving item...")),
          );
        }
        if (state is AddNewItemSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Item added successfully!")),
          );
          Navigator.pop(context); // Go back after success
        }
        if (state is ResourcesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Item'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_nameController, "Item Name", required: true),
                const SizedBox(height: 16),
                _buildTextField(_descController, "Description", maxLines: 3),
                const SizedBox(height: 16),
                _buildTextField(_priceController, "Price",
                    required: true, keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildSelectableField(_roomIdController, "Room ID",
                    onTap: _selectRoom, required: true),
                const SizedBox(height: 16),
                _buildSelectableField(_itemTypeIdController, "Item Type ID",
                    onTap: _selectItemType, required: true),
                const SizedBox(height: 16),
                _buildTextField(_woodLengthController, "Wood Length",
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(_woodWidthController, "Wood Width",
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(_woodHeightController, "Wood Height",
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(_fabricLengthController, "Fabric Length",
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                _buildTextField(_fabricWidthController, "Fabric Width",
                    keyboardType: TextInputType.number),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Item'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool required = false,
      int maxLines = 1,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (required && (value == null || value.isEmpty)) {
          return 'Required';
        }
        return null;
      },
    );
  }

  Widget _buildSelectableField(TextEditingController controller, String label,
      {bool required = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: IgnorePointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          validator: (value) {
            if (required && (value == null || value.isEmpty)) {
              return 'Required';
            }
            return null;
          },
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ResourcesBloc>().add(
            AddNewItemEvent(
              name: _nameController.text,
              description: _descController.text,
              roomId: _roomIdController.text,
              itemTypeId: _itemTypeIdController.text,
              woodLength: _woodLengthController.text,
              woodWidth: _woodWidthController.text,
              woodHeight: _woodHeightController.text,
              fabricLength: _fabricLengthController.text,
              fabricWidth: _fabricWidthController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _roomIdController.dispose();
    _itemTypeIdController.dispose();
    _woodLengthController.dispose();
    _woodWidthController.dispose();
    _woodHeightController.dispose();
    _fabricLengthController.dispose();
    _fabricWidthController.dispose();
    super.dispose();
  }
}
