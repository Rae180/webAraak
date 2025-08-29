import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Auth/Bloc/AuthBloc/auth_bloc.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Settings/Bloc/bloc/settings_bloc.dart';
import 'package:start/features/Settings/Models/ManagerInfo.dart';
import 'package:start/features/Settings/View/Screens/AllOrdersScreen.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/settings';

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkTheme = false;
  bool _isArabic = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc(client: NetworkApiServiceHttp())
            ..add(GetManagerInfoEvent()),
        ),
        BlocProvider(
          create: (context) => AuthBloc(client: NetworkApiServiceHttp()),
        ),
      ],
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetManagerInfoSuccess) {
              return _buildBody(context, textColor, state.info);
            } else if (state is SettingsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    ElevatedButton(
                      onPressed: () => context
                          .read<SettingsBloc>()
                          .add(GetManagerInfoEvent()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text(
        'الإعدادات',
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
    );
  }

  Widget _buildBody(BuildContext context, Color textColor, ManagerInfo info) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          // Navigate to login screen after successful logout
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        } else if (state is AuthError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(AppConstants.sectionPadding),
        children: [
          _buildUserInfoSection(context, textColor, info),
          const SizedBox(height: AppConstants.sectionPadding),
          _buildSettingsSection(context, textColor),
          const SizedBox(height: AppConstants.sectionPadding),
          _buildActionsSection(context, textColor),
        ],
      ),
    );
  }

  Widget _buildUserInfoSection(
      BuildContext context, Color textColor, ManagerInfo info) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardRadius),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات المستخدم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          const SizedBox(height: 16),
          _buildUserInfoRow(
              Icons.person, 'الاسم', info.fullName ?? 'N/A', textColor),
          const SizedBox(height: 12),
          _buildUserInfoRow(
              Icons.phone, 'الهاتف', info.phone ?? 'N/A', textColor),
          const SizedBox(height: 12),
          _buildUserInfoRow(
              Icons.email, 'البريد الإلكتروني', info.email ?? 'N/A', textColor),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(
      IconData icon, String label, String value, Color textColor) {
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
                  fontSize: 14,
                  color: textColor.withOpacity(0.7),
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardRadius),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الإعدادات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingSwitch(
            context,
            icon: Icons.nightlight_round,
            label: 'الوضع الليلي',
            value: _isDarkTheme,
            onChanged: (value) {
              setState(() {
                _isDarkTheme = value;
              });
              // Here you would dispatch an event to change the theme
            },
          ),
          const SizedBox(height: 12),
          _buildSettingSwitch(
            context,
            icon: Icons.language,
            label: 'اللغة العربية',
            value: _isArabic,
            onChanged: (value) {
              setState(() {
                _isArabic = value;
              });
              // Here you would dispatch an event to change the language
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  Widget _buildActionsSection(BuildContext context, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.cardRadius),
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
      child: Column(
        children: [
          _buildActionButton(
            context,
            icon: Icons.shopping_bag,
            label: 'جميع الطلبات',
            onPressed: () {
              Navigator.of(context).pushNamed(AllOrdersScreen.routeName);
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            context,
            icon: Icons.logout,
            label: 'تسجيل الخروج',
            isLogout: true,
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    bool isLogout = false,
    required VoidCallback onPressed,
  }) {
    final textColor = Theme.of(context).colorScheme.onBackground;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isLogout
              ? Theme.of(context).colorScheme.error.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(
            color: isLogout
                ? Theme.of(context).colorScheme.error.withOpacity(0.3)
                : Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppConstants.primaryFont,
                color:
                    isLogout ? Theme.of(context).colorScheme.error : textColor,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: textColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return AlertDialog(
              title: Text(
                'تأكيد تسجيل الخروج',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
              content: state is AuthLoading
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('جاري تسجيل الخروج...'),
                      ],
                    )
                  : Text(
                      'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
                      style: TextStyle(
                        fontFamily: AppConstants.primaryFont,
                      ),
                    ),
              actions: state is AuthLoading
                  ? []
                  : [
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
                          // Dispatch logout event
                          context.read<AuthBloc>().add(LogoutEvent());
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            fontFamily: AppConstants.primaryFont,
                          ),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }
}
