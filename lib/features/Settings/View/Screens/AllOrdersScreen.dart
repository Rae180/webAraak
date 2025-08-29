import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Settings/Bloc/bloc/settings_bloc.dart';
import 'package:start/features/Settings/Models/AllOrdersModel.dart';

class AllOrdersScreen extends StatefulWidget {
  static const String routeName = '/all-orders';

  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  late SettingsBloc _ordersBloc;
  bool _ordersLoaded = false;

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
    _ordersBloc = SettingsBloc(
        client: NetworkApiServiceHttp()); // Initialize your orders BLoC
  }

  void _handleRefresh() {
    _ordersBloc.add(GetAllOrdersEvent());
    setState(() {
      _ordersLoaded = false;
    });
  }

  String _formatStatus(String? status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغي';
      default:
        return status ?? 'غير معروف';
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatPaymentStatus(String? isPaid) {
    switch (isPaid) {
      case 'paid':
        return 'مدفوع';
      case 'unpaid':
        return 'غير مدفوع';
      case 'partial':
        return 'مدفوع جزئياً';
      default:
        return isPaid ?? 'غير معروف';
    }
  }

  Color _getPaymentStatusColor(String? isPaid) {
    switch (isPaid) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      case 'partial':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider.value(
      value: _ordersBloc,
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
        'جميع الطلبات',
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: textColor,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _handleRefresh,
          tooltip: 'تحديث',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is GetAllOrdersSuccess) {
          _ordersLoaded = true;
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetAllOrdersSuccess) {
          return _buildOrdersListView(state.orders, textColor);
        }
        if (state is SettingsError) {
          return _buildErrorWidget(state.message, textColor);
        }
        // Initial state - load orders
        if (!_ordersLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _ordersBloc.add(GetAllOrdersEvent());
          });
        }
        return _buildShimmerLoader();
      },
    );
  }

  Widget _buildOrdersListView(AllOrdersModel orders, Color textColor) {
    if (orders.orders == null || orders.orders!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد طلبات حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _handleRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.sectionPadding),
        itemCount: orders.orders!.length,
        itemBuilder: (context, index) {
          final order = orders.orders![index];
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
              contentPadding: const EdgeInsets.all(16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'طلب #${order.id ?? 'N/A'}',
                        style: TextStyle(
                          color: textColor,
                          fontFamily: AppConstants.primaryFont,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(order.status).withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppConstants.cardRadius),
                          border: Border.all(
                            color: _getStatusColor(order.status),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _formatStatus(order.status),
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontFamily: AppConstants.primaryFont,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildOrderDetailRow(
                    Icons.access_time,
                    'الوقت المتبقي:',
                    '${order.remainingTime ?? 'N/A'} دقيقة',
                    textColor,
                  ),
                  const SizedBox(height: 4),
                  _buildOrderDetailRow(
                    Icons.attach_money,
                    'المبلغ المتبقي:',
                    '${order.remainingBill ?? 'N/A'} ر.س',
                    textColor,
                  ),
                  const SizedBox(height: 4),
                  _buildOrderDetailRow(
                    Icons.payment,
                    'حالة الدفع:',
                    _formatPaymentStatus(order.isPaid),
                    textColor,
                    valueColor: _getPaymentStatusColor(order.isPaid),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: textColor.withOpacity(0.5),
              ),
              onTap: () {
                // Navigate to order details screen
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => OrderDetailsScreen(order: order),
                //   ),
                // );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderDetailRow(
      IconData icon, String label, String value, Color textColor,
      {Color? valueColor}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: textColor.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontFamily: AppConstants.primaryFont,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? textColor,
            fontFamily: AppConstants.primaryFont,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
            height: 120,
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
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
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
    _ordersBloc.close();
    super.dispose();
  }
}
