import 'package:flutter/material.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';

class EditRoomScreen extends StatefulWidget {
  static const String routeName = '/edit_room_screen';
  final Map<String, dynamic>? room;

  const EditRoomScreen({super.key,this.room});

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late List<Color> selectedColors;
  late String? _glbPath;
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.room!['name']);
    _descController = TextEditingController(text: widget.room!['description']);
    _priceController =
        TextEditingController(text: widget.room!['price']?.toString() ?? '');

    selectedColors = (widget.room!['colors'] as List<dynamic>?)
            ?.map((c) => Color(c as int))
            ?.toList() ??
        [];

    selectedItems = (widget.room!['items'] as List<dynamic>?)
            ?.map((i) => i.toString())
            ?.toList() ??
        [];

    _glbPath = widget.room!['glbPath'];
  }

  @override
  Widget build(BuildContext context) {
    return AddRoomScreen(
        // Reuse the AddRoomScreen with existing data
        );
  }
}
