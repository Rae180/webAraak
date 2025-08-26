import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/SubGallery/Models/Branches.dart';
import 'package:start/features/SubGallery/view/Screens/AaddNewSubManager.dart';
import 'package:start/features/SubGallery/view/Screens/AddNewBranchPaage.dart';
import 'package:start/features/SubGallery/view/Screens/BranchDetailesPage.dart';
import 'package:start/features/SubGallery/view/Screens/SubManagersScreen.dart';

class SubGalleriesScreen extends StatefulWidget {
  static const String routeName = '/sub_galleries';

  const SubGalleriesScreen({super.key});

  @override
  State<SubGalleriesScreen> createState() => _SubGalleriesScreenState();
}

class _SubGalleriesScreenState extends State<SubGalleriesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color get shimmerBaseColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]!
      : Colors.grey[300]!;

  Color get shimmerHighlightColor =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!;

  void _showAddOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إضافة جديد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.primaryFont,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionButton(
                  context,
                  icon: Icons.business,
                  label: 'إضافة فرع جديد',
                  onTap: () {
                    Navigator.of(context).pushNamed(AddNewBranchPage.routeName);
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionButton(
                  context,
                  icon: Icons.person_add,
                  label: 'إضافة مدير جديد',
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(AddNewSubManagerPage.routeName);
                  },
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  context,
                  icon: Icons.business,
                  label: 'assign manager to subGallery',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
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

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppConstants.primaryFont,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Branches branch) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        // Get the bloc from the dialog context which is below the BlocProvider
        final BranchesBloc branchesBloc =
            BlocProvider.of<BranchesBloc>(dialogContext);

        return AlertDialog(
          title: Text(
            'حذف الفرع',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا الفرع؟',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                branchesBloc.add(DeleteBranchEvent(branchId: branch.id!));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'حذف',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider(
      create: (context) => BranchesBloc(client: NetworkApiServiceHttp())
        ..add(GetAllBranchesEvent()),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: _buildBody(context, textColor),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddOptionsDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(SubManagersScreen.routeName);
          },
          icon: Icon(
            Icons.person_2_outlined,
            color: textColor,
          ),
        )
      ],
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return BlocConsumer<BranchesBloc, BranchesState>(
      listener: (context, state) {
        if (state is DeleteBranchSuccess) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم حذف الفرع بنجاح',
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
            ),
          );

          // Reload the branches list
          BlocProvider.of<BranchesBloc>(context).add(GetAllBranchesEvent());
        }
      },
      builder: (context, state) {
        if (state is BranchesLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetBranchesSucess) {
          return _buildBranchesList(state.branches, textColor);
        }
        if (state is BranchesError) {
          return _buildErrorWidget(state.message, textColor);
        }
        if (state is DeleteBranchSuccess) {
          // Show loading while fetching updated list
          return _buildShimmerLoader();
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

  Widget _buildBranchesList(BranchesModel branches, Color textColor) {
    if (branches.branches == null || branches.branches!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد أفرع حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: branches.branches!.length,
      itemBuilder: (context, index) {
        final branch = branches.branches![index];
        return _buildBranchTile(branch, textColor);
      },
    );
  }

  Widget _buildBranchTile(Branches branch, Color textColor) {
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
          child: Icon(
            Icons.business,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          branch.address ?? 'No Address',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (branch.latitude != null && branch.longitude != null)
              Text(
                'Lat: ${branch.latitude}, Long: ${branch.longitude}',
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            if (branch.subManagerId != null)
              Text(
                'Manager ID: ${branch.subManagerId}',
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
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => _showDeleteConfirmationDialog(context, branch),
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BranchDetailsScreen(
                    branchId: branch.id!,
                  )));
        },
      ),
    );
  }
}
