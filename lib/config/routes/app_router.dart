import 'package:flutter/material.dart';
import 'package:start/core/managers/string_manager.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Resources/view/Screens/AddItemScreen.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/EditItemScreen.dart';
import 'package:start/features/Resources/view/Screens/EditRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/UploadGlbScreen.dart';
import 'package:start/features/SubGallery/view/Screens/AaddNewSubManager.dart';
import 'package:start/features/SubGallery/view/Screens/AddNewBranchPaage.dart';
import 'package:start/features/SubGallery/view/Screens/BranchDetailesPage.dart';
import 'package:start/features/SubGallery/view/Screens/SubManagersScreen.dart';
import 'package:start/features/SubGallery/view/Screens/SubMnagerDetilesScreen.dart';
import 'package:start/features/SubGallery/view/Widgets/MapPickerScreen.dart';
import 'package:start/features/Users/view/Screens/UsersOrdersScreen.dart';
import 'package:start/features/home/view/Screens/homepage.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case HomePage.routeName:
        return MaterialPageRoute(builder: (context) => HomePage());
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (context) => LoginPage());
      case AddItemScreen.routeName:
        return MaterialPageRoute(builder: (context) => AddItemScreen());
      case AddRoomScreen.routeName:
        return MaterialPageRoute(builder: (context) => AddRoomScreen());
      case EditRoomScreen.routeName:
        return MaterialPageRoute(builder: (context) => EditRoomScreen());
      case EditItemScreen.routeName:
        return MaterialPageRoute(builder: (context) => EditItemScreen());
      case UploadGlbScreen.routeName:
        return MaterialPageRoute(builder: (context) => UploadGlbScreen());
      case UserOrdersScreen.routeName:
        return MaterialPageRoute(builder: (context) => UserOrdersScreen());
      case BranchDetailsScreen.routeName:
        return MaterialPageRoute(builder: (context) => BranchDetailsScreen());
      case SubManagersScreen.routeName:
        return MaterialPageRoute(builder: (context) => SubManagersScreen());
      case SubManagerDetailsScreen.routeName:
        return MaterialPageRoute(
            builder: (context) => SubManagerDetailsScreen());
      case MapPickerScreen.routeName:
        return MaterialPageRoute(builder: (context) => MapPickerScreen());
      case AddNewBranchPage.routeName:
        return MaterialPageRoute(builder: (context) => AddNewBranchPage());
        case AddNewSubManagerPage.routeName:
        return MaterialPageRoute(builder: (context) => AddNewSubManagerPage());
      default:
        return unDefinedRoute();
    }
  }

  Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRouteFound),
        ),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
