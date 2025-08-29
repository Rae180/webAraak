import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/ItemTypesModel.dart';

class ItemTypesScreen extends StatefulWidget {
  static const String routeName = '/item-types';

  const ItemTypesScreen({super.key});

  @override
  State<ItemTypesScreen> createState() => _ItemTypesScreenState();
}

class _ItemTypesScreenState extends State<ItemTypesScreen> {
  late ResourcesBloc _resourcesBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _typesLoaded = false;

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
    _resourcesBloc = context.read<ResourcesBloc>();
  }

  void _handleRefresh() {
    _resourcesBloc.add(GetItemTypesEvent());
    setState(() {
      _typesLoaded = false;
    });
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
              _handleRefresh(); // Refresh the list
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

  void _showDeleteTypeConfirmationDialog(BuildContext context, ItemTypes type) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'حذف نوع العنصر',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا النوع؟',
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
                _resourcesBloc.add(DeleteItemTypeEvent(id: type.id!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'سيتم حذف النوع قريباً',
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          'أنواع العناصر',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleRefresh,
            tooltip: 'تحديث',
          ),
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<ResourcesBloc, ResourcesState>(
        listener: (context, state) {
          if (state is GetItemTypesSuccess) {
            setState(() {
              _typesLoaded = true;
            });
          }
        },
        builder: (context, state) {
          if (state is ResourcesLoading && !_typesLoaded) {
            return _buildShimmerLoader();
          }
          if (state is GetItemTypesSuccess) {
            return _buildTypesListView(state.items, textColor);
          }
          if (state is ResourcesError) {
            return _buildErrorWidget(state.message, textColor);
          }
          // Initial state - load types
          if (!_typesLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _resourcesBloc.add(GetItemTypesEvent());
            });
          }
          return _buildShimmerLoader();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemTypeDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTypesListView(ItemTypesModel? types, Color textColor) {
    if (types?.itemTypes == null || types!.itemTypes!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد أنواع عناصر حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: types.itemTypes!.length,
      itemBuilder: (context, index) {
        final type = types.itemTypes![index];
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
                Icons.category,
                color: Theme.of(context).primaryColor,
              ),
            ),
            title: Text(
              type.name ?? 'No Name',
              style: TextStyle(
                color: textColor,
                fontFamily: AppConstants.primaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              type.description ?? 'No Description',
              style: TextStyle(
                color: textColor.withOpacity(0.7),
                fontFamily: AppConstants.primaryFont,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () => _showDeleteTypeConfirmationDialog(context, type),
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
            height: 80,
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
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
        ),
      ),
    );
  }
}
