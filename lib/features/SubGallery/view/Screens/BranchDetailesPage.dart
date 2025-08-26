import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/SubGallery/Models/BranchDetailes.dart';

class BranchDetailsScreen extends StatefulWidget {
  static const String routeName = '/branch_details';
  final int? branchId;

  const BranchDetailsScreen({super.key, this.branchId});

  @override
  State<BranchDetailsScreen> createState() => _BranchDetailsScreenState();
}

class _BranchDetailsScreenState extends State<BranchDetailsScreen> {
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
        ..add(GetBranchDetailesEvent(id: widget.branchId)),
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
        'تفاصيل الفرع',
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
    return BlocBuilder<BranchesBloc, BranchesState>(
      builder: (context, state) {
        if (state is BranchesLoading) {
          return _buildShimmerLoader();
        }
        if (state is BranchDetailesSuccess) {
          return _buildBranchDetails(state.detailes, textColor);
        }
        if (state is BranchesError) {
          return _buildErrorWidget(state.message, textColor);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildShimmerLoader() {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      children: [
        Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            height: 200,
            margin: const EdgeInsets.only(bottom: AppConstants.elementSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: AppConstants.elementSpacing),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
            ),
          ),
        ),
      ],
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

  Widget _buildBranchDetails(BrancheDetiles details, Color textColor) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      children: [
        // Branch Information Card
        Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات الفرع',
                  style: TextStyle(
                    color: textColor,
                    fontFamily: AppConstants.primaryFont,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailRow(
                  icon: Icons.location_on,
                  label: 'العنوان',
                  value: details.address ?? 'غير متوفر',
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.map,
                  label: 'الإحداثيات',
                  value: '${details.latitude}, ${details.longitude}',
                  textColor: textColor,
                ),
              ],
            ),
          ),
        ),

        // Manager Information Card (if available)
        if (details.manager != null)
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المدير المسؤول',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: AppConstants.primaryFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    icon: Icons.person,
                    label: 'الاسم',
                    value: details.manager!.name ?? 'غير متوفر',
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.email,
                    label: 'البريد الإلكتروني',
                    value: details.manager!.email ?? 'غير متوفر',
                    textColor: textColor,
                  ),
                  const SizedBox(height: 12),
                  _buildDetailRow(
                    icon: Icons.phone,
                    label: 'رقم الهاتف',
                    value: details.manager!.phone ?? 'غير متوفر',
                    textColor: textColor,
                  ),
                ],
              ),
            ),
          ),

        // Show message if no manager is assigned
        if (details.manager == null)
          Container(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'لا يوجد مدير مسؤول عن هذا الفرع',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontFamily: AppConstants.primaryFont,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: textColor.withOpacity(0.7),
                  fontFamily: AppConstants.primaryFont,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontFamily: AppConstants.primaryFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
