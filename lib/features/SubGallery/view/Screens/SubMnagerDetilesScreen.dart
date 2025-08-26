import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/SubGallery/Models/SubManaagerDetailes.dart';

class SubManagerDetailsScreen extends StatefulWidget {
  static const String routeName = '/sub_manager_details';
  final int? managerId;

  const SubManagerDetailsScreen({super.key, this.managerId});

  @override
  State<SubManagerDetailsScreen> createState() =>
      _SubManagerDetailsScreenState();
}

class _SubManagerDetailsScreenState extends State<SubManagerDetailsScreen> {
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
        ..add(GetSubManagerDetailesEvent(id: widget.managerId)),
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
        'تفاصيل المدير',
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
        if (state is GetSubManagerDetailesSuccess) {
          return _buildManagerDetails(state.detailes, textColor);
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
        Center(
          child: Shimmer.fromColors(
            baseColor: shimmerBaseColor,
            highlightColor: shimmerHighlightColor,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Shimmer.fromColors(
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            height: 50,
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
            height: 50,
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
            height: 50,
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

  Widget _buildManagerDetails(SubManagerDetailes details, Color textColor) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      children: [
        // Profile Image
        Center(
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.transparent,
            backgroundImage: (details.image != null &&
                    details.image!.isNotEmpty)
                ? NetworkImage(details.image!)
                : const AssetImage('assets/default_user.png') as ImageProvider,
            child: (details.image == null || details.image!.isEmpty)
                ? Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 24),

        // Manager Information Card
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
                  'معلومات المدير',
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
                  value: details.name ?? 'غير متوفر',
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.email,
                  label: 'البريد الإلكتروني',
                  value: details.email ?? 'غير متوفر',
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.phone,
                  label: 'رقم الهاتف',
                  value: details.phone ?? 'غير متوفر',
                  textColor: textColor,
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  icon: Icons.confirmation_number,
                  label: 'المعرف',
                  value: details.id?.toString() ?? 'غير متوفر',
                  textColor: textColor,
                ),
              ],
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
