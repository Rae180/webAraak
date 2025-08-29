import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/AllItemsModel.dart';
import 'package:start/features/Resources/Models/AllRoomsModel.dart';
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
import 'package:start/features/Resources/view/Screens/UploadGlbScreen.dart';

class ResourcesScreen extends StatefulWidget {
  static const String routeName = '/resources';

  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ResourcesBloc _resourcesBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _itemsLoaded = false;
  bool _roomsLoaded = false;

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
    _resourcesBloc = ResourcesBloc(client: NetworkApiServiceHttp());
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    if (_tabController.index == 0 && !_itemsLoaded) {
      _resourcesBloc.add(GetAllItemsEvent());
    } else if (_tabController.index == 1 && !_roomsLoaded) {
      _resourcesBloc.add(GetAllRoomsEvent());
    }
  }

  void _handleRefresh() {
    if (_tabController.index == 0) {
      _resourcesBloc.add(GetAllItemsEvent());
      setState(() {
        _itemsLoaded = false;
      });
    } else if (_tabController.index == 1) {
      _resourcesBloc.add(GetAllRoomsEvent());
      setState(() {
        _roomsLoaded = false;
      });
    }
  }

  void _showAddCategoryDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<ResourcesBloc, ResourcesState>(
          listener: (context, state) {
            if (state is AddNewCategorySuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تمت إضافة التصنيف بنجاح',
                    style: TextStyle(fontFamily: AppConstants.primaryFont),
                  ),
                ),
              );
            }
            if (state is ResourcesError) {
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
          child: Dialog(
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
                      'إضافة تصنيف جديد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.primaryFont,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم التصنيف',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.cardRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم التصنيف';
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
                            if (_formKey.currentState!.validate()) {
                              _resourcesBloc.add(
                                AddNewCategoryEvent(
                                  name: _nameController.text,
                                ),
                              );
                            }
                          },
                          child: Text(
                            'حفظ',
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
          ),
        );
      },
    );
  }

  void _showAddItemTypeDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<ResourcesBloc, ResourcesState>(
          listener: (context, state) {
            if (state is AddItemTypeSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم إضافة نوع العنصر بنجاح',
                    style: TextStyle(fontFamily: AppConstants.primaryFont),
                  ),
                ),
              );
            }
            if (state is ResourcesError) {
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
          child: Dialog(
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
                      'إضافة نوع عنصر جديد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.primaryFont,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'اسم النوع',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.cardRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم النوع';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'الوصف',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.cardRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال وصف النوع';
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
                            if (_formKey.currentState!.validate()) {
                              _resourcesBloc.add(
                                AddItemTypeEvent(
                                  name: _nameController.text,
                                  description: _descriptionController.text,
                                ),
                              );
                            }
                          },
                          child: Text(
                            'حفظ',
                            style: TextStyle(
                              fontFamily: AppConstants.primaryFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'إضافة جديد',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.primaryFont,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 20),
                _buildOptionButton(
                  dialogContext,
                  icon: Icons.chair,
                  label: 'إضافة عنصر جديد',
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _resourcesBloc,
                          child: const AddItemScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionButton(
                  dialogContext,
                  icon: Icons.room,
                  label: 'إضافة غرفة جديدة',
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _resourcesBloc,
                          child: const AddRoomScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildOptionButton(
                  dialogContext,
                  icon: Icons.model_training,
                  label: 'رفع نموذج 3D',
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _resourcesBloc,
                          child: const UploadGlbScreen(),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: AppConstants.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontFamily: AppConstants.primaryFont,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider.value(
      value: _resourcesBloc,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: _buildBody(context, textColor),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddOptionsDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'العناصر'),
          Tab(text: 'الغرف'),
        ],
        indicatorColor: Theme.of(context).primaryColor,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.category_outlined),
          tooltip: 'أنواع العناصر',
          onPressed: () {
            Navigator.of(context).pushNamed(ItemTypesScreen.routeName);
            // or:
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) => const ItemTypesScreen()),
            // );
          },
        ),
        IconButton(
          icon: const Icon(Icons.list_alt_outlined),
          tooltip: 'التصنيفات',
          onPressed: () {
            Navigator.of(context).pushNamed(CategoriesScreen.routeName);
            // or:
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (_) => const CategoriesScreen()),
            // );
          },
        ),
        IconButton(
          icon: const Icon(Icons.forest_outlined),
          tooltip: 'All Wood',
          onPressed: () {
            Navigator.of(context).pushNamed(AllWoodScreen.routeName);
          },
        ),
        IconButton(
          icon: const Icon(Icons.line_style_outlined),
          tooltip: 'All Fabric',
          onPressed: () {
            Navigator.of(context).pushNamed(AllFabricScreen.routeName);
          },
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _handleRefresh,
          tooltip: 'تحديث',
        ),
      ],
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildItemsList(context, textColor),
        _buildRoomsList(context, textColor),
      ],
    );
  }

  Widget _buildItemsList(BuildContext context, Color textColor) {
    return BlocConsumer<ResourcesBloc, ResourcesState>(
      listener: (context, state) {
        if (state is GetAllItemsSuccess) {
          _itemsLoaded = true;
        }
      },
      builder: (context, state) {
        if (state is ResourcesLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetAllItemsSuccess) {
          print('the item is : ${state.allItemsModel}');

          return _buildItemsListView(state.allItemsModel, textColor);
        }
        if (state is ResourcesError) {
          return _buildErrorWidget(state.message, textColor);
        }
        // Initial state - load items
        if (!_itemsLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _resourcesBloc.add(GetAllItemsEvent());
          });
        }
        return _buildShimmerLoader();
      },
    );
  }

  Widget _buildItemsListView(AllItemsModel items, Color textColor) {
    if (items.items == null || items.items!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد عناصر حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: items.items!.length,
      itemBuilder: (context, index) {
        final item = items.items![index];
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
              backgroundColor: Colors.transparent,
              backgroundImage:
                  item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? NetworkImage(item.imageUrl!)
                      : null,
              child: item.imageUrl == null || item.imageUrl!.isEmpty
                  ? Icon(
                      Icons.chair,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            title: Text(
              item.name ?? 'No Name',
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
                  item.description ?? 'No Description',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontFamily: AppConstants.primaryFont,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.price ?? 'N/A'}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontFamily: AppConstants.primaryFont,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${item.time ?? 'N/A'} دقيقة',
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    if (item != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: _resourcesBloc,
                            child: EditItemScreen(item: item),
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Cannot edit a null item')),
                      );
                    }
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () =>
                      _showDeleteItemConfirmationDialog(context, item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoomsList(BuildContext context, Color textColor) {
    return BlocConsumer<ResourcesBloc, ResourcesState>(
      listener: (context, state) {
        if (state is GetAllRoomsSuccess) {
          _roomsLoaded = true;
        }
      },
      builder: (context, state) {
        if (state is ResourcesLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetAllRoomsSuccess) {
          return _buildRoomsListView(state.allRoomsModel, textColor);
        }
        if (state is ResourcesError) {
          return _buildErrorWidget(state.message, textColor);
        }
        // Initial state - load rooms
        if (!_roomsLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _resourcesBloc.add(GetAllRoomsEvent());
          });
        }
        return _buildShimmerLoader();
      },
    );
  }

  Widget _buildRoomsListView(AllRoomsModel rooms, Color textColor) {
    if (rooms.rooms == null || rooms.rooms!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد غرف حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: rooms.rooms!.length,
      itemBuilder: (context, index) {
        final room = rooms.rooms![index];
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
              backgroundColor: Colors.transparent,
              backgroundImage:
                  room.imageUrl != null && room.imageUrl!.isNotEmpty
                      ? NetworkImage(room.imageUrl!)
                      : null,
              child: room.imageUrl == null || room.imageUrl!.isEmpty
                  ? Icon(
                      Icons.room,
                      color: Theme.of(context).primaryColor,
                    )
                  : null,
            ),
            title: Text(
              room.name ?? 'No Name',
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
                  room.description ?? 'No Description',
                  style: TextStyle(
                    color: textColor.withOpacity(0.7),
                    fontFamily: AppConstants.primaryFont,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.attach_money,
                      size: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${room.price ?? 'N/A'}',
                      style: TextStyle(
                        color: textColor.withOpacity(0.7),
                        fontFamily: AppConstants.primaryFont,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: textColor.withOpacity(0.7),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${room.time ?? 'N/A'} دقيقة',
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: _resourcesBloc,
                          child: EditRoomScreen(room: room),
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  onPressed: () =>
                      _showDeleteRoomConfirmationDialog(context, room),
                ),
              ],
            ),
          ),
        );
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

  void _showDeleteItemConfirmationDialog(BuildContext context, Items item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'حذف العنصر',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا العنصر؟',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          actions: [
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
                Navigator.of(dialogContext).pop();
                _resourcesBloc.add(DeleteItemEvent(id: item.id!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'سيتم حذف العنصر قريباً',
                      style: TextStyle(fontFamily: AppConstants.primaryFont),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'حذف',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteRoomConfirmationDialog(BuildContext context, Rooms room) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'حذف الغرفة',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذه الغرفة؟',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          actions: [
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
                Navigator.of(dialogContext).pop();
                _resourcesBloc.add(DeleteRoomEvent(id: room.id!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'سيتم حذف الغرفة قريباً',
                      style: TextStyle(fontFamily: AppConstants.primaryFont),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: Text(
                'حذف',
                style: TextStyle(
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _resourcesBloc.close();
    super.dispose();
  }
}
