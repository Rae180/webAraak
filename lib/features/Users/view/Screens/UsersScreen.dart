import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Users/Bloc/UsersBloc/users_bloc.dart';
import 'package:start/features/Users/Models/UserModel.dart';
import 'package:start/features/Users/view/Screens/UsersOrdersScreen.dart';

class UsersScreen extends StatefulWidget {
  static const String routeName = '/users';

  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
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
      create: (context) =>
          UsersBloc(client: NetworkApiServiceHttp())..add(GetAllUsersEvent()),
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
        'قائمة المستخدمين',
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
    return BlocConsumer<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is AddAmountSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'تم إضافة الرصيد بنجاح',
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
            ),
          );
        } else if (state is UsersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(fontFamily: AppConstants.primaryFont),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is UsersLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetAllUsersSuccess) {
          return _buildUsersList(state.user, textColor);
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
            height: 70,
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

  Widget _buildUsersList(UserModel users, Color textColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: users.customers?.length ?? 0,
      itemBuilder: (context, index) {
        final user = users.customers![index];
        return _buildUserTile(user, textColor);
      },
    );
  }

  Widget _buildUserTile(Customers user, Color textColor) {
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
          backgroundImage: (user.profileImage != null &&
                  user.profileImage!.isNotEmpty)
              ? NetworkImage(user.profileImage!)
              : const AssetImage('assets/default_user.png') as ImageProvider,
          backgroundColor: Colors.transparent,
        ),
        title: Text(
          user.name ?? 'No Name',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user.email ?? 'No Email',
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontFamily: AppConstants.primaryFont,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.account_balance_wallet,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => _showAddBalanceDialog(context, user),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserOrdersScreen(
                userName: user.name,
                userId: user.id,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddBalanceDialog(BuildContext context, Customers user) {
    final _formKey = GlobalKey<FormState>();
    final _amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'إضافة رصيد للمستخدم',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppConstants.primaryFont,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: 'المبلغ',
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.cardRadius),
                      ),
                      prefixIcon: const Icon(Icons.attach_money),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى إدخال المبلغ';
                      }
                      if (double.tryParse(value) == null) {
                        return 'يرجى إدخال رقم صحيح';
                      }
                      if (double.parse(value) <= 0) {
                        return 'يرجى إدخال مبلغ أكبر من الصفر';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                      ElevatedButton(
                        onPressed: () {
                          print('the user id is :${user.id}');
                          if (_formKey.currentState!.validate()) {
                            context.read<UsersBloc>().add(
                                  AddAmountEvent(
                                    id: user.id!,
                                    amount: _amountController.text,
                                  ),
                                );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'إضافة',
                          style:
                              TextStyle(fontFamily: AppConstants.primaryFont),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
