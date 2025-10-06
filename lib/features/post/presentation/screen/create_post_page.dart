import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/core/constants/app_colors.dart';
import 'package:fp_sharing_photo/core/widgets/form/text_field_widget.dart';
import 'package:fp_sharing_photo/core/widgets/loading_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fp_sharing_photo/features/post/presentation/provider/create_post_provider.dart';
import 'package:fp_sharing_photo/features/post/presentation/provider/upload_image_provider.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final _captionController = TextEditingController();
  XFile? _selectedImageFile; // Ganti dari String ke XFile
  Uint8List? _selectedImageBytes;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Baca bytes dari XFile
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageFile = image;
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _takePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Baca bytes dari XFile
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImageFile = image;
        _selectedImageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadImageProvider);
    final postState = ref.watch(createPostProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildImagePreview(),
            const SizedBox(height: 16),

            // const SizedBox(height: 16),
            if (uploadState.isLoading) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 8),
              const Text('Uploading image...'),
            ],
            if (uploadState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Upload Error: ${uploadState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),

            // const SizedBox(height: 8),
            CustomTextField(
              controller: _captionController,
              labelText: 'Caption',
              maxLines: 5,
            ),

            const SizedBox(height: 24),
            if (postState.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Post Error: ${postState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      // Floating Bottom Action Bar
      bottomNavigationBar: _buildFloatingBottomBar(),
    );
  }

  void _buildBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose image source',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Pick Image'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _pickImage();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePreview() {
    return SizedBox(
      height: 450,
      child: _selectedImageFile == null
          ? Container(
              height: 450,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: BorderRadius.circular(8),
                color: AppColors.surface,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 48),
                    SizedBox(height: 16),
                    Text(
                      'No image selected',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please select an image to continue',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 450,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
              ),
            ),
    );
  }

  Widget _buildFloatingBottomBar() {
    final uploadState = ref.watch(uploadImageProvider);
    final uploadNotifier = ref.read(uploadImageProvider.notifier);
    final postState = ref.watch(createPostProvider);
    final postNotifier = ref.read(createPostProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: SafeArea(
        child: Row(
          children: [
            ElevatedButton(
              onPressed: _buildBottomSheet,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: postState.isLoading
                  ? const Center(child: GlobalLoadingWidget())
                  : ElevatedButton(
                      onPressed: _selectedImageFile == null
                          ? null
                          : () async {
                              // Upload image dulu
                              final imageUrl = await uploadNotifier.uploadImage(
                                _selectedImageFile!,
                              );

                              if (imageUrl == null) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Upload image failed: ${uploadState.error}',
                                    ),
                                  ),
                                );
                                return;
                              }

                              // Lalu create post
                              final success = await postNotifier.createPost(
                                imageUrl,
                                _captionController.text,
                              );

                              if (success) {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Post berhasil dibuat'),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
