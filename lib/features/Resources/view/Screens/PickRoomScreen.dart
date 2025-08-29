import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/AllRoomsModel.dart';

class PickRoomScreen extends StatefulWidget {
  static const String routeName = '/pick_room';

  const PickRoomScreen({super.key});

  @override
  State<PickRoomScreen> createState() => _PickRoomScreenState();
}

class _PickRoomScreenState extends State<PickRoomScreen> {
  @override
  void initState() {
    super.initState();
    // Load rooms when the screen is initialized
    context.read<ResourcesBloc>().add(GetAllRoomsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Room'),
      ),
      body: BlocBuilder<ResourcesBloc, ResourcesState>(
        builder: (context, state) {
          if (state is GetAllRoomsSuccess) {
            return _buildRoomsList(state.allRoomsModel);
          } else if (state is ResourcesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ResourcesError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildRoomsList(AllRoomsModel rooms) {
    if (rooms.rooms == null || rooms.rooms!.isEmpty) {
      return const Center(child: Text('No rooms available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: rooms.rooms!.length,
      itemBuilder: (context, index) {
        final room = rooms.rooms![index];
        return Card(
          child: ListTile(
            title: Text(room.name ?? 'Unnamed Room'),
            subtitle: Text(room.description ?? 'No description'),
            onTap: () {
              // Return the selected room ID to the previous screen
              Navigator.pop(context, room.id);
            },
          ),
        );
      },
    );
  }
}