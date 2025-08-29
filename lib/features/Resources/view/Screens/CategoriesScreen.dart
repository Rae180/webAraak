import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';
import 'package:start/features/Resources/Models/CategoryModel.dart';

class CategoriesScreen extends StatefulWidget {
  static const String routeName = '/categories';

  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late ResourcesBloc _resourcesBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _categoriesLoaded = false;

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
    _resourcesBloc.add(GetCaategoriesEvent());
    setState(() {
      _categoriesLoaded = false;
    });
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

  void _showDeleteCategoryConfirmationDialog(
      BuildContext context, Categories category) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'حذف التصنيف',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا التصنيف؟',
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
                // Uncomment when you implement delete category functionality
                _resourcesBloc.add(DeleteCategoryEvent(id: category.id!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'سيتم حذف التصنيف قريباً',
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
          'التصنيفات',
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
          if (state is GetCategoriesSuccess) {
            setState(() {
              _categoriesLoaded = true;
            });
          }
        },
        builder: (context, state) {
          if (state is ResourcesLoading && !_categoriesLoaded) {
            return _buildShimmerLoader();
          }
          if (state is GetCategoriesSuccess) {
            return _buildCategoriesListView(state.model, textColor);
          }
          if (state is ResourcesError) {
            return _buildErrorWidget(state.message, textColor);
          }
          // Initial state - load categories
          if (!_categoriesLoaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _resourcesBloc.add(GetCaategoriesEvent());
            });
          }
          return _buildShimmerLoader();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoriesListView(CategoryModel? categories, Color textColor) {
    if (categories?.categories == null || categories!.categories!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد تصنيفات حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      itemCount: categories.categories!.length,
      itemBuilder: (context, index) {
        final category = categories.categories![index];
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
              category.name ?? 'No Name',
              style: TextStyle(
                color: textColor,
                fontFamily: AppConstants.primaryFont,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: () =>
                  _showDeleteCategoryConfirmationDialog(context, category),
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
