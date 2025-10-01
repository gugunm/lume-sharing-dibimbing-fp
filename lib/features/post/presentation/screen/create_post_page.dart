import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  @override
  Widget build(BuildContext context) {
    final uploadState = ref.watch(uploadImageProvider);
    final uploadNotifier = ref.read(uploadImageProvider.notifier);
    final postState = ref.watch(createPostProvider);
    final postNotifier = ref.read(createPostProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImageBytes != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(_selectedImageBytes!, fit: BoxFit.cover),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('No image selected')),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
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
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Caption',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
            postState.isLoading
                ? const CircularProgressIndicator()
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
                    child: const Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }
}
