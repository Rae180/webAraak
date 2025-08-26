import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/SubGallery/Models/SubManaagerDetailes.dart';
import 'package:start/features/SubGallery/Models/SubManagersModel.dart';
import 'package:start/features/SubGallery/view/Screens/EditSubManagerScreen.dart';
import 'package:start/features/SubGallery/view/Screens/SubMnagerDetilesScreen.dart';

class SubManagersScreen extends StatefulWidget {
  static const String routeName = '/sub_managers';

  const SubManagersScreen({super.key});

  @override
  State<SubManagersScreen> createState() => _SubManagersScreenState();
}

class _SubManagersScreenState extends State<SubManagersScreen> {
  Color get shimmerBaseColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]!
      : Colors.grey[300]!;

  Color get shimmerHighlightColor =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider(
      create: (context) => BranchesBloc(client: NetworkApiServiceHttp())
        ..add(GetSubManagersEvent()),
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
        'المدراء المساعدين',
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is BranchesLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetSubManagersSuccess) {
          return _buildManagersList(state.managers, textColor);
        }
        if (state is BranchesError) {
          return _buildErrorWidget(state.message, textColor);
        }
        return const SizedBox();
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
            height: 100,
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
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget _buildManagersList(SubManagersModel managers, Color textColor) {
    if (managers.managers == null || managers.managers!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد مدراء مساعدين حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: managers.managers!.length,
      itemBuilder: (context, index) {
        final manager = managers.managers![index];
        return _buildManagerTile(manager, textColor);
      },
    );
  }

  Widget _buildManagerTile(Managers manager, Color textColor) {
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
          backgroundColor: Colors.transparent,
          backgroundImage: (manager.image != null &&
                  manager.image is String &&
                  manager.image!.isNotEmpty)
              ? NetworkImage(manager.image!)
              : const AssetImage('assets/default_user.png') as ImageProvider,
          child: (manager.image == null || manager.image!.isEmpty)
              ? Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                )
              : null,
        ),
        title: Text(
          manager.name ?? 'No Name',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (manager.email != null)
              Text(
                manager.email!,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            if (manager.phone != null)
              Text(
                manager.phone!,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Icon Button
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        EditSubManagerScreen(manager: manager)));
              },
            ),
            // Delete Icon Button
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                // Handle delete action
                _showDeleteConfirmationDialog(context, manager);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SubManagerDetailsScreen(
                    managerId: manager.id,
                  )));
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Managers manager) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'حذف المدير',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف ${manager.name}؟',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<BranchesBloc>(context)
                    .add(DeleteSubManagerEvent(subid: manager.id!));
                Navigator.of(context).pop();
              },
              child: Text(
                'حذف',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
