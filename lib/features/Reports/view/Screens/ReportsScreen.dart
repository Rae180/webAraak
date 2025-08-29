import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Reports/Bloc/bloc/complaints_bloc.dart';
import 'package:start/features/Reports/Models/ComplaintsModel.dart';

class ReportsScreen extends StatefulWidget {
  static const String routeName = '/reports';

  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  late ComplaintsBloc _complaintsBloc;
  bool _complaintsLoaded = false;

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
    _complaintsBloc = ComplaintsBloc(client: NetworkApiServiceHttp());
  }

  void _handleRefresh() {
    _complaintsBloc.add(GetComplaintsEvent());
    setState(() {
      _complaintsLoaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider.value(
      value: _complaintsBloc,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: _buildComplaintsList(context, textColor),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text(
        'التقارير والشكاوى',
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _handleRefresh,
          tooltip: 'تحديث',
        ),
      ],
    );
  }

  Widget _buildComplaintsList(BuildContext context, Color textColor) {
    return BlocConsumer<ComplaintsBloc, ComplaintsState>(
      listener: (context, state) {
        if (state is ComplaaintsSuccess) {
          _complaintsLoaded = true;
        }
      },
      builder: (context, state) {
        if (state is ComplaintsLoading) {
          return _buildShimmerLoader();
        }
        if (state is ComplaaintsSuccess) {
          return _buildComplaintsListView(state.complaints, textColor);
        }
        if (state is ComplaintsError) {
          return _buildErrorWidget(state.message, textColor);
        }
        // Initial state - load complaints
        if (!_complaintsLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _complaintsBloc.add(GetComplaintsEvent());
          });
        }
        return _buildShimmerLoader();
      },
    );
  }

  Widget _buildComplaintsListView(ComplaintsModel complaints, Color textColor) {
    if (complaints.complaints == null || complaints.complaints!.isEmpty) {
      return Center(
        child: Text(
          'لا توجد شكاوى حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: complaints.complaints!.length,
      itemBuilder: (context, index) {
        final complaint = complaints.complaints![index];
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
                Icons.report_problem,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              complaint.customerName ?? 'عميل غير معروف',
              style: TextStyle(
                color: textColor,
                fontFamily: AppConstants.primaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  complaint.message ?? 'لا توجد تفاصيل',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontFamily: AppConstants.primaryFont,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildStatusChip(complaint.status ?? 'pending'),
                    const Spacer(),
                    Text(
                      complaint.date ?? '',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontFamily: AppConstants.primaryFont,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 'pending':
        chipColor = Colors.orange;
        statusText = 'قيد الانتظار';
        break;
      case 'in_progress':
        chipColor = Colors.blue;
        statusText = 'قيد المعالجة';
        break;
      case 'resolved':
        chipColor = Colors.green;
        statusText = 'تم الحل';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'غير معروف';
    }

    return Chip(
      label: Text(
        statusText,
        style: TextStyle(
          color: Colors.white,
          fontFamily: AppConstants.primaryFont,
          fontSize: 12,
        ),
      ),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: textColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleRefresh,
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _complaintsBloc.close();
    super.dispose();
  }
}