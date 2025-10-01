import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Tambahkan import
import '../../data/upload_image_repository.dart';

// State untuk upload image
class UploadImageState {
  final bool isLoading;
  final String? imageUrl;
  final String? error;

  UploadImageState({this.isLoading = false, this.imageUrl, this.error});

  UploadImageState copyWith({
    bool? isLoading,
    String? imageUrl,
    String? error,
  }) {
    return UploadImageState(
      isLoading: isLoading ?? this.isLoading,
      imageUrl: imageUrl ?? this.imageUrl,
      error: error ?? this.error,
    );
  }
}

// Notifier untuk upload image
class UploadImageNotifier extends Notifier<UploadImageState> {
  @override
  UploadImageState build() {
    return UploadImageState();
  }

  UploadImageRepository get _repository =>
      ref.read(uploadImageRepositoryProvider);

  // Ganti parameter ke XFile
  Future<String?> uploadImage(XFile imageFile) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final imageUrl = await _repository.uploadImage(imageFile);

      state = state.copyWith(isLoading: false, imageUrl: imageUrl);
      return imageUrl;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }
}

// Provider untuk repository
final uploadImageRepositoryProvider = Provider<UploadImageRepository>((ref) {
  return UploadImageRepository();
});

// Provider untuk notifier
final uploadImageProvider =
    NotifierProvider<UploadImageNotifier, UploadImageState>(() {
      return UploadImageNotifier();
    });
