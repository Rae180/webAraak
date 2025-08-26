class ApiConstants {
  static const String baseURLVPN = 'https://9d2a-190-2-152-251.ngrok-free.app';
  static const String baseUrl = 'http://10.65.8.140:8000/api/';
  static const String STORAGE_URL = "http://10.65.8.140:8000";
  static const String register = '${baseUrl}signup';
  static const String login = '${baseUrl}login';
  static const String uploadGlb = '${baseUrl}uploadGlb/';
  static const String getusers = '${baseUrl}getCustomerList';
  static const String ordersuser = '${baseUrl}getCustomersWithOrders/';
  static const String branches = '${baseUrl}branches';
  static const String branchDet = '${baseUrl}branch_info/';
  static const String submangers = '${baseUrl}get_branch_managers';
  static const String submangerDet = '${baseUrl}get_branchmanager_info/';
  static const String addnewbranch = '${baseUrl}add_branch';
  static const String deletebranch = '${baseUrl}deleteBranch/';
  static const String addsubmanager = '${baseUrl}add_branch_manager';
  static const String deletesub = '${baseUrl}delete_branchmanager/';
  static const String editsub = '${baseUrl}edit_branchManager_info/';
  static const String allrooms = '${baseUrl}getAllRooms';
  static const String allitems = '${baseUrl}getAllItems';
  static const String edititem = '${baseUrl}updateItem/';
}
