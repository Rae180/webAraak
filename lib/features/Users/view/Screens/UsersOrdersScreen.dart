import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Users/Bloc/UsersBloc/users_bloc.dart';
import 'package:start/features/Users/Models/UsersOrdersModel.dart';

class UserOrdersScreen extends StatefulWidget {
  static const String routeName = '/Users_Orders_Screen';
  final int? userId;
  final String? userName;

  const UserOrdersScreen({
    super.key,
    this.userId,
    this.userName,
  });

  @override
  State<UserOrdersScreen> createState() => _UserOrdersScreenState();
}

class _UserOrdersScreenState extends State<UserOrdersScreen> {
  Color get shimmerBaseColor => Theme.of(context).brightness == Brightness.dark
      ? Colors.grey[800]!
      : Colors.grey[300]!;

  Color get shimmerHighlightColor =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[700]!
          : Colors.grey[100]!;

  Color _getStatusColor(String status) {
    switch (status) {
      case 'complete':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider(
      create: (context) => UsersBloc(client: NetworkApiServiceHttp())
        ..add(GetOrdersUsersEvent(id: widget.userId!)),
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
        'طلبات ${widget.userName}',
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
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetOrdersUsersSuccess) {
          return _buildOrdersList(state.orders, textColor);
        }
        if (state is UsersError) {
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

  Widget _buildOrdersList(UserOrders orders, Color textColor) {
    if (orders.orders == null || orders.orders!.isEmpty) {
      return Center(
        child: Text(
          'لا توجد طلبات',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: orders.orders!.length,
      itemBuilder: (context, index) {
        final order = orders.orders![index];
        return _buildOrderTile(order, textColor);
      },
    );
  }

  Widget _buildOrderTile(Orders order, Color textColor) {
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
          backgroundImage: (order.image != null && order.image!.isNotEmpty)
              ? NetworkImage(order.image!)
              : const AssetImage('assets/default_product.png') as ImageProvider,
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          order.name ?? 'No Name',
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
              order.type ?? 'No Type',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontFamily: AppConstants.primaryFont,
              ),
            ),
            Text(
              order.status ?? 'No Status',
              style: TextStyle(
                color: _getStatusColor(order.status ?? ''),
                fontFamily: AppConstants.primaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.circle,
          color: _getStatusColor(order.status ?? ''),
          size: 16,
        ),
      ),
    );
  }
}
