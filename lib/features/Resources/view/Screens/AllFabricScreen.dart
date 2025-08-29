import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart'; // Import your resources BLoC
import 'package:start/features/Resources/Models/AllFabricModel.dart'; // Import your fabric model
import 'package:start/features/Resources/view/Screens/AddNewFabricScreen.dart'; // Import add fabric screen

class AllFabricScreen extends StatefulWidget {
  static const String routeName = '/all-fabric';

  const AllFabricScreen({super.key});

  @override
  State<AllFabricScreen> createState() => _AllFabricScreenState();
}

class _AllFabricScreenState extends State<AllFabricScreen> {
  late ResourcesBloc _resourcesBloc;
  bool _fabricLoaded = false;

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
    _resourcesBloc = ResourcesBloc(
        client: NetworkApiServiceHttp()); // Initialize your resources BLoC
  }

  void _handleRefresh() {
    _resourcesBloc.add(GetAllFabricEvent());
    setState(() {
      _fabricLoaded = false;
    });
  }

  void _showEditFabricDialog(BuildContext context, Fabric fabric) {
    final _formKey = GlobalKey<FormState>();
    final _priceController =
        TextEditingController(text: fabric.pricePerMeter?.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocListener<ResourcesBloc, ResourcesState>(
          listener: (context, state) {
            if (state is EditFabricSuccess) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'تم تعديل سعر القماش بنجاح',
                    style: TextStyle(fontFamily: AppConstants.primaryFont),
                  ),
                ),
              );
              // Refresh the list after successful edit
              _resourcesBloc.add(GetAllFabricEvent());
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
                      'تعديل سعر القماش',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppConstants.primaryFont,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'نوع القماش: ${fabric.type ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppConstants.primaryFont,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'اللون: ${fabric.color ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppConstants.primaryFont,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'السعر للمتر',
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.cardRadius),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال السعر للمتر';
                        }
                        if (double.tryParse(value) == null) {
                          return 'يرجى إدخال سعر صحيح';
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
                                EditFabricEvent(
                                  id: fabric.id!,
                                  price: _priceController.text,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider.value(
      value: _resourcesBloc,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: _buildAppBar(context, textColor),
        body: _buildBody(context, textColor),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to AddNewFabricScreen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: _resourcesBloc,
                  child: const AddNewFabricScreen(),
                ),
              ),
            );
          },
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
      title: Text(
        'جميع أنواع الأقمشة',
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
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _handleRefresh,
          tooltip: 'تحديث',
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, Color textColor) {
    return BlocConsumer<ResourcesBloc, ResourcesState>(
      listener: (context, state) {
        if (state is GetAllFabricSuccess) {
          _fabricLoaded = true;
        }
      },
      builder: (context, state) {
        if (state is ResourcesLoading) {
          return _buildShimmerLoader();
        }
        if (state is GetAllFabricSuccess) {
          return _buildFabricListView(state.fabric, textColor);
        }
        if (state is ResourcesError) {
          return _buildErrorWidget(state.message, textColor);
        }
        // Initial state - load fabric
        if (!_fabricLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _resourcesBloc.add(GetAllFabricEvent());
          });
        }
        return _buildShimmerLoader();
      },
    );
  }

  Widget _buildFabricListView(AllFabricModel fabrics, Color textColor) {
    if (fabrics.fabric == null || fabrics.fabric!.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد أنواع أقمشة حالياً',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _handleRefresh();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.sectionPadding),
        itemCount: fabrics.fabric!.length,
        itemBuilder: (context, index) {
          final fabric = fabrics.fabric![index];
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
              contentPadding: const EdgeInsets.all(16),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fabric.type ?? 'No Type',
                    style: TextStyle(
                      color: textColor,
                      fontFamily: AppConstants.primaryFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildFabricDetailRow(
                    Icons.color_lens,
                    'اللون:',
                    fabric.color ?? 'N/A',
                    textColor,
                  ),
                  const SizedBox(height: 4),
                  _buildFabricDetailRow(
                    Icons.attach_money,
                    'السعر للمتر:',
                    '${fabric.pricePerMeter ?? 'N/A'} ر.س',
                    textColor,
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
                      _showEditFabricDialog(context, fabric);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () =>
                        _showDeleteFabricConfirmationDialog(context, fabric),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFabricDetailRow(
      IconData icon, String label, String value, Color textColor) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: textColor.withOpacity(0.7),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontFamily: AppConstants.primaryFont,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              color: textColor,
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _handleRefresh,
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteFabricConfirmationDialog(
      BuildContext context, Fabric fabric) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'حذف نوع القماش',
            style: TextStyle(
              fontFamily: AppConstants.primaryFont,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أن你 تريد حذف هذا النوع من القماش؟',
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
                // Add delete fabric event
                _resourcesBloc.add(DeleteFabricEvent(id: fabric.id!));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'سيتم حذف نوع القماش قريباً',
                      style: TextStyle(fontFamily: AppConstants.primaryFont),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
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
    _resourcesBloc.close();
    super.dispose();
  }
}
