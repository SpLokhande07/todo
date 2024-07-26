import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pod/profile_pod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profileNotifier = ref.read(profileProvider.notifier);
    profileNotifier.loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut().then((val) {
                Navigator.pushReplacementNamed(context, '/login');
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: profileState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () =>
                          ref.read(profileProvider.notifier).pickImage(),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: profileState.profileImageUrl != null
                            ? NetworkImage(profileState.profileImageUrl!)
                            : null,
                        child: profileState.profileImageUrl == null
                            ? const Icon(Icons.add_a_photo)
                            : null,
                      ),
                    ),
                    TextFormField(
                      controller: _nameController..text = profileState.name,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _dobController..text = profileState.dob,
                      decoration:
                          const InputDecoration(labelText: 'Date of Birth'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ref.read(profileProvider.notifier).updateProfile(
                                _nameController.text,
                                _dobController.text,
                              );
                        }
                      },
                      child: const Text('Update Profile'),
                    ),
                    if (profileState.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          profileState.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
