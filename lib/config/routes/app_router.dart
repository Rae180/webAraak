import 'package:flutter/material.dart';
import 'package:start/core/managers/string_manager.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Resources/view/Screens/AddItemScreen.dart';
import 'package:start/features/Resources/view/Screens/AddNewFabricScreen.dart';
import 'package:start/features/Resources/view/Screens/AddNewWoodScreen.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/AllFabricScreen.dart';
import 'package:start/features/Resources/view/Screens/AllWoodScreen.dart';
import 'package:start/features/Resources/view/Screens/CategoriesScreen.dart';
import 'package:start/features/Resources/view/Screens/EditItemScreen.dart';
import 'package:start/features/Resources/view/Screens/EditRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/ItemTypesScreen.dart';
import 'package:start/features/Resources/view/Screens/PickItemTypeScreen.dart';
import 'package:start/features/Resources/view/Screens/PickRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/UploadGlbScreen.dart';
import 'package:start/features/Settings/View/Screens/AllOrdersScreen.dart';
import 'package:start/features/Settings/View/Screens/SettingsScreen.dart';
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
      case ItemTypesScreen.routeName:
        return MaterialPageRoute(builder: (context) => ItemTypesScreen());
      case PickRoomScreen.routeName:
        return MaterialPageRoute(builder: (context) => PickRoomScreen());
      case PickItemTypeScreen.routeName:
        return MaterialPageRoute(builder: (context) => PickItemTypeScreen());
      case CategoriesScreen.routeName:
        return MaterialPageRoute(builder: (context) => CategoriesScreen());
      case AddNewWoodScreen.routeName:
        return MaterialPageRoute(builder: (context) => AddNewWoodScreen());
      case AddNewFabricScreen.routeName:
        return MaterialPageRoute(builder: (context) => AddNewFabricScreen());
      case SettingsScreen.routeName:
        return MaterialPageRoute(builder: (context) => SettingsScreen());
      case AllOrdersScreen.routeName:
        return MaterialPageRoute(builder: (context) => AllOrdersScreen());
      case AllWoodScreen.routeName:
        return MaterialPageRoute(builder: (context) => AllWoodScreen());
        case AllFabricScreen.routeName:
        return MaterialPageRoute(builder: (context) => AllFabricScreen());
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
