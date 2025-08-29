import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/ItemTypesModel.dart';

class PickItemTypeScreen extends StatefulWidget {
  static const String routeName = '/pick_item_type';

  const PickItemTypeScreen({super.key});

  @override
  State<PickItemTypeScreen> createState() => _PickItemTypeScreenState();
}

class _PickItemTypeScreenState extends State<PickItemTypeScreen> {
  late ResourcesBloc _resourcesBloc;
  bool _typesLoaded = false;

  Color get shimmerBaseColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]!
      : Colors.grey[300]!;

  Color get shimmerHighlightColor =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!;

  @override
  void initState() {
    super.initState();
    _resourcesBloc = context.read<ResourcesBloc>();
    // Load item types when the screen is initialized
    _resourcesBloc.add(GetItemTypesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'Select Item Type',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ResourcesBloc, ResourcesState>(
        listener: (context, state) {
          if (state is GetItemTypesSuccess) {
            setState(() {
              _typesLoaded = true;
            });
          }
        },
        builder: (context, state) {
          if (state is ResourcesLoading && !_typesLoaded) {
            return _buildShimmerLoader();
          }
          if (state is GetItemTypesSuccess) {
            return _buildTypesListView(state.items, textColor);
          }
          if (state is ResourcesError) {
            return _buildErrorWidget(state.message, textColor);
          }
          return _buildShimmerLoader();
        },
      ),
    );
  }

  Widget _buildTypesListView(ItemTypesModel? types, Color textColor) {
    if (types?.itemTypes == null || types!.itemTypes!.isEmpty) {
      return Center(
        child: Text(
          'No item types available',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: types.itemTypes!.length,
      itemBuilder: (context, index) {
        final type = types.itemTypes![index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppConstants.elementSpacing),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Icon(
                Icons.category,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              type.name ?? 'No Name',
              style: TextStyle(
                color: textColor,
                fontFamily: AppConstants.primaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              type.description ?? 'No Description',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontFamily: AppConstants.primaryFont,
              ),
            ),
            onTap: () {
              // Return the selected item type ID to the previous screen
              Navigator.pop(context, type.id);
            },
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            height: 80,
            margin: const EdgeInsets.only(bottom: AppConstants.elementSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(String message, Color textColor) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
        ),
      ),
    );
  }
}