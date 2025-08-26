import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/core/constants/app_constants.dart';
import 'package:start/features/SubGallery/Bloc/BranchesBloc/branches_bloc.dart';
import 'package:start/features/SubGallery/Models/SubManagersModel.dart';
import 'package:start/features/SubGallery/view/Widgets/MapPickerScreen.dart';

class AddNewBranchPage extends StatefulWidget {
  static const String routeName = '/add_new_branch';

  const AddNewBranchPage({super.key});

  @override
  State<AddNewBranchPage> createState() => _AddNewBranchPageState();
}

class _AddNewBranchPageState extends State<AddNewBranchPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _subManagerIdController = TextEditingController();

  LatLng? _selectedLocation;
  bool _isLoading = false;

  @override
  void dispose() {
    _addressController.dispose();
    _subManagerIdController.dispose();
    super.dispose();
  }

  Future<void> _pickLocation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPickerScreen()),
    );

    if (result != null && result is LatLng) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  void _showSubManagersDialog(BuildContext context, SubManagersModel managers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر المدير',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.primaryFont,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: managers.managers == null || managers.managers!.isEmpty
                      ? Center(
                          child: Text(
                            'لا يوجد مدراء متاحين',
                            style: TextStyle(
                              fontFamily: AppConstants.primaryFont,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: managers.managers!.length,
                          itemBuilder: (context, index) {
                            final manager = managers.managers![index];
                            return _buildManagerTile(context, manager);
                          },
                        ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
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

  Widget _buildManagerTile(BuildContext context, Managers manager) {
    final textColor = Theme.of(context).colorScheme.onBackground;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: (manager.image != null &&
                  manager.image is String &&
                  manager.image!.isNotEmpty)
              ? NetworkImage(manager.image!)
              : const AssetImage('assets/default_user.png') as ImageProvider,
          child: (manager.image == null || manager.image!.isEmpty)
              ? Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                )
              : null,
        ),
        title: Text(
          manager.name ?? 'No Name',
          style: TextStyle(
            color: textColor,
            fontFamily: AppConstants.primaryFont,
          ),
        ),
        subtitle: Text(
          manager.email ?? 'No Email',
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontFamily: AppConstants.primaryFont,
          ),
        ),
        trailing: Text(
          'ID: ${manager.id}',
          style: TextStyle(
            color: textColor.withOpacity(0.7),
            fontFamily: AppConstants.primaryFont,
          ),
        ),
        onTap: () {
          _subManagerIdController.text = manager.id?.toString() ?? '';
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onBackground;

    return BlocProvider(
      create: (context) => BranchesBloc(client: NetworkApiServiceHttp())
        ..add(GetSubManagersEvent()),
      child: BlocConsumer<BranchesBloc, BranchesState>(
        listener: (context, state) {
          if (state is BranchesLoading) {
            setState(() => _isLoading = true);
          } else if (state is AddNewBranchSuccess) {
            setState(() => _isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'تم إضافة الفرع بنجاح',
                  style: TextStyle(fontFamily: AppConstants.primaryFont),
                ),
              ),
            );
            Navigator.pop(context);
          } else if (state is BranchesError) {
            setState(() => _isLoading = false);
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
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: _buildAppBar(context, textColor),
            body: _buildBody(context, textColor, state),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Color textColor) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      elevation: 0,
      title: Text(
        'إضافة فرع جديد',
        style: TextStyle(
          color: textColor,
          fontFamily: AppConstants.primaryFont,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: textColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, Color textColor, BranchesState state) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.sectionPadding),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            // Address Field
            TextFormField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
              style: TextStyle(
                fontFamily: AppConstants.primaryFont,
                color: textColor,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجى إدخال العنوان';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Sub Manager ID Field
            GestureDetector(
              onTap: () {
                if (state is GetSubManagersSuccess) {
                  _showSubManagersDialog(context, state.managers);
                } else {
                  // If managers aren't loaded yet, try to load them
                  context.read<BranchesBloc>().add(GetSubManagersEvent());
                  // Show a loading indicator or message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'جاري تحميل قائمة المدراء...',
                        style: TextStyle(fontFamily: AppConstants.primaryFont),
                      ),
                    ),
                  );
                }
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: _subManagerIdController,
                  decoration: InputDecoration(
                    labelText: 'معرف المدير',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardRadius),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                  ),
                  style: TextStyle(
                    fontFamily: AppConstants.primaryFont,
                    color: textColor,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى اختيار المدير';
                    }
                    if (int.tryParse(value) == null) {
                      return 'يرجى إدخال رقم صحيح';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Location Picker Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
              child: ListTile(
                leading: Icon(
                  Icons.map,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(
                  'اختيار الموقع على الخريطة',
                  style: TextStyle(
                    fontFamily: AppConstants.primaryFont,
                    color: textColor,
                  ),
                ),
                subtitle: _selectedLocation != null
                    ? Text(
                        'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(
                          fontFamily: AppConstants.primaryFont,
                          color: textColor.withOpacity(0.7),
                        ),
                      )
                    : Text(
                        'لم يتم اختيار موقع',
                        style: TextStyle(
                          fontFamily: AppConstants.primaryFont,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _pickLocation(context),
              ),
            ),
            const SizedBox(height: AppConstants.elementSpacing),

            // Submit Button

            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() &&
                    _selectedLocation != null) {
                  // Dispatch event to add new branch
                  context.read<BranchesBloc>().add(
                        AddNewBranchEvent(
                          latitude: _selectedLocation!.latitude,
                          longitude: _selectedLocation!.longitude,
                          adress: _addressController.text,
                          subId: int.parse(_subManagerIdController.text),
                        ),
                      );
                } else if (_selectedLocation == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'يرجى اختيار موقع على الخريطة',
                        style: TextStyle(fontFamily: AppConstants.primaryFont),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
              ),
              child: Text(
                'إضافة الفرع',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppConstants.primaryFont,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
