import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:start/core/api_service/network_api_service_http.dart';
import 'package:start/features/Resources/Bloc/bloc/resources_bloc.dart';

class UploadGlbScreen extends StatefulWidget {
  static const String routeName = '/upload_glb';
  final String? itemId;

  const UploadGlbScreen({super.key, this.itemId = '1'});

  @override
  State<UploadGlbScreen> createState() => _UploadGlbScreenState();
}

class _UploadGlbScreenState extends State<UploadGlbScreen> {
  PlatformFile? _glbPlatformFile;
  PlatformFile? _thumbnailPlatformFile;
  String? _glbError;
  String? _thumbnailError;
  late Flutter3DController _modelController;

  @override
  void initState() {
    super.initState();
    _modelController = Flutter3DController();
  }

  Future<void> _pickGlbFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['glb'],
      withData: true, // Ensure bytes are loaded
    );

    if (result != null) {
      setState(() {
        _glbPlatformFile = result.files.single;
        _glbError = null;
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      withData: true, // Ensure bytes are loaded
    );

    if (result != null) {
      setState(() {
        _thumbnailPlatformFile = result.files.single;
        _thumbnailError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResourcesBloc(client: NetworkApiServiceHttp()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload 3D Model'),
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocConsumer<ResourcesBloc, ResourcesState>(
          listener: (context, state) {
            if (state is ResourcesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 3D Model Preview Section - Now shows uploaded model
                  if (state is UploadedGLBSuccess)
                    _buildModelViewer(context, state.glbUrl) // Added context
                  else
                    _buildFileSelectionPreview(context),
                  const SizedBox(height: 24),

                  // File selection sections
                  if (state is! UploadedGLBSuccess) ...[
                    _buildFileSection(
                      label: '3D Model File (GLB)',
                      file: _glbPlatformFile,
                      error: _glbError,
                      onPressed: _pickGlbFile,
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    _buildFileSection(
                      label: 'Thumbnail Image (Optional)',
                      file: _thumbnailPlatformFile,
                      error: _thumbnailError,
                      onPressed: _pickThumbnail,
                    ),
                    const SizedBox(height: 32),
                  ],

                  // Upload Button
                  if (state is! UploadedGLBSuccess)
                    ElevatedButton(
                      onPressed: state is ResourcesLoading
                          ? null
                          : () => _uploadFiles(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: state is ResourcesLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('UPLOAD FILES',
                              style: TextStyle(fontSize: 16)),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('BACK TO ITEM'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _viewInNewTab(
                                context, (state as UploadedGLBSuccess).glbUrl),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                            ),
                            child: const Text('VIEW IN 3D'),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _uploadFiles(BuildContext context) {
    if (_glbPlatformFile == null) {
      setState(() => _glbError = 'Please select a GLB file');
      return;
    }

    // Handle all platforms using bytes
    final modelBytes = _glbPlatformFile?.bytes;
    final modelName = _glbPlatformFile?.name;

    if (modelBytes == null || modelName == null) {
      setState(() => _glbError = 'Could not read GLB file content');
      return;
    }

    Uint8List? thumbnailBytes;
    String? thumbnailName;

    if (_thumbnailPlatformFile != null) {
      thumbnailBytes = _thumbnailPlatformFile?.bytes;
      thumbnailName = _thumbnailPlatformFile?.name;

      if (thumbnailBytes == null) {
        setState(() => _thumbnailError = 'Could not read thumbnail content');
        return;
      }
    }

    context.read<ResourcesBloc>().add(
          UploadGLBEvent(
            modelBytes: modelBytes,
            modelName: modelName,
            thumbnailBytes: thumbnailBytes,
            thumbnailName: thumbnailName,
            itemId: widget.itemId!,
          ),
        );
  }

  Widget _buildFileSection({
    required String label,
    required PlatformFile? file,
    required VoidCallback onPressed,
    String? error,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: required ? Colors.red : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.attach_file, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    file?.name ?? 'Tap to select file...',
                    style: TextStyle(
                      color: file != null ? Colors.black : Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildModelViewer(BuildContext context, String glbUrl) {
    // Added context
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uploaded Model Preview',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Flutter3DViewer(
            controller: _modelController,
            src: glbUrl,
            progressBarColor: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _modelController.playAnimation(),
              tooltip: 'Play Animation',
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () => _modelController.pauseAnimation(),
              tooltip: 'Pause Animation',
            ),
            IconButton(
              icon: const Icon(Icons.replay),
              onPressed: () => _modelController.resetAnimation(),
              tooltip: 'Reset Animation',
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () => _modelController.resetCameraTarget(),
              tooltip: 'Reset Camera',
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: () => _viewInNewTab(context, glbUrl),
              tooltip: 'Open in New Tab',
            ),
          ],
        ),
      ],
    );
  }

  void _viewInNewTab(BuildContext context, String glbUrl) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $glbUrl in new tab')),
    );
  }

  Widget _buildFileSelectionPreview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Model Preview',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[100],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.model_training, size: 60, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  _glbPlatformFile != null
                      ? 'Ready to upload: ${_glbPlatformFile!.name}'
                      : 'Select a GLB file to upload',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                if (_glbPlatformFile != null)
                  Text(
                    'Upload to preview the model',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    'Tap to choose file',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
