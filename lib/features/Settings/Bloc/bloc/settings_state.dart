part of 'settings_bloc.dart';

class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class GetAllOrdersSuccess extends SettingsState {
  final AllOrdersModel orders;

  GetAllOrdersSuccess({required this.orders});
}

final class GetManagerInfoSuccess extends SettingsState {
  final ManagerInfo info;

  GetManagerInfoSuccess({required this.info});
}

final class SettingsError extends SettingsState {
  final String message;

  SettingsError({required this.message});
}
