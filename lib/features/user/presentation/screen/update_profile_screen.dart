import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fp_sharing_photo/features/user/presentation/provider/get_logged_user_provider.dart';
import 'package:fp_sharing_photo/features/user/presentation/provider/update_profile_provider.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _bioController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(getLoggedUserProvider.notifier).getLoggedUser();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _bioController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getLoggedUserState = ref.watch(getLoggedUserProvider);
    final updateState = ref.watch(updateProfileProvider);
    final updateNotifier = ref.read(updateProfileProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        actions: [
          TextButton(
            onPressed: updateState.isLoading || getLoggedUserState.isLoading
                ? null
                : () async {
                    final success = await updateNotifier.updateProfile(
                      name: _nameController.text,
                      username: _usernameController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneNumberController.text,
                      bio: _bioController.text,
                      website: _websiteController.text,
                    );

                    if (success) {
                      if (!context.mounted) return;

                      await ref
                          .read(getLoggedUserProvider.notifier)
                          .getLoggedUser();

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully'),
                        ),
                      );
                    }
                  },
            child: const Text('Save'),
          ),
        ],
      ),
      body: getLoggedUserState.isLoading && _nameController.text.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : getLoggedUserState.error != null
          ? Center(child: Text('Error: ${getLoggedUserState.error}'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController
                      ..text = getLoggedUserState.user?.name ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController
                      ..text = getLoggedUserState.user?.username ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController
                      ..text = getLoggedUserState.user?.email ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController
                      ..text = getLoggedUserState.user?.phoneNumber ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController
                      ..text = getLoggedUserState.user?.bio ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _websiteController
                      ..text = getLoggedUserState.user?.website ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Website',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (updateState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Update Error: ${updateState.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (updateState.isLoading) const LinearProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
