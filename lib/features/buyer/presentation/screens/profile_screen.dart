import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/buyer_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _budgetController = TextEditingController();
  final _propertyTypeController = TextEditingController();
  bool _initialized = false;

  void _updateProfile() async {
    try {
      final repository = ref.read(buyerRepositoryProvider);
      await repository.updateProfile(
        email: _emailController.text.trim(),
        name: _nameController.text.trim().isEmpty ? null : _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        budget: double.tryParse(_budgetController.text.trim()),
        preferredPropertyType: _propertyTypeController.text.trim().isEmpty ? null : _propertyTypeController.text.trim(),
      );
      ref.invalidate(buyerProfileProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(buyerProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Profile')),
      body: profileAsync.when(
        data: (profile) {
          if (!_initialized) {
            _emailController.text = profile.email;
            _nameController.text = profile.name ?? '';
            _phoneController.text = profile.phone ?? '';
            _budgetController.text = profile.budget?.toString() ?? '';
            _propertyTypeController.text = profile.preferredPropertyType ?? '';
            _initialized = true;
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${profile.id}'),
                const SizedBox(height: 8),
                Text('Role: ${profile.role}'),
                const SizedBox(height: 8),
                Text('Verified: ${profile.isVerified ? "Yes" : "No"}'),
                if (profile.faydaId != null) ...[
                  const SizedBox(height: 8),
                  Text('Fayda ID: ${profile.faydaId}'),
                ],
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Budget (ETB)'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _propertyTypeController,
                  decoration: const InputDecoration(labelText: 'Preferred Property Type (e.g. SALE, RENT)'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Update Profile'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
